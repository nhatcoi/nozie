package space.nhatcoi.nozie.integration;

import java.util.Map;
import java.util.UUID;

import com.stripe.exception.SignatureVerificationException;
import com.stripe.exception.StripeException;
import com.stripe.model.Customer;
import com.stripe.model.EphemeralKey;
import com.stripe.model.Event;
import com.stripe.model.PaymentIntent;
import com.stripe.model.StripeObject;
import com.stripe.net.RequestOptions;
import com.stripe.net.Webhook;
import com.stripe.param.CustomerCreateParams;
import com.stripe.param.EphemeralKeyCreateParams;
import com.stripe.param.PaymentIntentCreateParams;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.configuration.AppProperties;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;

@Component
public class StripePaymentGateway implements PaymentGateway {

    /** Must match the Stripe SDK version bundled in the Flutter client (flutter_stripe). */
    private static final String MOBILE_API_VERSION = "2024-11-20.acacia";

    private static final Logger log = LoggerFactory.getLogger(StripePaymentGateway.class);

    private final String secretKey;
    private final String webhookSecret;

    public StripePaymentGateway(AppProperties properties) {
        this.secretKey = properties.stripe().secretKey();
        this.webhookSecret = properties.stripe().webhookSecret();
    }

    private RequestOptions.RequestOptionsBuilder options() {
        if (secretKey == null || secretKey.isBlank()) {
            throw new ApiException(ErrorCode.PAYMENT_PROVIDER_ERROR);
        }
        return RequestOptions.builder().setApiKey(secretKey);
    }

    @Override
    public String createCustomer(UUID userId, String email) {
        try {
            return Customer.create(CustomerCreateParams.builder().setEmail(email)
                    .putMetadata("userId", userId.toString()).build(), options().build()).getId();
        } catch (StripeException e) {
            throw providerError(e);
        }
    }

    @Override
    public String createEphemeralKey(String customerId) {
        try {
            return EphemeralKey.create(EphemeralKeyCreateParams.builder().setCustomer(customerId).build(),
                    RequestOptions.RequestOptionsBuilder.unsafeSetStripeVersionOverride(options(), MOBILE_API_VERSION).build()).getSecret();
        } catch (StripeException e) {
            throw providerError(e);
        }
    }

    @Override
    public PaymentIntentResult createPaymentIntent(String customerId, long amountCents, String currency, UUID transactionId) {
        try {
            PaymentIntent pi = PaymentIntent.create(PaymentIntentCreateParams.builder()
                    .setAmount(amountCents)
                    .setCurrency(currency.toLowerCase())
                    .setCustomer(customerId)
                    .setAutomaticPaymentMethods(PaymentIntentCreateParams.AutomaticPaymentMethods.builder().setEnabled(true).build())
                    .putMetadata("transactionId", transactionId.toString())
                    .build(), options().setIdempotencyKey("pi-" + transactionId).build());
            return new PaymentIntentResult(pi.getId(), pi.getClientSecret());
        } catch (StripeException e) {
            throw providerError(e);
        }
    }

    @Override
    public PaymentEvent parseWebhook(String payload, String signatureHeader) {
        Event event;
        try {
            if (webhookSecret == null || webhookSecret.isBlank() || signatureHeader == null) {
                throw new ApiException(ErrorCode.INVALID_WEBHOOK);
            }
            event = Webhook.constructEvent(payload, signatureHeader, webhookSecret);
        } catch (SignatureVerificationException | com.google.gson.JsonSyntaxException e) {
            throw new ApiException(ErrorCode.INVALID_WEBHOOK);
        }
        EventType type = switch (event.getType()) {
            case "payment_intent.succeeded" -> EventType.SUCCEEDED;
            case "payment_intent.payment_failed" -> EventType.FAILED;
            case "payment_intent.canceled" -> EventType.CANCELED;
            default -> EventType.IGNORED;
        };
        if (type == EventType.IGNORED) {
            return new PaymentEvent(event.getId(), type, null, null, null, null, null);
        }
        StripeObject object;
        try {
            object = event.getDataObjectDeserializer().deserializeUnsafe();
        } catch (com.stripe.exception.EventDataObjectDeserializationException e) {
            log.error("Cannot deserialize Stripe event {}", event.getId());
            throw new ApiException(ErrorCode.INVALID_WEBHOOK);
        }
        if (!(object instanceof PaymentIntent pi)) {
            return new PaymentEvent(event.getId(), EventType.IGNORED, null, null, null, null, null);
        }
        String error = pi.getLastPaymentError() == null ? null : pi.getLastPaymentError().getMessage();
        return new PaymentEvent(event.getId(), type, pi.getId(), pi.getLatestCharge(), pi.getAmountReceived() != null && pi.getAmountReceived() > 0 ? pi.getAmountReceived() : pi.getAmount(),
                pi.getCurrency() == null ? null : pi.getCurrency().toUpperCase(), error);
    }

    private static ApiException providerError(StripeException e) {
        log.error("Stripe call failed: {}", e.getMessage());
        return new ApiException(ErrorCode.PAYMENT_PROVIDER_ERROR);
    }
}
