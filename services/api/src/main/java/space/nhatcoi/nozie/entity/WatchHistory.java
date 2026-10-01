package space.nhatcoi.nozie.entity;

import java.io.Serializable;
import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "watch_history")
public class WatchHistory {

    @Embeddable
    public record Id(@Column(name = "user_id") UUID userId, @Column(name = "movie_id") UUID movieId) implements Serializable {
    }

    @EmbeddedId
    private Id id;

    @Column(name = "episode_id")
    private UUID episodeId;

    @Column(name = "position_seconds", nullable = false)
    private int positionSeconds;

    @Column(name = "duration_seconds", nullable = false)
    private int durationSeconds;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();

    protected WatchHistory() {
    }

    public WatchHistory(UUID userId, UUID movieId) {
        this.id = new Id(userId, movieId);
    }

    public Id getId() {
        return id;
    }

    public UUID getEpisodeId() {
        return episodeId;
    }

    public int getPositionSeconds() {
        return positionSeconds;
    }

    public int getDurationSeconds() {
        return durationSeconds;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void record(UUID episodeId, int positionSeconds, int durationSeconds) {
        this.episodeId = episodeId;
        this.positionSeconds = positionSeconds;
        this.durationSeconds = durationSeconds;
        this.updatedAt = Instant.now();
    }
}
