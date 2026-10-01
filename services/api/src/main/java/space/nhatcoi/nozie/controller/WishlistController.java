package space.nhatcoi.nozie.controller;

import java.util.UUID;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.constant.PaginationConstants;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.MovieSummaryResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.WishlistService;
import space.nhatcoi.nozie.util.PageUtils;

@RestController
@RequestMapping("/users/me/wishlist")
@Tag(name = "Library")
public class WishlistController {

    private final WishlistService wishlistService;

    public WishlistController(WishlistService wishlistService) {
        this.wishlistService = wishlistService;
    }

    @GetMapping
    public ApiResponse<PageResponse<MovieSummaryResponse>> list(@AuthenticationPrincipal AuthenticatedUser user,
            @RequestParam(required = false) String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "" + PaginationConstants.DEFAULT_PAGE_SIZE) int size) {
        return ApiResponse.ok(wishlistService.list(user.id(), q, PageUtils.of(page, size)));
    }

    @GetMapping("/ids")
    public ApiResponse<java.util.List<UUID>> ids(@AuthenticationPrincipal AuthenticatedUser user) {
        return ApiResponse.ok(wishlistService.ids(user.id()));
    }

    @PutMapping("/{movieId}")
    public ApiResponse<Void> add(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId) {
        wishlistService.add(user.id(), movieId);
        return ApiResponse.ok("Added to wishlist");
    }

    @DeleteMapping("/{movieId}")
    public ApiResponse<Void> remove(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId) {
        wishlistService.remove(user.id(), movieId);
        return ApiResponse.ok("Removed from wishlist");
    }
}
