"""
AMD (Answering Machine Detection) analyzer.

Algorithm:
  1. Split 16 kHz / 16-bit PCM audio into 30 ms frames.
  2. Run WebRTC VAD on each frame to label it speech or silence.
  3. Detect beep patterns via FFT (sustained single-frequency tone).
  4. Classify based on:
       - Presence of beep        → MACHINE (high confidence)
       - Long initial silence    → MACHINE (recording lag)
       - Short initial greeting  → HUMAN
       - Long continuous speech  → MACHINE (recorded message)
       - No speech at all        → UNKNOWN
"""

import struct
from typing import List, Tuple

import numpy as np
import webrtcvad

from .models import AMDConfig, AMDMode, AMDResult

# PCM constants
SAMPLE_RATE = 16000
FRAME_DURATION_MS = 30
FRAME_SAMPLES = int(SAMPLE_RATE * FRAME_DURATION_MS / 1000)  # 480
FRAME_BYTES = FRAME_SAMPLES * 2                               # 960 (16-bit)


class AMDAnalyzer:
    def analyze(self, audio_bytes: bytes, config: AMDConfig) -> Tuple[AMDResult, float]:
        frames = self._split_frames(audio_bytes)
        if not frames:
            return AMDResult.UNKNOWN, 0.0

        vad = webrtcvad.Vad(config.vad_sensitivity)
        speech_flags: List[bool] = []
        for frame in frames:
            try:
                speech_flags.append(vad.is_speech(frame, SAMPLE_RATE))
            except Exception:
                speech_flags.append(False)

        samples = self._decode_pcm(audio_bytes)

        if self._detect_beep(samples):
            return AMDResult.MACHINE, 0.88

        return self._classify_by_vad(speech_flags, config)

    # ── Internal helpers ──────────────────────────────────────────────────────

    def _split_frames(self, audio_bytes: bytes) -> List[bytes]:
        return [
            audio_bytes[i: i + FRAME_BYTES]
            for i in range(0, len(audio_bytes) - FRAME_BYTES + 1, FRAME_BYTES)
        ]

    def _decode_pcm(self, audio_bytes: bytes) -> np.ndarray:
        n_samples = len(audio_bytes) // 2
        samples = struct.unpack(f"<{n_samples}h", audio_bytes[:n_samples * 2])
        return np.array(samples, dtype=np.float32) / 32768.0

    def _detect_beep(self, samples: np.ndarray, min_duration_s: float = 0.4) -> bool:
        """
        Detect a sustained single-frequency tone in 440–2000 Hz (answering machine beep).
        Returns True when >70 % of spectral power is concentrated in one frequency bin
        over a window of at least min_duration_s seconds.
        """
        window = int(SAMPLE_RATE * min_duration_s)
        if len(samples) < window:
            return False

        # Analyse last portion where the beep typically appears
        chunk = samples[-window:]
        fft_mag = np.abs(np.fft.rfft(chunk))
        freqs = np.fft.rfftfreq(len(chunk), d=1.0 / SAMPLE_RATE)

        mask = (freqs >= 440) & (freqs <= 2000)
        if not mask.any():
            return False

        total_power = fft_mag.sum()
        if total_power == 0:
            return False

        peak_power = fft_mag[mask].max()
        return (peak_power / total_power) > 0.70

    def _classify_by_vad(
        self, speech_flags: List[bool], config: AMDConfig
    ) -> Tuple[AMDResult, float]:
        total = len(speech_flags)
        if total == 0:
            return AMDResult.UNKNOWN, 0.0

        # Index of first speech frame
        first_speech = next((i for i, f in enumerate(speech_flags) if f), None)
        if first_speech is None:
            return AMDResult.UNKNOWN, 0.50

        initial_silence_ms = first_speech * FRAME_DURATION_MS

        # Adjust thresholds by mode
        thresholds = {
            AMDMode.AGGRESSIVE:   (1500, 1000),
            AMDMode.BALANCED:     (config.initial_silence_tolerance_ms, config.greeting_limit_ms),
            AMDMode.CONSERVATIVE: (4000, 3000),
        }
        silence_threshold, greeting_threshold = thresholds[config.mode]

        if initial_silence_ms > silence_threshold:
            return AMDResult.MACHINE, 0.72

        # Count consecutive speech frames from the first speech onset
        consecutive = 0
        for flag in speech_flags[first_speech:]:
            if flag:
                consecutive += 1
            else:
                break

        greeting_ms = consecutive * FRAME_DURATION_MS

        if greeting_ms <= greeting_threshold:
            return AMDResult.HUMAN, 0.76

        return AMDResult.MACHINE, 0.71
