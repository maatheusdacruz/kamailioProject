-- Kamailio SIP Platform – Initial Schema
-- PostgreSQL 16+

CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- for gen_random_uuid()

-- ── Tenants ──────────────────────────────────────────────────────────────────

CREATE TABLE clients (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    name       VARCHAR(255) NOT NULL,
    code       VARCHAR(100) NOT NULL UNIQUE,   -- used in SIP headers / routing
    active     BOOLEAN     NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Trunks ───────────────────────────────────────────────────────────────────

CREATE TABLE trunks (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id  UUID        NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name       VARCHAR(255) NOT NULL,
    host       VARCHAR(255) NOT NULL,
    port       INTEGER     NOT NULL DEFAULT 5060,
    username   VARCHAR(255),
    password   VARCHAR(255),
    direction  VARCHAR(20)  NOT NULL CHECK (direction IN ('inbound', 'outbound', 'both')),
    active     BOOLEAN     NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX trunks_client_idx ON trunks (client_id);

-- ── Routing rules ─────────────────────────────────────────────────────────────

CREATE TABLE routing_rules (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id   UUID        NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    pattern     VARCHAR(255) NOT NULL,   -- regex applied to destination number
    destination VARCHAR(255) NOT NULL,
    priority    INTEGER     NOT NULL DEFAULT 10,
    active      BOOLEAN     NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX routing_rules_client_idx ON routing_rules (client_id, active, priority);

-- ── Per-client AMD configuration ──────────────────────────────────────────────

CREATE TABLE amd_configs (
    id                          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id                   UUID        NOT NULL UNIQUE REFERENCES clients(id) ON DELETE CASCADE,
    enabled                     BOOLEAN     NOT NULL DEFAULT true,
    max_analysis_time_ms        INTEGER     NOT NULL DEFAULT 5000,
    initial_silence_tolerance_ms INTEGER   NOT NULL DEFAULT 2500,
    greeting_limit_ms           INTEGER     NOT NULL DEFAULT 1500,
    vad_sensitivity             SMALLINT    NOT NULL DEFAULT 2 CHECK (vad_sensitivity BETWEEN 0 AND 3),
    mode                        VARCHAR(20) NOT NULL DEFAULT 'balanced'
                                    CHECK (mode IN ('aggressive', 'balanced', 'conservative')),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Call records ──────────────────────────────────────────────────────────────

CREATE TABLE call_records (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    call_id              VARCHAR(255) NOT NULL UNIQUE,   -- SIP Call-ID
    client_id            UUID        REFERENCES clients(id),
    caller_number        VARCHAR(100),
    destination_number   VARCHAR(100),
    direction            VARCHAR(20),
    kamailio_node        VARCHAR(100),
    freeswitch_node      VARCHAR(100),
    amd_result           VARCHAR(20)  CHECK (amd_result IN ('HUMAN', 'MACHINE', 'FAX', 'UNKNOWN')),
    amd_confidence       NUMERIC(5, 4),
    amd_analysis_time_ms INTEGER,
    start_time           TIMESTAMPTZ,
    answer_time          TIMESTAMPTZ,
    end_time             TIMESTAMPTZ,
    hangup_cause         VARCHAR(100),
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX call_records_client_idx    ON call_records (client_id, created_at DESC);
CREATE INDEX call_records_callid_idx    ON call_records (call_id);
CREATE INDEX call_records_amd_result_idx ON call_records (amd_result, created_at DESC);
