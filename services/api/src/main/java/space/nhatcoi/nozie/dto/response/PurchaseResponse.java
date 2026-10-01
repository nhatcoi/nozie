package space.nhatcoi.nozie.dto.response;

import java.time.Instant;

public record PurchaseResponse(MovieSummaryResponse movie, Instant purchasedAt) {
}
