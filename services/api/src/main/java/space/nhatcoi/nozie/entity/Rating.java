package space.nhatcoi.nozie.entity;

import java.io.Serializable;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "ratings")
public class Rating extends BaseEntity {

    @Embeddable
    public record Id(@Column(name = "user_id") UUID userId, @Column(name = "movie_id") UUID movieId) implements Serializable {
    }

    @EmbeddedId
    private Id id;

    @Column(nullable = false)
    private short rating;

    @Column(columnDefinition = "text")
    private String review;

    protected Rating() {
    }

    public Rating(UUID userId, UUID movieId, short rating, String review) {
        this.id = new Id(userId, movieId);
        this.rating = rating;
        this.review = review;
    }

    public Id getId() {
        return id;
    }

    public short getRating() {
        return rating;
    }

    public String getReview() {
        return review;
    }

    public void update(short rating, String review) {
        this.rating = rating;
        this.review = review;
    }
}
