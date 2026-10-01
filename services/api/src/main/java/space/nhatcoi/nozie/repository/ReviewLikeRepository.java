package space.nhatcoi.nozie.repository;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.ReviewLike;

public interface ReviewLikeRepository extends JpaRepository<ReviewLike, ReviewLike.Id> {

    /** Rows of (reviewUserId, likeCount) for the given reviews of one movie. */
    @Query("select l.id.reviewUserId, count(l) from ReviewLike l where l.id.movieId = :movieId and l.id.reviewUserId in :reviewUserIds group by l.id.reviewUserId")
    List<Object[]> countByReviews(@Param("movieId") UUID movieId, @Param("reviewUserIds") Collection<UUID> reviewUserIds);

    @Query("select l.id.reviewUserId from ReviewLike l where l.id.movieId = :movieId and l.id.userId = :userId and l.id.reviewUserId in :reviewUserIds")
    List<UUID> likedBy(@Param("movieId") UUID movieId, @Param("userId") UUID userId, @Param("reviewUserIds") Collection<UUID> reviewUserIds);

    @Query("select count(l) from ReviewLike l where l.id.movieId = :movieId and l.id.reviewUserId = :reviewUserId")
    long countFor(@Param("movieId") UUID movieId, @Param("reviewUserId") UUID reviewUserId);
}
