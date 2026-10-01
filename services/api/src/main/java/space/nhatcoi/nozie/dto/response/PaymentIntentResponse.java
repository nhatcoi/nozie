package space.nhatcoi.nozie.dto.response;

import java.util.UUID;

public record PaymentIntentResponse(String clientSecret, String ephemeralKey, String customerId, UUID transactionId,
        long amountCents, String currency) {
}
