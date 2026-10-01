package space.nhatcoi.nozie.controller;

import java.util.UUID;

import jakarta.validation.Valid;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.constant.PaginationConstants;
import space.nhatcoi.nozie.dto.request.RatingRequest;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.RatingSummaryResponse;
import space.nhatcoi.nozie.dto.response.ReviewResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.ReviewService;
import space.nhatcoi.nozie.util.PageUtils;

/** Reading is public (GET /movies/**); writing needs a token and always acts on the caller's own review. */
@RestController
@RequestMapping("/movies/{movieId}/reviews")
@Tag(name = "Reviews")
public class ReviewController {

    private final ReviewService reviewService;

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @GetMapping
    public ApiResponse<PageResponse<ReviewResponse>> list(@AuthenticationPrincipal AuthenticatedUser viewer, @PathVariable UUID movieId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "" + PaginationConstants.DEFAULT_PAGE_SIZE) int size) {
        return ApiResponse.ok(reviewService.list(movieId, viewer == null ? null : viewer.id(), PageUtils.of(page, size)));
    }

    @GetMapping("/summary")
    public ApiResponse<RatingSummaryResponse> summary(@PathVariable UUID movieId) {
        return ApiResponse.ok(reviewService.summary(movieId));
    }

    @PutMapping("/me")
    public ApiResponse<ReviewResponse> upsert(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId,
            @Valid @RequestBody RatingRequest request) {
        return ApiResponse.ok(reviewService.upsert(user.id(), movieId, request));
    }

    @PutMapping("/{reviewUserId}/like")
    public ApiResponse<Void> like(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId,
            @PathVariable UUID reviewUserId) {
        reviewService.like(user.id(), movieId, reviewUserId);
        return ApiResponse.ok("Liked");
    }

    @DeleteMapping("/{reviewUserId}/like")
    public ApiResponse<Void> unlike(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId,
            @PathVariable UUID reviewUserId) {
        reviewService.unlike(user.id(), movieId, reviewUserId);
        return ApiResponse.ok("Unliked");
    }

    @DeleteMapping("/me")
    public ApiResponse<Void> delete(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId) {
        reviewService.delete(user.id(), movieId);
        return ApiResponse.ok("Review deleted");
    }
}
