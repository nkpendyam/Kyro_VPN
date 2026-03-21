CREATE TABLE IF NOT EXISTS nodes (
    id             TEXT PRIMARY KEY,
    public_key     TEXT NOT NULL UNIQUE,
    playit_address TEXT NOT NULL,
    city           TEXT,
    country_code   TEXT,
    flag_emoji     TEXT,
    is_seed        INTEGER DEFAULT 0,
    is_online      INTEGER DEFAULT 0,
    bandwidth_mbps INTEGER DEFAULT 0,
    latency_ms     INTEGER DEFAULT 0,
    online_users   INTEGER DEFAULT 0,
    uptime_pct     REAL DEFAULT 0,
    last_seen      DATETIME,
    joined_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS node_blacklists (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    node_id     TEXT REFERENCES nodes(id),
    platform    TEXT NOT NULL,
    detected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    cleared_at  DATETIME
);

CREATE TABLE IF NOT EXISTS credits (
    device_id    TEXT PRIMARY KEY,
    balance      INTEGER DEFAULT 0,
    total_earned INTEGER DEFAULT 0,
    total_spent  INTEGER DEFAULT 0,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS credit_transactions (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    device_id  TEXT NOT NULL,
    amount     INTEGER NOT NULL,
    reason     TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS health_logs (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    node_id        TEXT REFERENCES nodes(id),
    latency_ms     INTEGER,
    bandwidth_mbps INTEGER,
    peer_count     INTEGER,
    logged_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS abuse_reports (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    node_id     TEXT REFERENCES nodes(id),
    report_type TEXT NOT NULL,
    reported_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved    INTEGER DEFAULT 0
);
