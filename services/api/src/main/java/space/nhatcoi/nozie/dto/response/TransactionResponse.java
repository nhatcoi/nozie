package space.nhatcoi.nozie.dto.response;

import java.time.Instant;
import java.util.UUID;

public record TransactionResponse(UUID id, UUID movieId, long amountCents, String currency, String status,
        String errorMessage, Instant createdAt, Instant paidAt) {
}
