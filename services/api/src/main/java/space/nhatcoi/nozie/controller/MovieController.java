package space.nhatcoi.nozie.controller;

import java.util.List;
import java.util.UUID;

import jakarta.validation.Valid;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.constant.PaginationConstants;
import space.nhatcoi.nozie.dto.request.MovieSearchCriteria;
import space.nhatcoi.nozie.dto.request.MovieSort;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.MovieDetailResponse;
import space.nhatcoi.nozie.dto.response.MovieSummaryResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.MovieService;

@RestController
@RequestMapping("/movies")
@Validated
@Tag(name = "Catalog")
public class MovieController {

    private final MovieService movieService;

    public MovieController(MovieService movieService) {
        this.movieService = movieService;
    }

    @GetMapping
    public ApiResponse<PageResponse<MovieSummaryResponse>> search(
            @Valid @ModelAttribute MovieSearchCriteria criteria,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "" + PaginationConstants.DEFAULT_PAGE_SIZE) int size,
            @RequestParam(defaultValue = "createdAt") String sort,
            @RequestParam(defaultValue = "desc") String direction) {
        MovieSort movieSort = MovieSort.parse(sort, direction);
        Pageable pageable = PageRequest.of(
                Math.max(page, 0),
                Math.min(Math.max(size, 1), PaginationConstants.MAX_PAGE_SIZE));
        return ApiResponse.ok(movieService.search(criteria, movieSort, pageable));
    }

    @GetMapping("/recommended")
    public ApiResponse<List<MovieSummaryResponse>> recommended(@AuthenticationPrincipal AuthenticatedUser user,
            @RequestParam(defaultValue = "20") int limit) {
        return ApiResponse.ok(movieService.recommended(user == null ? null : user.id(), limit));
    }

    @GetMapping("/suggest")
    public ApiResponse<List<String>> suggest(@RequestParam String q, @RequestParam(defaultValue = "5") int limit) {
        return ApiResponse.ok(movieService.suggest(q, limit));
    }

    @GetMapping("/{id}/similar")
    public ApiResponse<List<MovieSummaryResponse>> similar(@PathVariable UUID id, @RequestParam(defaultValue = "10") int limit) {
        return ApiResponse.ok(movieService.similar(id, limit));
    }

    @GetMapping("/{id}")
    public ApiResponse<MovieDetailResponse> getById(@PathVariable UUID id) {
        return ApiResponse.ok(movieService.getById(id));
    }

    @GetMapping("/by-slug/{slug}")
    public ApiResponse<MovieDetailResponse> getBySlug(@PathVariable String slug) {
        return ApiResponse.ok(movieService.getBySlug(slug));
    }
}
