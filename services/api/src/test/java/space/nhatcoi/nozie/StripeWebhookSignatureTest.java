package space.nhatcoi.nozie;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.nio.charset.StandardCharsets;
import java.util.HexFormat;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.junit.jupiter.api.Test;

import space.nhatcoi.nozie.configuration.AppProperties;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.integration.PaymentGateway.EventType;
import space.nhatcoi.nozie.integration.PaymentGateway.PaymentEvent;
import space.nhatcoi.nozie.integration.StripePaymentGateway;

/** Exercises the real Stripe signature check without any network access. */
class StripeWebhookSignatureTest {

    static final String SECRET = "whsec_unit_test";

    final StripePaymentGateway gateway = new StripePaymentGateway(
            new AppProperties(null, new AppProperties.Jwt("0123456789abcdef0123456789abcdef", null, null),
                    null, null, null, new AppProperties.Stripe("sk_test_x", SECRET)));

    static final String PAYLOAD = "{\"id\":\"evt_123\",\"object\":\"event\",\"api_version\":\"2020-08-27\",\"type\":\"payment_intent.succeeded\","
            + "\"data\":{\"object\":{\"id\":\"pi_9\",\"object\":\"payment_intent\",\"amount\":499,\"amount_received\":499,"
            + "\"currency\":\"usd\",\"latest_charge\":\"ch_9\"}}}";

    static String sign(String payload, String secret, long ts) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        String sig = HexFormat.of().formatHex(mac.doFinal((ts + "." + payload).getBytes(StandardCharsets.UTF_8)));
        return "t=" + ts + ",v1=" + sig;
    }

    @Test
    void validSignatureParsesEvent() throws Exception {
        PaymentEvent e = gateway.parseWebhook(PAYLOAD, sign(PAYLOAD, SECRET, System.currentTimeMillis() / 1000));
        assertThat(e.type()).isEqualTo(EventType.SUCCEEDED);
        assertThat(e.paymentIntentId()).isEqualTo("pi_9");
        assertThat(e.amountCents()).isEqualTo(499);
        assertThat(e.currency()).isEqualTo("USD");
        assertThat(e.chargeId()).isEqualTo("ch_9");
    }

    @Test
    void wrongSecretTamperedBodyAndMissingHeaderAreRejected() throws Exception {
        long now = System.currentTimeMillis() / 1000;
        assertThatThrownBy(() -> gateway.parseWebhook(PAYLOAD, sign(PAYLOAD, "whsec_other", now))).isInstanceOf(ApiException.class);
        assertThatThrownBy(() -> gateway.parseWebhook(PAYLOAD.replace("499", "1"), sign(PAYLOAD, SECRET, now))).isInstanceOf(ApiException.class);
        assertThatThrownBy(() -> gateway.parseWebhook(PAYLOAD, null)).isInstanceOf(ApiException.class);
    }

    @Test
    void staleTimestampIsRejectedAsReplay() throws Exception {
        long old = System.currentTimeMillis() / 1000 - 3600;
        assertThatThrownBy(() -> gateway.parseWebhook(PAYLOAD, sign(PAYLOAD, SECRET, old))).isInstanceOf(ApiException.class);
    }
}
