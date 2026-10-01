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
@Table(name = "wishlist")
public class WishlistItem {

    @Embeddable
    public record Id(@Column(name = "user_id") UUID userId, @Column(name = "movie_id") UUID movieId) implements Serializable {
    }

    @EmbeddedId
    private Id id;

    @Column(name = "created_at", nullable = false, insertable = false, updatable = false)
    private Instant createdAt;

    protected WishlistItem() {
    }

    public WishlistItem(UUID userId, UUID movieId) {
        this.id = new Id(userId, movieId);
    }

    public Id getId() {
        return id;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
