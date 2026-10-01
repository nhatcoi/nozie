package space.nhatcoi.nozie.service;

import java.util.UUID;

import org.springframework.data.domain.Pageable;

import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.PurchaseResponse;
import space.nhatcoi.nozie.dto.response.TransactionResponse;
import space.nhatcoi.nozie.entity.Movie;

public interface PurchaseService {

    PageResponse<PurchaseResponse> listPurchases(UUID userId, String query, Pageable pageable);

    java.util.List<UUID> purchasedMovieIds(UUID userId);

    PageResponse<TransactionResponse> listTransactions(UUID userId, Pageable pageable);

    boolean owns(UUID userId, UUID movieId);

    /** Free movies are open to everyone; paid ones need a purchase. */
    boolean canWatch(UUID userId, Movie movie);

    /** Idempotent entitlement grant. Called only by the payment webhook. */
    void grant(UUID userId, UUID movieId, UUID transactionId);
}
