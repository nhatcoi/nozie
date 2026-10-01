-- Phase B: ratings on the catalog, review likes, stored avatars.

-- 1. Movie rating on the 0-5 scale (source data stores TMDB/IMDB votes on a 0-10 scale).
ALTER TABLE movies
    ADD COLUMN rating       NUMERIC(3, 1),
    ADD COLUMN rating_count INTEGER NOT NULL DEFAULT 0,
    ADD CONSTRAINT chk_movies_rating CHECK (rating IS NULL OR (rating >= 0 AND rating <= 5));

UPDATE movies m
SET rating       = LEAST(5, ROUND((src.avg_vote / 2)::numeric, 1)),
    rating_count = COALESCE(src.votes, 0)
FROM (SELECT id,
             CASE WHEN jsonb_typeof(tmdb -> 'vote_average') = 'number' THEN (tmdb ->> 'vote_average')::numeric
                  WHEN jsonb_typeof(imdb -> 'vote_average') = 'number' THEN (imdb ->> 'vote_average')::numeric END AS avg_vote,
             CASE WHEN jsonb_typeof(tmdb -> 'vote_count') = 'number' THEN (tmdb ->> 'vote_count')::numeric::int
                  WHEN jsonb_typeof(imdb -> 'vote_count') = 'number' THEN (imdb ->> 'vote_count')::numeric::int END AS votes
      FROM movies) src
WHERE src.id = m.id AND src.avg_vote IS NOT NULL;

CREATE INDEX idx_movies_rating ON movies (rating DESC NULLS LAST);
CREATE INDEX idx_movies_price ON movies (price_cents);

-- 2. Likes on reviews. A like disappears with its review or its author.
CREATE TABLE review_likes (
    user_id         UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    movie_id        UUID        NOT NULL,
    review_user_id  UUID        NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, movie_id, review_user_id),
    FOREIGN KEY (review_user_id, movie_id) REFERENCES ratings (user_id, movie_id) ON DELETE CASCADE
);
CREATE INDEX idx_review_likes_review ON review_likes (movie_id, review_user_id);

-- 3. Avatars live in the database for now (small, validated images); swap for object storage behind AvatarStorage later.
CREATE TABLE user_avatars (
    user_id       UUID PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    content_type  VARCHAR(32)  NOT NULL,
    data          BYTEA        NOT NULL,
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT chk_user_avatars_size CHECK (octet_length(data) <= 2097152)
);
