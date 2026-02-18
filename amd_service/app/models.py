from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field


class AMDResult(str, Enum):
    HUMAN = "HUMAN"
    MACHINE = "MACHINE"
    FAX = "FAX"
    UNKNOWN = "UNKNOWN"


class AMDMode(str, Enum):
    AGGRESSIVE = "aggressive"
    BALANCED = "balanced"
    CONSERVATIVE = "conservative"


class AMDConfig(BaseModel):
    """Per-client AMD configuration. All values are stored in PostgreSQL (Phase 4)."""

    max_analysis_time_ms: int = Field(default=5000, ge=1000, le=15000)
    initial_silence_tolerance_ms: int = Field(default=2500, ge=500, le=8000)
    greeting_limit_ms: int = Field(default=1500, ge=500, le=5000)
    vad_sensitivity: int = Field(default=2, ge=0, le=3)
    mode: AMDMode = AMDMode.BALANCED


class AMDRequest(BaseModel):
    """
    Audio must be raw PCM: 16 kHz, 16-bit signed, mono, little-endian.
    Encode bytes as base64 before sending.
    Minimum recommended duration: 2 s (32 000 bytes).
    """

    call_id: str
    client_id: Optional[str] = None
    audio_base64: str
    sample_rate: int = Field(default=16000)
    config: Optional[AMDConfig] = None


class AMDResponse(BaseModel):
    result: AMDResult
    confidence: float = Field(ge=0.0, le=1.0)
    analysis_time_ms: int
    call_id: str
