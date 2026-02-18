# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

A scalable, multi-tenant SIP platform combining:
- **Kamailio** – SIP control layer (routing, auth, multi-tenant, dispatcher)
- **FreeSWITCH** – Media layer (RTP, AMD flow execution)
- **AMD Microservice** – Python/FastAPI service for answering machine detection
- **PostgreSQL** – Persistent storage (clients, trunks, routing rules, AMD config, call history)
- **Redis** – Ephemeral state (call flags, config cache, CPS rate limiting)
- **HAProxy** – TCP load balancer for SIP, health checks, failover

The file `CONTEXT.md` is the source of truth for business/project decisions. `ARCHITECTURE.md` contains the full technical architecture. Both must be kept in sync with any implementation changes.

---

## Directory Structure (Target)

```
kamailio/config/       # Kamailio configuration files (.cfg, dispatcher lists)
freeswitch/config/     # FreeSWITCH dialplan, sofia config
amd_service/
  app/                 # FastAPI application code
  tests/               # Unit tests
database/              # SQL migrations/schemas
docker/                # Dockerfiles and docker-compose files
docs/                  # Additional documentation
```

---

## Development Environment

The environment runs via Docker with `network_mode: host` for SIP/media components.

```bash
cp .env.example .env          # configure before first run
docker compose up -d          # start all services
docker compose logs -f        # follow all logs
docker compose logs -f kamailio freeswitch amd_service
docker compose down           # stop and remove containers
```

FreeSWITCH requires a free **SignalWire Personal Access Token** passed as a build arg:
```bash
docker compose build --build-arg SIGNALWIRE_TOKEN=<your-token> freeswitch
```

---

## AMD Microservice (Python/FastAPI)

### Run locally (development)
```bash
cd amd_service
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8080
```

### Run all tests
```bash
cd amd_service
pytest
```

### Run a single test
```bash
cd amd_service
pytest tests/test_amd.py::test_human_detection -v
```

---

## AMD API Contract

FreeSWITCH calls the AMD service via HTTP REST. The response format is fixed:

```json
{
  "result": "HUMAN | MACHINE | FAX | UNKNOWN",
  "confidence": 0.0,
  "analysis_time_ms": 0
}
```

Per-client AMD configuration (stored in PostgreSQL, passed in request):
- `max_analysis_time` – maximum analysis window in ms
- `initial_silence_tolerance` – silence threshold before first speech
- `greeting_limit` – maximum greeting duration
- `vad_sensitivity` – VAD aggressiveness level
- `mode` – `aggressive | balanced | conservative`

---

## Architecture Constraints

- **Kamailio** handles SIP signaling only — no media, no AMD logic.
- **FreeSWITCH** handles media only — no complex SIP routing logic.
- **AMD service** is stateless — must scale horizontally without shared in-process state.
- No hardcoded IPs — use environment variables or service discovery.
- No blocking database calls from Kamailio's critical SIP path.
- Redis is the only allowed shared ephemeral state store.
- Docker containers use `network_mode: host` for SIP/RTP; do not change this.

---

## Call Flow (Outbound)

1. Dialer sends INVITE → HAProxy → Kamailio
2. Kamailio identifies tenant, selects FreeSWITCH via dispatcher module, inserts AMD headers
3. FreeSWITCH answers, starts AMD flow
4. FreeSWITCH sends audio buffer → AMD microservice (HTTP)
5. AMD returns classification
6. FreeSWITCH applies decision: HUMAN → continue, MACHINE → hangup/transfer

---

## Key Kamailio Modules

`dispatcher`, `dialog`, `tm`, `sl`, `rr`, `pv`, `xlog`, `sqlops`, `htable`, `topos`, `dmq` (future replication)

## Key FreeSWITCH Modules

`mod_sofia`, `mod_event_socket`, `mod_lua` (optional), `mod_http_cache` (optional)

---

## Development Phases

1. **Base structure** – folders, Docker, basic inter-service communication
2. **Minimal SIP flow** – Kamailio routing to FreeSWITCH, call completing
3. **AMD integration** – FreeSWITCH → Python AMD → decision applied
4. **Multi-tenant** – DB schema, per-client config, dynamic headers
5. **HA** – multiple nodes, load balancing, failover

Validate each phase fully before advancing.

---

## Documentation Update Rules

When adding components, changing flows, or modifying dependencies:
1. Update `CONTEXT.md` if business rules or decisions change
2. Update `ARCHITECTURE.md` if technical structure changes
3. Update `README.md` if setup/execution/configuration changes
