package space.nhatcoi.nozie.service;

import java.util.UUID;

import org.springframework.data.domain.Pageable;

import space.nhatcoi.nozie.dto.request.WatchProgressRequest;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.WatchHistoryResponse;

public interface WatchHistoryService {

    PageResponse<WatchHistoryResponse> list(UUID userId, Pageable pageable);

    /** Upsert: one row per (user, movie). */
    void record(UUID userId, UUID movieId, WatchProgressRequest request);
}
