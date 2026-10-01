package space.nhatcoi.nozie.integration;

import java.util.UUID;

/** Port to the payment provider so services and tests never depend on Stripe types. */
public interface PaymentGateway {

    String createCustomer(UUID userId, String email);

    String createEphemeralKey(String customerId);

    PaymentIntentResult createPaymentIntent(String customerId, long amountCents, String currency, UUID transactionId);

    /** @throws space.nhatcoi.nozie.exception.ApiException INVALID_WEBHOOK when the signature does not match */
    PaymentEvent parseWebhook(String payload, String signatureHeader);

    record PaymentIntentResult(String id, String clientSecret) {
    }

    enum EventType { SUCCEEDED, FAILED, CANCELED, IGNORED }

    record PaymentEvent(String eventId, EventType type, String paymentIntentId, String chargeId, Long amountCents,
            String currency, String errorMessage) {
    }
}
