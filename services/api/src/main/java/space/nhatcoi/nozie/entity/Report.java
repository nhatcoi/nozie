package space.nhatcoi.nozie.entity;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "reports")
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "movie_id", nullable = false)
    private UUID movieId;

    @Column(nullable = false, length = 64)
    private String reason;

    @Column(length = 1000)
    private String detail;

    @Column(nullable = false, length = 16)
    private String status = "OPEN";

    @Column(name = "created_at", nullable = false, insertable = false, updatable = false)
    private Instant createdAt;

    protected Report() {
    }

    public Report(UUID userId, UUID movieId, String reason, String detail) {
        this.userId = userId;
        this.movieId = movieId;
        this.reason = reason;
        this.detail = detail;
    }

    public UUID getId() {
        return id;
    }
}
