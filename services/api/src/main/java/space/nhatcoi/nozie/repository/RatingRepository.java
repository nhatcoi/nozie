package space.nhatcoi.nozie.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.Rating;

public interface RatingRepository extends JpaRepository<Rating, Rating.Id> {

    @Query("select r from Rating r where r.id.movieId = :movieId order by r.updatedAt desc")
    Page<Rating> findByMovie(@Param("movieId") UUID movieId, Pageable pageable);

    @Query("select coalesce(avg(r.rating), 0) from Rating r where r.id.movieId = :movieId")
    double averageFor(@Param("movieId") UUID movieId);

    @Query("select r.rating, count(r) from Rating r where r.id.movieId = :movieId group by r.rating")
    List<Object[]> distributionFor(@Param("movieId") UUID movieId);

    @Query("select count(r) from Rating r where r.id.movieId = :movieId")
    long countFor(@Param("movieId") UUID movieId);
}
