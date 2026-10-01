package space.nhatcoi.nozie.service;

import java.util.UUID;

import org.springframework.data.domain.Pageable;

import space.nhatcoi.nozie.dto.response.MovieSummaryResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;

public interface WishlistService {

    PageResponse<MovieSummaryResponse> list(UUID userId, String query, Pageable pageable);

    /** Just the movie ids, for cheap "is this in my wishlist" checks on the client. */
    java.util.List<UUID> ids(UUID userId);

    /** Idempotent. */
    void add(UUID userId, UUID movieId);

    /** Idempotent. */
    void remove(UUID userId, UUID movieId);
}
