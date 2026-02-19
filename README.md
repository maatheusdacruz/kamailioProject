# SIP Platform with Kamailio + FreeSWITCH + AMD

A scalable, multi-tenant SIP platform for intelligent outbound call management with Answering Machine Detection (AMD).

## Architecture

```
                    ┌─────────────────┐
                    │   SIP Clients   │
                    │   (Dialers)     │
                    └────────┬────────┘
                             │ INVITE (port 5060)
                    ┌────────▼────────┐
                    │    HAProxy      │  TCP load balancer
                    │   (port 5060)   │  health checks + failover
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │    Kamailio     │  SIP routing, auth, multi-tenant
                    │   (port 5061)   │  dispatcher, dialog management
                    │   (port 5064)   │  JSONRPC for Siremis
                    └────────┬────────┘
                             │ SIP (port 5080)
                    ┌────────▼────────┐
                    │   FreeSWITCH    │  Media handling, RTP
                    │   (port 5080)   │  AMD flow execution
                    └────────┬────────┘
                             │ HTTP POST /analyze
                    ┌────────▼────────┐
                    │   AMD Service   │  Python/FastAPI
                    │   (port 8080)   │  VAD + classification
                    └─────────────────┘

         ┌──────────┐  ┌──────────┐  ┌──────────┐
         │PostgreSQL│  │  Redis   │  │ Siremis  │
         │  (5432)  │  │  (6379)  │  │  (8088)  │
         └──────────┘  └──────────┘  └──────────┘
```

### Call Flow (Outbound)

1. Dialer sends SIP INVITE to HAProxy (port 5060)
2. HAProxy forwards to Kamailio (port 5061)
3. Kamailio identifies tenant, selects FreeSWITCH via dispatcher module
4. FreeSWITCH (port 5080) answers, starts AMD flow
5. FreeSWITCH sends audio buffer to AMD microservice (HTTP POST)
6. AMD returns classification: `HUMAN`, `MACHINE`, `FAX`, or `UNKNOWN`
7. FreeSWITCH applies decision: HUMAN → continue, MACHINE → hangup/transfer

---

## Prerequisites

- **Docker** 24+ and **Docker Compose** v2
- **SignalWire Personal Access Token** (free) — required for FreeSWITCH packages
  - Create one at https://id.signalwire.com/personal_access_tokens
- Ports available: 5060 (SIP), 5061, 5064, 5080, 6379, 5432, 8080, 8088, 8404

---

## Quick Start

```bash
# 1. Clone and enter the project
git clone <repository-url>
cd kamailioProject

# 2. Configure environment
cp .env.example .env
# Edit .env and set your SIGNALWIRE_TOKEN

# 3. Build and start all services
docker-compose build
docker-compose up -d

# 4. Verify services are running
docker-compose ps

# 5. Follow logs
docker-compose logs -f
```

### Verify the stack

```bash
# Check HAProxy stats page
curl http://127.0.0.1:8404/stats

# Check AMD service health
curl http://127.0.0.1:8080/health

# Check Kamailio JSONRPC
curl -s -X POST http://127.0.0.1:5064/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"core.version","id":1}'

# Access Siremis web interface
# Open http://127.0.0.1:8088/siremis/ in your browser
```

---

## Services

### HAProxy (Load Balancer)

| Property | Value |
|---|---|
| Image | `haproxy:2.8-alpine` |
| Network | host |
| SIP Port | 5060 (TCP) |
| Stats | http://127.0.0.1:8404/stats |
| Config | `haproxy/haproxy.cfg` |

HAProxy is the external entry point for SIP traffic. It performs TCP load balancing across Kamailio nodes with health checks and automatic failover.

**How it works:**
- Listens on port 5060 for incoming SIP connections (TCP mode)
- Forwards traffic to Kamailio backend nodes using round-robin
- Health checks run every 5 seconds (TCP connect to port 5061)
- A node is marked down after 3 failed checks and up after 2 successful checks
- The stats page at port 8404 shows backend health and traffic metrics

**Configuration (`haproxy/haproxy.cfg`):**
- `frontend sip_tcp_in` — binds port 5060, routes to kamailio_nodes backend
- `backend kamailio_nodes` — round-robin to Kamailio at 127.0.0.1:5061
- To add HA nodes, add more `server` lines in the backend section

---

### Kamailio (SIP Control Layer)

| Property | Value |
|---|---|
| Build | `kamailio/Dockerfile` |
| Network | host |
| SIP Port | 5061 (UDP/TCP) |
| JSONRPC Port | 5064 (TCP) |
| Config | `kamailio/config/kamailio.cfg` |

Kamailio is the SIP proxy responsible for all signaling logic. It handles routing, authentication, multi-tenant identification, and FreeSWITCH selection. Kamailio does **not** process media.

**How it works:**
- Receives SIP INVITE from HAProxy on port 5061
- Uses the `dispatcher` module to select a FreeSWITCH node (round-robin with failover)
- Monitors FreeSWITCH health via SIP OPTIONS pings every 10 seconds
- If a FreeSWITCH node fails, dispatcher automatically tries the next node
- Exposes JSONRPC on port 5064 for Siremis management

**Key modules:**
- `dispatcher` — load balances across FreeSWITCH nodes
- `dialog` — tracks active call dialogs
- `tm` — SIP transaction management
- `rr` — Record-Route for in-dialog requests
- `xhttp` + `jsonrpcs` — HTTP JSONRPC interface for Siremis

**Database initialization:**
On first startup, the Kamailio entrypoint script automatically creates standard Kamailio database tables in PostgreSQL using `kamdbctl`. This includes tables for location, subscriber, dispatcher, dialog, and more.

**Dispatcher configuration (`kamailio/config/dispatcher.list`):**
```
# setid destination flags priority attributes
1 sip:127.0.0.1:5080 0 0
```
Add more FreeSWITCH nodes by adding lines with setid `1`.

**JSONRPC usage:**
```bash
# Get Kamailio version
curl -X POST http://127.0.0.1:5064/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"core.version","id":1}'

# List active dialogs
curl -X POST http://127.0.0.1:5064/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"dlg.list","id":1}'

# Reload dispatcher list
curl -X POST http://127.0.0.1:5064/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"dispatcher.reload","id":1}'
```

---

### FreeSWITCH (Media Layer)

| Property | Value |
|---|---|
| Build | `freeswitch/Dockerfile` |
| Network | host |
| SIP Port | 5080 (UDP/TCP) |
| ESL Port | 8021 (TCP, loopback only) |
| Config | `freeswitch/config/` |
| Build arg | `SIGNALWIRE_TOKEN` (required) |

FreeSWITCH handles all media processing — RTP, audio recording, tone generation, and AMD flow execution. It receives SIP from Kamailio and processes calls according to its dialplan.

**How it works:**
- Accepts SIP calls from Kamailio on port 5080 (no authentication — Kamailio handles it)
- ACL restricts SIP to loopback and RFC-1918 networks
- Phase 1 (current): answers, plays a tone stream, and hangs up (validates SIP+media flow)
- Phase 3 (AMD): records first 4 seconds of audio, sends to AMD service, applies decision

**Configuration files:**
| File | Purpose |
|---|---|
| `freeswitch.xml` | Main config — includes all other files |
| `vars.xml` | Variables: codec prefs, RTP ports, AMD endpoint |
| `autoload_configs/sofia.conf.xml` | SIP profile "kamailio" on port 5080 |
| `autoload_configs/modules.conf.xml` | Module loading list |
| `autoload_configs/event_socket.conf.xml` | ESL interface (port 8021, password ClueCon) |
| `autoload_configs/acl.conf.xml` | Network ACL (loopback + RFC-1918) |
| `dialplan/default.xml` | Call routing logic |

**SignalWire Token:**
FreeSWITCH packages are distributed by SignalWire and require a free Personal Access Token for download. Set it in `.env`:
```bash
SIGNALWIRE_TOKEN=pat_xxxxxxxxxxxxxxx
```
Get a token at: https://id.signalwire.com/personal_access_tokens

**ESL (Event Socket Layer):**
```bash
# Connect to FreeSWITCH console (from the host)
docker-compose exec freeswitch fs_cli -H 127.0.0.1 -P 8021 -p ClueCon

# List active calls
fs_cli -x "show calls"

# Check Sofia status
fs_cli -x "sofia status"
```

**Enabling AMD (Phase 3):**
In `freeswitch/config/dialplan/default.xml`, uncomment the Phase 3 block and comment out the Phase 1 tone playback. This enables the AMD flow where FreeSWITCH records audio and sends it to the AMD service for classification.

---

### AMD Service (Answering Machine Detection)

| Property | Value |
|---|---|
| Build | `amd_service/Dockerfile` |
| Network | bridge |
| Port | 8080 |
| Framework | Python 3.11 / FastAPI |
| Health check | `GET /health` |

The AMD microservice analyzes audio buffers to classify call answers as HUMAN, MACHINE, FAX, or UNKNOWN. It is stateless and horizontally scalable.

**How it works:**
1. Receives base64-encoded PCM audio via HTTP POST
2. Splits audio into 30ms frames
3. Runs WebRTC VAD (Voice Activity Detection) on each frame
4. Analyzes speech patterns: initial silence, greeting duration, beep detection
5. Returns JSON classification with confidence score

**Endpoints:**

`GET /health` — Health check
```json
{"status": "ok"}
```

`POST /analyze` — Analyze audio for AMD classification

Request:
```json
{
  "call_id": "unique-call-id",
  "client_id": "tenant-id",
  "audio_base64": "<base64-encoded PCM audio>",
  "sample_rate": 16000,
  "config": {
    "max_analysis_time_ms": 5000,
    "initial_silence_tolerance_ms": 2500,
    "greeting_limit_ms": 1500,
    "vad_sensitivity": 2,
    "mode": "balanced"
  }
}
```

Response:
```json
{
  "result": "HUMAN",
  "confidence": 0.76,
  "analysis_time_ms": 142,
  "call_id": "unique-call-id"
}
```

**Audio format:** Raw PCM, 16 kHz sample rate, 16-bit signed, mono, little-endian. Minimum 30ms (960 bytes). Recommended: 2-4 seconds for reliable classification.

**Classification logic:**

| Pattern | Result | Confidence |
|---|---|---|
| Beep detected (440-2000 Hz sustained tone) | MACHINE | 0.88 |
| Initial silence > threshold | MACHINE | 0.72 |
| Short continuous speech (< greeting limit) | HUMAN | 0.76 |
| Long continuous speech (> greeting limit) | MACHINE | 0.71 |
| No speech detected | UNKNOWN | 0.50 |

**Per-client configuration:**

| Parameter | Default | Range | Description |
|---|---|---|---|
| `max_analysis_time_ms` | 5000 | 1000-15000 | Maximum analysis window |
| `initial_silence_tolerance_ms` | 2500 | 500-8000 | Silence before first speech |
| `greeting_limit_ms` | 1500 | 500-5000 | Max greeting duration for HUMAN |
| `vad_sensitivity` | 2 | 0-3 | VAD aggressiveness (3 = most aggressive) |
| `mode` | balanced | aggressive/balanced/conservative | Detection strategy |

**Running tests:**
```bash
cd amd_service
pip install -r requirements.txt
pytest -v
```

---

### Siremis (Web Management Interface)

| Property | Value |
|---|---|
| Build | `siremis/Dockerfile` |
| Network | bridge |
| Port | 8088 |
| URL | http://127.0.0.1:8088/siremis/ |
| Stack | PHP 8.2 + Apache |

Siremis is the official web management interface for Kamailio. It provides a GUI for managing SIP users, dispatcher lists, routing rules, dialog monitoring, and system status.

**How it works:**
- Connects to the Kamailio PostgreSQL database for configuration management
- Uses Kamailio's JSONRPC interface (port 5064) for runtime control and monitoring
- Provides a web UI for common Kamailio administration tasks

**First-time setup:**

1. Start the stack: `docker-compose up -d`
2. Open http://127.0.0.1:8088/siremis/ in your browser
3. Complete the setup wizard:
   - **Database engine:** PostgreSQL (pgsql)
   - **Database host:** `postgres` (Docker service name)
   - **Database port:** `5432`
   - **Database name:** `kamailio`
   - **Database user:** `kamailio`
   - **Database password:** `kamailio`
   - **Admin username:** choose your admin login
   - **Admin password:** choose your admin password
4. Configure Kamailio JSONRPC connection:
   - **JSONRPC URL:** `http://host.docker.internal:5064/jsonrpc`

**Features:**
- **SIP User Management** — add, edit, delete SIP subscribers
- **Dispatcher Management** — manage FreeSWITCH node lists with web UI
- **Dialog Monitoring** — view active calls in real-time
- **Accounting** — view call records and statistics
- **System Status** — Kamailio runtime stats via JSONRPC
- **Configuration Editor** — modify Kamailio parameters

---

### PostgreSQL (Data Layer)

| Property | Value |
|---|---|
| Image | `postgres:16-alpine` |
| Network | bridge |
| Port | 5432 |
| Default DB | `kamailio` |
| Init script | `database/schema.sql` |

PostgreSQL stores all persistent data: tenant configuration, SIP trunks, routing rules, AMD settings, and call history.

**Database schema (`database/schema.sql`):**

| Table | Purpose |
|---|---|
| `clients` | Multi-tenant client registry (UUID, name, code) |
| `trunks` | SIP trunks per client (host, port, credentials, direction) |
| `routing_rules` | Pattern-based routing per client (regex, destination, priority) |
| `amd_configs` | Per-client AMD settings (timing thresholds, VAD, mode) |
| `call_records` | Call history with AMD results and timing metadata |

Standard Kamailio tables (location, subscriber, dispatcher, dialog, etc.) are created automatically by the Kamailio entrypoint on first startup.

**Connecting to the database:**
```bash
# From the host
psql -h 127.0.0.1 -U kamailio -d kamailio

# From within Docker
docker-compose exec postgres psql -U kamailio -d kamailio

# List all tables
\dt

# View active clients
SELECT * FROM clients WHERE active = true;
```

**Data persistence:**
Data is stored in the `postgres_data` Docker volume. To reset the database completely:
```bash
docker-compose down -v  # removes volumes
docker-compose up -d    # recreates from scratch
```

---

### Redis (Ephemeral State)

| Property | Value |
|---|---|
| Image | `redis:7-alpine` |
| Network | bridge |
| Port | 6379 |
| Persistence | RDB snapshots every 60s |

Redis stores ephemeral state: call flags, configuration cache, and CPS (Calls Per Second) rate limiting.

**How it works:**
- Kamailio uses Redis (via ndb_redis module) for fast state lookups during SIP routing
- Call flags and temporary data are stored with TTLs
- Configuration cache reduces database load during high CPS
- RDB persistence saves snapshots to disk for crash recovery

**Connecting to Redis:**
```bash
# From the host
redis-cli -h 127.0.0.1 -p 6379

# From within Docker
docker-compose exec redis redis-cli

# Check memory usage
INFO memory

# List all keys (development only)
KEYS *
```

---

## Configuration

### Environment Variables (`.env`)

| Variable | Default | Description |
|---|---|---|
| `DB_USER` | kamailio | PostgreSQL username |
| `DB_PASS` | kamailio | PostgreSQL password |
| `DB_NAME` | kamailio | PostgreSQL database name |
| `LOG_LEVEL` | info | AMD service log level |
| `AMD_WORKERS` | 4 | AMD service uvicorn workers |
| `SIGNALWIRE_TOKEN` | *(required)* | SignalWire PAT for FreeSWITCH packages |
| `AMD_SERVICE_URL` | http://127.0.0.1:8080 | FreeSWITCH → AMD service endpoint |

### Network Ports

| Port | Service | Protocol | Purpose |
|---|---|---|---|
| 5060 | HAProxy | TCP | External SIP entry point |
| 5061 | Kamailio | UDP/TCP | SIP (behind HAProxy) |
| 5064 | Kamailio | TCP | JSONRPC for Siremis |
| 5080 | FreeSWITCH | UDP/TCP | SIP (from Kamailio) |
| 8021 | FreeSWITCH | TCP | ESL (loopback only) |
| 8080 | AMD Service | TCP | HTTP REST API |
| 8088 | Siremis | TCP | Web management UI |
| 5432 | PostgreSQL | TCP | Database |
| 6379 | Redis | TCP | Cache/state |
| 8404 | HAProxy | TCP | Stats page |
| 16384-32768 | FreeSWITCH | UDP | RTP media |

---

## Development

### Rebuilding a single service

```bash
docker-compose build kamailio
docker-compose up -d kamailio
```

### Viewing logs

```bash
# All services
docker-compose logs -f

# Specific services
docker-compose logs -f kamailio freeswitch amd_service

# Last 100 lines
docker-compose logs --tail=100 kamailio
```

### Running AMD tests locally

```bash
cd amd_service
pip install -r requirements.txt
pytest -v

# Single test
pytest tests/test_amd.py::test_human_detection -v
```

### AMD service local development

```bash
cd amd_service
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8080
```

### Testing SIP flow

```bash
# Send a test INVITE using sipsak (install: apt install sipsak)
sipsak -s sip:test@127.0.0.1:5060

# Or using pjsua (install: apt install pjsip-apps)
pjsua --null-audio sip:test@127.0.0.1:5060
```

---

## Development Phases

| Phase | Description | Status |
|---|---|---|
| 1 | Base structure — Docker, inter-service communication | Complete |
| 2 | Minimal SIP flow — Kamailio routing to FreeSWITCH | Active |
| 3 | AMD integration — FreeSWITCH → AMD → decision | Planned |
| 4 | Multi-tenant — DB schema, per-client config, headers | Planned |
| 5 | HA — Multiple nodes, load balancing, failover | Planned |

---

## Troubleshooting

### FreeSWITCH build fails

**Symptom:** `docker-compose build freeswitch` fails with authentication error.

**Solution:** Ensure `SIGNALWIRE_TOKEN` is set in `.env`:
```bash
grep SIGNALWIRE_TOKEN .env
# Should show: SIGNALWIRE_TOKEN=pat_xxxxx
```
Get a free token at https://id.signalwire.com/personal_access_tokens

### Kamailio cannot reach FreeSWITCH

**Symptom:** Kamailio logs `No FreeSWITCH available in dispatcher group 1`.

**Check:**
```bash
# Verify FreeSWITCH is running and listening on 5080
docker-compose ps freeswitch
ss -tlnp | grep 5080

# Check dispatcher status via JSONRPC
curl -X POST http://127.0.0.1:5064/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"dispatcher.list","id":1}'
```

### AMD service not responding

**Symptom:** FreeSWITCH cannot reach AMD service.

**Check:**
```bash
curl http://127.0.0.1:8080/health
docker-compose logs amd_service
```

### Siremis shows database connection error

**Check:**
- Database host should be `postgres` (Docker service name), not `localhost`
- Database port: `5432`
- Credentials match `.env` values

### Siremis cannot connect to Kamailio JSONRPC

**Check:**
- JSONRPC URL should be `http://host.docker.internal:5064/jsonrpc`
- Verify Kamailio is listening on 5064:
```bash
ss -tlnp | grep 5064
```

### Port conflicts

**Symptom:** Service fails to start with "address already in use".

**Check:**
```bash
# Find what's using a port
ss -tlnp | grep <port>
# or
lsof -i :<port>
```

### Reset everything

```bash
# Stop all services and remove volumes (deletes all data)
docker-compose down -v

# Rebuild and restart
docker-compose build --no-cache
docker-compose up -d
```

---

## Project Structure

```
kamailioProject/
├── docker-compose.yml          # Service orchestration
├── .env                        # Environment configuration
├── .env.example                # Environment template
├── CLAUDE.md                   # Claude Code instructions
├── CONTEXT.md                  # Business context (Portuguese)
├── ARCHITECTURE.md             # Technical architecture
├── README.md                   # This file
├── kamailio/
│   ├── Dockerfile              # Kamailio 5.7 from Debian packages
│   ├── entrypoint.sh           # DB init + startup
│   ├── kamctlrc                # kamdbctl configuration
│   └── config/
│       ├── kamailio.cfg        # Main SIP routing config
│       └── dispatcher.list     # FreeSWITCH node list
├── freeswitch/
│   ├── Dockerfile              # FreeSWITCH from SignalWire packages
│   └── config/
│       ├── freeswitch.xml      # Main config (includes others)
│       ├── vars.xml            # Variables and AMD endpoint
│       ├── dialplan/
│       │   └── default.xml     # Call routing (Phase 1: tone, Phase 3: AMD)
│       └── autoload_configs/
│           ├── modules.conf.xml      # Module loading
│           ├── sofia.conf.xml        # SIP profile on port 5080
│           ├── event_socket.conf.xml # ESL control interface
│           └── acl.conf.xml          # Network ACL
├── amd_service/
│   ├── Dockerfile              # Python 3.11 slim
│   ├── requirements.txt        # Python dependencies
│   ├── app/
│   │   ├── main.py             # FastAPI endpoints
│   │   ├── models.py           # Pydantic request/response models
│   │   ├── amd.py              # AMD analysis engine
│   │   └── config.py           # Settings
│   └── tests/
│       └── test_amd.py         # Unit and integration tests
├── siremis/
│   ├── Dockerfile              # PHP 8.2 + Apache
│   └── apache-siremis.conf     # Apache virtual host
├── database/
│   └── schema.sql              # Custom tables (clients, trunks, AMD, etc.)
└── haproxy/
    └── haproxy.cfg             # TCP load balancer config
```
