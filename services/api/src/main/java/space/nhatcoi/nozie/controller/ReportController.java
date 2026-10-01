package space.nhatcoi.nozie.controller;

import java.util.UUID;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.dto.request.ReportRequest;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.ReportService;

@RestController
@RequestMapping("/movies/{movieId}/reports")
@Tag(name = "Reports")
public class ReportController {

    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<Void> report(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId,
            @Valid @RequestBody ReportRequest request) {
        reportService.report(user.id(), movieId, request);
        return new ApiResponse<>(HttpStatus.CREATED.value(), "Report received", null);
    }
}
