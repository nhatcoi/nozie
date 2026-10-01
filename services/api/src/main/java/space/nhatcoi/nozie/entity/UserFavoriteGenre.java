package space.nhatcoi.nozie.entity;

import java.io.Serializable;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "user_favorite_genres")
public class UserFavoriteGenre {

    @Embeddable
    public record Id(@Column(name = "user_id") UUID userId, @Column(name = "genre_id") Short genreId) implements Serializable {
    }

    @EmbeddedId
    private Id id;

    protected UserFavoriteGenre() {
    }

    public UserFavoriteGenre(UUID userId, Short genreId) {
        this.id = new Id(userId, genreId);
    }

    public Id getId() {
        return id;
    }
}
