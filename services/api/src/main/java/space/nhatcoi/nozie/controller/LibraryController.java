package space.nhatcoi.nozie.controller;

import java.util.UUID;

import jakarta.validation.Valid;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.constant.PaginationConstants;
import space.nhatcoi.nozie.dto.request.WatchProgressRequest;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.PurchaseResponse;
import space.nhatcoi.nozie.dto.response.TransactionResponse;
import space.nhatcoi.nozie.dto.response.WatchHistoryResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.PurchaseService;
import space.nhatcoi.nozie.service.WatchHistoryService;
import space.nhatcoi.nozie.util.PageUtils;

/** Read-only views of what the caller owns plus watch progress. Purchases are never writable from here. */
@RestController
@RequestMapping("/users/me")
@Tag(name = "Library")
public class LibraryController {

    private final PurchaseService purchaseService;
    private final WatchHistoryService watchHistoryService;

    public LibraryController(PurchaseService purchaseService, WatchHistoryService watchHistoryService) {
        this.purchaseService = purchaseService;
        this.watchHistoryService = watchHistoryService;
    }

    @GetMapping("/purchases")
    public ApiResponse<PageResponse<PurchaseResponse>> purchases(@AuthenticationPrincipal AuthenticatedUser user,
            @RequestParam(required = false) String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "" + PaginationConstants.DEFAULT_PAGE_SIZE) int size) {
        return ApiResponse.ok(purchaseService.listPurchases(user.id(), q, PageUtils.of(page, size)));
    }

    @GetMapping("/purchases/ids")
    public ApiResponse<java.util.List<UUID>> purchasedIds(@AuthenticationPrincipal AuthenticatedUser user) {
        return ApiResponse.ok(purchaseService.purchasedMovieIds(user.id()));
    }

    @GetMapping("/transactions")
    public ApiResponse<PageResponse<TransactionResponse>> transactions(@AuthenticationPrincipal AuthenticatedUser user,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "" + PaginationConstants.DEFAULT_PAGE_SIZE) int size) {
        return ApiResponse.ok(purchaseService.listTransactions(user.id(), PageUtils.of(page, size)));
    }

    @GetMapping("/watch-history")
    public ApiResponse<PageResponse<WatchHistoryResponse>> history(@AuthenticationPrincipal AuthenticatedUser user,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "" + PaginationConstants.DEFAULT_PAGE_SIZE) int size) {
        return ApiResponse.ok(watchHistoryService.list(user.id(), PageUtils.of(page, size)));
    }

    @PutMapping("/watch-history/{movieId}")
    public ApiResponse<Void> recordProgress(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId,
            @Valid @RequestBody WatchProgressRequest request) {
        watchHistoryService.record(user.id(), movieId, request);
        return ApiResponse.ok("Progress saved");
    }
}
