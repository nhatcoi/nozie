package space.nhatcoi.nozie.service;

import java.util.UUID;

import space.nhatcoi.nozie.dto.request.ReportRequest;

public interface ReportService {

    /** Rate-limited per user so the endpoint cannot be used to flood moderators. */
    void report(UUID userId, UUID movieId, ReportRequest request);
}
