package space.nhatcoi.nozie.service.impl;

import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.request.ReportRequest;
import space.nhatcoi.nozie.entity.Report;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.repository.ReportRepository;
import space.nhatcoi.nozie.service.ReportService;

@Service
@Transactional
public class ReportServiceImpl implements ReportService {

    private static final int MAX_PER_HOUR = 10;

    private final ReportRepository reportRepository;
    private final MovieRepository movieRepository;

    public ReportServiceImpl(ReportRepository reportRepository, MovieRepository movieRepository) {
        this.reportRepository = reportRepository;
        this.movieRepository = movieRepository;
    }

    @Override
    public void report(UUID userId, UUID movieId, ReportRequest request) {
        if (!movieRepository.existsById(movieId)) {
            throw new ApiException(ErrorCode.MOVIE_NOT_FOUND);
        }
        if (reportRepository.countRecent(userId, Instant.now().minus(Duration.ofHours(1))) >= MAX_PER_HOUR) {
            throw new ApiException(ErrorCode.TOO_MANY_REQUESTS);
        }
        StringBuilder detail = new StringBuilder();
        if (request.description() != null && !request.description().isBlank()) {
            detail.append(request.description().trim());
        }
        if (request.errorMessage() != null && !request.errorMessage().isBlank()) {
            if (detail.length() > 0) {
                detail.append("\n");
            }
            detail.append("[player] ").append(request.errorMessage().trim());
        }
        String text = detail.length() == 0 ? null : detail.substring(0, Math.min(detail.length(), 1000));
        reportRepository.save(new Report(userId, movieId, request.issueType().trim(), text));
    }
}
