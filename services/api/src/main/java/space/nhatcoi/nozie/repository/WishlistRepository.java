package space.nhatcoi.nozie.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.entity.WishlistItem;

public interface WishlistRepository extends JpaRepository<WishlistItem, WishlistItem.Id> {

    @Query(value = "select m from Movie m, WishlistItem w where w.id.movieId = m.id and w.id.userId = :userId "
            + "and (lower(m.name) like :pattern escape '\\' or lower(m.originName) like :pattern escape '\\') order by w.createdAt desc",
            countQuery = "select count(w) from WishlistItem w, Movie m where w.id.movieId = m.id and w.id.userId = :userId "
                    + "and (lower(m.name) like :pattern escape '\\' or lower(m.originName) like :pattern escape '\\')")
    Page<Movie> findMoviesByUser(@Param("userId") UUID userId, @Param("pattern") String pattern, Pageable pageable);

    @Query("select w.id.movieId from WishlistItem w where w.id.userId = :userId")
    List<UUID> findMovieIds(@Param("userId") UUID userId);
}
