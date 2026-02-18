import base64
import logging
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException

from .amd import AMDAnalyzer
from .config import settings
from .models import AMDConfig, AMDRequest, AMDResponse

logging.basicConfig(level=settings.log_level.upper())
logger = logging.getLogger(__name__)

_analyzer = AMDAnalyzer()


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("AMD service starting")
    yield
    logger.info("AMD service stopped")


app = FastAPI(
    title="AMD Service",
    description="Answering Machine Detection microservice",
    version="0.1.0",
    lifespan=lifespan,
)


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/analyze", response_model=AMDResponse)
def analyze(request: AMDRequest) -> AMDResponse:
    t0 = time.monotonic()

    try:
        audio_bytes = base64.b64decode(request.audio_base64)
    except Exception:
        raise HTTPException(status_code=422, detail="audio_base64 is not valid base64")

    if len(audio_bytes) < 960:  # < 30 ms of audio
        raise HTTPException(status_code=422, detail="Audio too short (minimum 30 ms)")

    config = request.config or AMDConfig()

    result, confidence = _analyzer.analyze(audio_bytes, config)

    elapsed_ms = int((time.monotonic() - t0) * 1000)

    logger.info(
        "call_id=%s client_id=%s result=%s confidence=%.2f time_ms=%d",
        request.call_id,
        request.client_id,
        result.value,
        confidence,
        elapsed_ms,
    )

    return AMDResponse(
        result=result,
        confidence=round(confidence, 4),
        analysis_time_ms=elapsed_ms,
        call_id=request.call_id,
    )
