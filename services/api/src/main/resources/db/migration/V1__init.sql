-- Nozie initial schema. Money is always integer minor units (cents). Timestamps are UTC.

CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ───────────── identity ─────────────

CREATE TABLE users (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email          VARCHAR(320) NOT NULL,
    password_hash  VARCHAR(255),                       -- null for Google-only accounts
    google_sub     VARCHAR(64),
    email_verified BOOLEAN      NOT NULL DEFAULT FALSE,
    full_name      VARCHAR(120) NOT NULL DEFAULT '',
    username       VARCHAR(40),
    phone          VARCHAR(32),
    date_of_birth  DATE,
    gender         VARCHAR(16),
    country        VARCHAR(64),
    avatar_key     VARCHAR(255),                       -- object-storage key, never a public URL
    role           VARCHAR(16)  NOT NULL DEFAULT 'USER',
    enabled        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT chk_users_role CHECK (role IN ('USER', 'ADMIN')),
    CONSTRAINT chk_users_credential CHECK (password_hash IS NOT NULL OR google_sub IS NOT NULL)
);
CREATE UNIQUE INDEX uq_users_email ON users (lower(email));
CREATE UNIQUE INDEX uq_users_username ON users (lower(username)) WHERE username IS NOT NULL;
CREATE UNIQUE INDEX uq_users_google_sub ON users (google_sub) WHERE google_sub IS NOT NULL;

CREATE TABLE user_preferences (
    user_id        UUID PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    language       VARCHAR(8)  NOT NULL DEFAULT 'vi',
    theme          VARCHAR(16) NOT NULL DEFAULT 'system',
    notifications  JSONB       NOT NULL DEFAULT '{}'::jsonb,
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE refresh_tokens (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    family_id   UUID        NOT NULL,                  -- rotation family; reuse of a revoked token revokes the family
    token_hash  CHAR(64)    NOT NULL,                  -- SHA-256 hex of the opaque token
    expires_at  TIMESTAMPTZ NOT NULL,
    revoked_at  TIMESTAMPTZ,
    user_agent  VARCHAR(255),
    ip          VARCHAR(45),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_refresh_tokens_hash ON refresh_tokens (token_hash);
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens (user_id);
CREATE INDEX idx_refresh_tokens_family ON refresh_tokens (family_id);

CREATE TABLE password_resets (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    otp_hash          VARCHAR(255) NOT NULL,
    attempts          SMALLINT    NOT NULL DEFAULT 0,  -- belongs to this OTP, not reset by re-sending
    expires_at        TIMESTAMPTZ NOT NULL,
    verified_at       TIMESTAMPTZ,
    reset_token_hash  CHAR(64),
    consumed_at       TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_password_resets_user ON password_resets (user_id, created_at DESC);
CREATE UNIQUE INDEX uq_password_resets_token ON password_resets (reset_token_hash) WHERE reset_token_hash IS NOT NULL;

-- ───────────── catalog ─────────────

CREATE TABLE genres (
    id    SMALLSERIAL PRIMARY KEY,
    slug  VARCHAR(80)  NOT NULL UNIQUE,
    name  VARCHAR(120) NOT NULL
);

CREATE TABLE movies (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_id           VARCHAR(64),                 -- id from the legacy Firestore/source dataset
    slug                  VARCHAR(255) NOT NULL UNIQUE,
    name                  VARCHAR(255) NOT NULL,
    origin_name           VARCHAR(255),
    type                  VARCHAR(32)  NOT NULL,       -- single | series | ...
    status                VARCHAR(32),
    content               TEXT,
    trailer_url           VARCHAR(1024),
    poster_url            VARCHAR(1024),
    thumb_url             VARCHAR(1024),
    quality               VARCHAR(32),
    duration              VARCHAR(64),
    lang                  VARCHAR(64),
    year                  SMALLINT,
    view_count            BIGINT       NOT NULL DEFAULT 0,
    episode_current       VARCHAR(64),
    episode_total         VARCHAR(64),
    is_cinema             BOOLEAN      NOT NULL DEFAULT FALSE,
    sub_exclusive         BOOLEAN      NOT NULL DEFAULT FALSE,
    is_copyright          BOOLEAN      NOT NULL DEFAULT FALSE,
    directors             TEXT[]       NOT NULL DEFAULT '{}',
    actors                TEXT[]       NOT NULL DEFAULT '{}',
    alternative_names     TEXT[]       NOT NULL DEFAULT '{}',
    countries             JSONB        NOT NULL DEFAULT '[]'::jsonb,
    tmdb                  JSONB,
    imdb                  JSONB,
    price_cents           INTEGER      NOT NULL DEFAULT 0,   -- 0 = free
    currency              CHAR(3)      NOT NULL DEFAULT 'USD',
    original_created_at   TIMESTAMPTZ,
    original_modified_at  TIMESTAMPTZ,
    created_at            TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT chk_movies_price CHECK (price_cents >= 0)
);
CREATE UNIQUE INDEX uq_movies_original_id ON movies (original_id) WHERE original_id IS NOT NULL;
CREATE INDEX idx_movies_year ON movies (year);
CREATE INDEX idx_movies_type ON movies (type);
CREATE INDEX idx_movies_views ON movies (view_count DESC);
CREATE INDEX idx_movies_created ON movies (created_at DESC);
CREATE INDEX idx_movies_name_trgm ON movies USING gin (name gin_trgm_ops);
CREATE INDEX idx_movies_origin_name_trgm ON movies USING gin (origin_name gin_trgm_ops);

CREATE TABLE movie_genres (
    movie_id  UUID     NOT NULL REFERENCES movies (id) ON DELETE CASCADE,
    genre_id  SMALLINT NOT NULL REFERENCES genres (id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, genre_id)
);
CREATE INDEX idx_movie_genres_genre ON movie_genres (genre_id);

-- Stream sources are private: only exposed through the signed-URL playback endpoint after purchase check.
CREATE TABLE episodes (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    movie_id     UUID         NOT NULL REFERENCES movies (id) ON DELETE CASCADE,
    server_name  VARCHAR(120) NOT NULL DEFAULT '',
    name         VARCHAR(120) NOT NULL,
    slug         VARCHAR(120) NOT NULL,
    stream_url   VARCHAR(2048),
    embed_url    VARCHAR(2048),
    position     INTEGER      NOT NULL DEFAULT 0,
    UNIQUE (movie_id, server_name, slug)
);
CREATE INDEX idx_episodes_movie ON episodes (movie_id, position);

-- ───────────── commerce ─────────────

CREATE TABLE transactions (
    id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                   UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    movie_id                  UUID        NOT NULL REFERENCES movies (id),
    amount_cents              BIGINT      NOT NULL,
    currency                  CHAR(3)     NOT NULL,
    status                    VARCHAR(16) NOT NULL DEFAULT 'PENDING',
    stripe_payment_intent_id  VARCHAR(255),
    stripe_charge_id          VARCHAR(255),
    error_message             VARCHAR(512),
    created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    paid_at                   TIMESTAMPTZ,
    failed_at                 TIMESTAMPTZ,
    canceled_at               TIMESTAMPTZ,
    CONSTRAINT chk_transactions_amount CHECK (amount_cents >= 0),
    CONSTRAINT chk_transactions_status CHECK (status IN ('PENDING', 'SUCCEEDED', 'FAILED', 'CANCELED'))
);
CREATE UNIQUE INDEX uq_transactions_intent ON transactions (stripe_payment_intent_id) WHERE stripe_payment_intent_id IS NOT NULL;
CREATE INDEX idx_transactions_user ON transactions (user_id, created_at DESC);

-- Written only by the payment webhook; this is the source of truth for "can this user watch".
CREATE TABLE purchases (
    user_id         UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    movie_id        UUID        NOT NULL REFERENCES movies (id),
    transaction_id  UUID        REFERENCES transactions (id),
    purchased_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, movie_id)
);

-- Stripe may redeliver events; insert here first, skip when it already exists.
CREATE TABLE processed_events (
    event_id      VARCHAR(255) PRIMARY KEY,
    type          VARCHAR(100) NOT NULL,
    processed_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE stripe_customers (
    user_id             UUID PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    stripe_customer_id  VARCHAR(255) NOT NULL UNIQUE
);

-- ───────────── user activity ─────────────

CREATE TABLE wishlist (
    user_id     UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    movie_id    UUID        NOT NULL REFERENCES movies (id) ON DELETE CASCADE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, movie_id)
);

CREATE TABLE ratings (
    user_id     UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    movie_id    UUID        NOT NULL REFERENCES movies (id) ON DELETE CASCADE,
    rating      SMALLINT    NOT NULL,
    review      TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, movie_id),
    CONSTRAINT chk_ratings_range CHECK (rating BETWEEN 1 AND 5)
);
CREATE INDEX idx_ratings_movie ON ratings (movie_id);

CREATE TABLE watch_history (
    user_id           UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    movie_id          UUID        NOT NULL REFERENCES movies (id) ON DELETE CASCADE,
    episode_id        UUID        REFERENCES episodes (id) ON DELETE SET NULL,
    position_seconds  INTEGER     NOT NULL DEFAULT 0,
    duration_seconds  INTEGER     NOT NULL DEFAULT 0,
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, movie_id)
);
CREATE INDEX idx_watch_history_user ON watch_history (user_id, updated_at DESC);

CREATE TABLE reports (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    movie_id    UUID         NOT NULL REFERENCES movies (id) ON DELETE CASCADE,
    reason      VARCHAR(64)  NOT NULL,
    detail      VARCHAR(1000),
    status      VARCHAR(16)  NOT NULL DEFAULT 'OPEN',
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);
CREATE INDEX idx_reports_movie ON reports (movie_id);

CREATE TABLE notifications (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    type         VARCHAR(32)  NOT NULL,
    title        VARCHAR(200) NOT NULL,
    description  VARCHAR(1000),
    deep_link    VARCHAR(255),
    metadata     JSONB        NOT NULL DEFAULT '{}'::jsonb,
    read         BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT now()
);
CREATE INDEX idx_notifications_user ON notifications (user_id, created_at DESC);

CREATE TABLE user_favorite_genres (
    user_id   UUID     NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    genre_id  SMALLINT NOT NULL REFERENCES genres (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, genre_id)
);
