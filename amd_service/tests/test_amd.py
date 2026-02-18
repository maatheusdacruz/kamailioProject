"""
Unit tests for the AMD analyzer.

Audio helpers generate synthetic PCM signals:
  - silence()     → all zeros
  - speech()      → band-limited noise (simulates voice)
  - beep()        → pure 480 Hz tone (simulates answering-machine beep)
"""

import base64
import math
import struct

import pytest
from fastapi.testclient import TestClient

from app.amd import AMDAnalyzer
from app.main import app
from app.models import AMDConfig, AMDMode, AMDResult

SAMPLE_RATE = 16000


# ── Audio generators ──────────────────────────────────────────────────────────

def _pcm(samples: list[float]) -> bytes:
    """Convert float samples [-1, 1] to 16-bit PCM bytes."""
    clamped = [max(-1.0, min(1.0, s)) for s in samples]
    return struct.pack(f"<{len(clamped)}h", *[int(s * 32767) for s in clamped])


def silence(duration_s: float = 3.0) -> bytes:
    n = int(SAMPLE_RATE * duration_s)
    return _pcm([0.0] * n)


def speech(duration_s: float = 3.0, amplitude: float = 0.5) -> bytes:
    """Band-limited noise as a rough speech substitute."""
    import random
    rng = random.Random(42)
    n = int(SAMPLE_RATE * duration_s)
    raw = [rng.uniform(-amplitude, amplitude) for _ in range(n)]
    # Low-pass: simple running average to keep energy in voice band
    filtered = raw[:]
    for i in range(1, n):
        filtered[i] = 0.7 * filtered[i - 1] + 0.3 * raw[i]
    return _pcm(filtered)


def beep(duration_s: float = 1.0, freq_hz: float = 480.0, amplitude: float = 0.8) -> bytes:
    n = int(SAMPLE_RATE * duration_s)
    samples = [amplitude * math.sin(2 * math.pi * freq_hz * i / SAMPLE_RATE) for i in range(n)]
    return _pcm(samples)


def concat(*parts: bytes) -> bytes:
    return b"".join(parts)


# ── Unit tests: AMDAnalyzer ───────────────────────────────────────────────────

@pytest.fixture
def analyzer():
    return AMDAnalyzer()


@pytest.fixture
def default_config():
    return AMDConfig()


def test_short_greeting_is_human(analyzer, default_config):
    # 0.5s speech → short greeting → HUMAN
    audio = concat(speech(0.5))
    result, confidence = analyzer.analyze(audio, default_config)
    assert result == AMDResult.HUMAN
    assert confidence > 0.5


def test_long_initial_silence_is_machine(analyzer, default_config):
    # 3s silence then speech → answering-machine recording lag → MACHINE
    audio = concat(silence(3.0), speech(1.0))
    result, confidence = analyzer.analyze(audio, default_config)
    assert result == AMDResult.MACHINE
    assert confidence > 0.5


def test_long_continuous_speech_is_machine(analyzer, default_config):
    # 4s of unbroken speech → recorded message → MACHINE
    audio = speech(4.0)
    result, confidence = analyzer.analyze(audio, default_config)
    assert result == AMDResult.MACHINE


def test_beep_is_machine(analyzer, default_config):
    # Pure 480 Hz tone → beep → MACHINE (high confidence)
    audio = beep(1.0)
    result, confidence = analyzer.analyze(audio, default_config)
    assert result == AMDResult.MACHINE
    assert confidence >= 0.85


def test_pure_silence_is_unknown(analyzer, default_config):
    audio = silence(3.0)
    result, _ = analyzer.analyze(audio, default_config)
    assert result == AMDResult.UNKNOWN


def test_too_short_audio_returns_unknown(analyzer, default_config):
    # Less than one VAD frame → UNKNOWN
    result, _ = analyzer.analyze(b"\x00" * 100, default_config)
    assert result == AMDResult.UNKNOWN


def test_aggressive_mode_lower_thresholds(analyzer):
    config = AMDConfig(mode=AMDMode.AGGRESSIVE)
    # 1.6s silence (above aggressive threshold of 1500ms) → MACHINE
    audio = concat(silence(1.6), speech(1.0))
    result, _ = analyzer.analyze(audio, config)
    assert result == AMDResult.MACHINE


# ── Integration tests: FastAPI endpoint ──────────────────────────────────────

@pytest.fixture
def client():
    return TestClient(app)


def test_health(client):
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json()["status"] == "ok"


def test_analyze_endpoint_human(client):
    payload = {
        "call_id": "test-001",
        "client_id": "client-a",
        "audio_base64": base64.b64encode(speech(0.5)).decode(),
    }
    resp = client.post("/analyze", json=payload)
    assert resp.status_code == 200
    body = resp.json()
    assert body["call_id"] == "test-001"
    assert body["result"] in ("HUMAN", "MACHINE", "UNKNOWN", "FAX")
    assert 0.0 <= body["confidence"] <= 1.0
    assert body["analysis_time_ms"] >= 0


def test_analyze_endpoint_invalid_base64(client):
    payload = {
        "call_id": "test-002",
        "audio_base64": "!!!not-base64!!!",
    }
    resp = client.post("/analyze", json=payload)
    assert resp.status_code == 422


def test_analyze_endpoint_too_short(client):
    payload = {
        "call_id": "test-003",
        "audio_base64": base64.b64encode(b"\x00" * 100).decode(),
    }
    resp = client.post("/analyze", json=payload)
    assert resp.status_code == 422


def test_analyze_with_custom_config(client):
    payload = {
        "call_id": "test-004",
        "audio_base64": base64.b64encode(speech(0.5)).decode(),
        "config": {
            "max_analysis_time_ms": 3000,
            "vad_sensitivity": 3,
            "mode": "aggressive",
        },
    }
    resp = client.post("/analyze", json=payload)
    assert resp.status_code == 200
