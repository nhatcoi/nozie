package space.nhatcoi.nozie.service;

import java.util.UUID;

import org.springframework.data.domain.Pageable;

import space.nhatcoi.nozie.dto.request.RatingRequest;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.RatingSummaryResponse;
import space.nhatcoi.nozie.dto.response.ReviewResponse;

public interface ReviewService {

    /** @param viewerIdOrNull when present, each review reports whether this viewer liked it */
    PageResponse<ReviewResponse> list(UUID movieId, UUID viewerIdOrNull, Pageable pageable);

    RatingSummaryResponse summary(UUID movieId);

    /** One review per user per movie; calling again edits it. Keeps the movie's displayed rating in sync. */
    ReviewResponse upsert(UUID userId, UUID movieId, RatingRequest request);

    void delete(UUID userId, UUID movieId);

    /** Idempotent. */
    void like(UUID userId, UUID movieId, UUID reviewUserId);

    /** Idempotent. */
    void unlike(UUID userId, UUID movieId, UUID reviewUserId);
}
