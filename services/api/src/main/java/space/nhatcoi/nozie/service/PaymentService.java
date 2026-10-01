package space.nhatcoi.nozie.service;

import java.util.UUID;

import space.nhatcoi.nozie.dto.request.PaymentIntentRequest;
import space.nhatcoi.nozie.dto.response.PaymentIntentResponse;
import space.nhatcoi.nozie.dto.response.TransactionResponse;

public interface PaymentService {

    PaymentIntentResponse createIntent(UUID userId, PaymentIntentRequest request);

    TransactionResponse getTransaction(UUID userId, UUID transactionId);

    /** Verifies the Stripe signature, then applies the event exactly once. */
    void handleWebhook(String payload, String signatureHeader);
}
