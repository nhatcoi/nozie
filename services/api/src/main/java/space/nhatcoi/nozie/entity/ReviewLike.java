package space.nhatcoi.nozie.entity;

import java.io.Serializable;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "review_likes")
public class ReviewLike {

    @Embeddable
    public record Id(@Column(name = "user_id") UUID userId, @Column(name = "movie_id") UUID movieId,
            @Column(name = "review_user_id") UUID reviewUserId) implements Serializable {
    }

    @EmbeddedId
    private Id id;

    protected ReviewLike() {
    }

    public ReviewLike(UUID userId, UUID movieId, UUID reviewUserId) {
        this.id = new Id(userId, movieId, reviewUserId);
    }

    public Id getId() {
        return id;
    }
}
