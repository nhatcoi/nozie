package space.nhatcoi.nozie;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Map;
import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import space.nhatcoi.nozie.integration.PaymentGateway;
import space.nhatcoi.nozie.integration.PaymentGateway.EventType;
import space.nhatcoi.nozie.integration.PaymentGateway.PaymentEvent;
import space.nhatcoi.nozie.integration.PaymentGateway.PaymentIntentResult;

class PaymentApiTest extends AbstractApiTest {

    @MockitoBean PaymentGateway gateway;

    TestUser alice;
    UUID paid;

    @BeforeEach
    void setUp() throws Exception {
        alice = register("pay@example.com");
        paid = movie("paid", 499);
        when(gateway.createCustomer(any(), anyString())).thenReturn("cus_1");
        when(gateway.createEphemeralKey("cus_1")).thenReturn("ek_secret");
        when(gateway.createPaymentIntent(eq("cus_1"), anyLong(), anyString(), any()))
                .thenReturn(new PaymentIntentResult("pi_1", "pi_1_secret"));
    }

    JsonNode intent(TestUser u, UUID movieId) throws Exception {
        return data(mvc.perform(withJson(asUser(post("/api/v1/payments/intents"), u), Map.of("movieId", movieId)))
                .andExpect(status().isOk()));
    }

    void webhook(String eventId, EventType type, long amount, String currency) throws Exception {
        when(gateway.parseWebhook(anyString(), anyString()))
                .thenReturn(new PaymentEvent(eventId, type, "pi_1", "ch_1", amount, currency, "card declined"));
        mvc.perform(post("/api/v1/webhooks/stripe").header("Stripe-Signature", "sig").content("{}")
                .contentType("application/json")).andExpect(status().isOk());
    }

    @Test
    void priceComesFromServerNotClient() throws Exception {
        JsonNode r = intent(alice, paid);
        org.assertj.core.api.Assertions.assertThat(r.get("amountCents").asLong()).isEqualTo(499);
        verify(gateway).createPaymentIntent("cus_1", 499, "USD", UUID.fromString(r.get("transactionId").asText()));
        // a client-supplied amount is not even part of the contract (Stripe would return a fresh intent id)
        when(gateway.createPaymentIntent(eq("cus_1"), anyLong(), anyString(), any()))
                .thenReturn(new PaymentIntentResult("pi_2", "pi_2_secret"));
        mvc.perform(withJson(asUser(post("/api/v1/payments/intents"), alice), Map.of("movieId", paid, "amount", 1)))
                .andExpect(status().isOk());
    }

    @Test
    void freeMovieCannotBePurchased() throws Exception {
        UUID free = movie("free", 0);
        mvc.perform(withJson(asUser(post("/api/v1/payments/intents"), alice), Map.of("movieId", free)))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.data.code").value("FREE_MOVIE"));
    }

    @Test
    void streamLockedUntilWebhookGrantsAccess() throws Exception {
        UUID ep = episode(paid, "Full", "https://cdn.example/paid.m3u8");
        mvc.perform(asUser(get("/api/v1/playback/" + paid), alice))
                .andExpect(status().isForbidden()).andExpect(jsonPath("$.data.code").value("PURCHASE_REQUIRED"));
        // the public detail/episode listing never leaks the URL
        mvc.perform(get("/api/v1/movies/" + paid + "/episodes"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data[0].streamUrl").doesNotExist());

        JsonNode r = intent(alice, paid);
        // client claiming success changes nothing: still locked
        mvc.perform(asUser(get("/api/v1/payments/" + r.get("transactionId").asText()), alice))
                .andExpect(jsonPath("$.data.status").value("PENDING"));
        mvc.perform(asUser(get("/api/v1/playback/" + paid), alice)).andExpect(status().isForbidden());

        webhook("evt_1", EventType.SUCCEEDED, 499, "USD");

        mvc.perform(asUser(get("/api/v1/payments/" + r.get("transactionId").asText()), alice))
                .andExpect(jsonPath("$.data.status").value("SUCCEEDED"));
        mvc.perform(asUser(get("/api/v1/playback/" + paid + "?episodeId=" + ep), alice))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.streamUrl").value("https://cdn.example/paid.m3u8"));
        mvc.perform(asUser(get("/api/v1/users/me/purchases"), alice)).andExpect(jsonPath("$.data.totalItems").value(1));
        mvc.perform(asUser(get("/api/v1/users/me/notifications/unread-count"), alice)).andExpect(jsonPath("$.data.count").value(1));

        // owned movie can't be bought again
        mvc.perform(withJson(asUser(post("/api/v1/payments/intents"), alice), Map.of("movieId", paid)))
                .andExpect(status().isConflict()).andExpect(jsonPath("$.data.code").value("ALREADY_PURCHASED"));
    }

    @Test
    void redeliveredWebhookIsIdempotent() throws Exception {
        intent(alice, paid);
        webhook("evt_dup", EventType.SUCCEEDED, 499, "USD");
        webhook("evt_dup", EventType.SUCCEEDED, 499, "USD");
        mvc.perform(asUser(get("/api/v1/users/me/notifications/unread-count"), alice)).andExpect(jsonPath("$.data.count").value(1));
        mvc.perform(asUser(get("/api/v1/users/me/purchases"), alice)).andExpect(jsonPath("$.data.totalItems").value(1));
    }

    @Test
    void amountMismatchNeverGrantsAccess() throws Exception {
        episode(paid, "Full", "https://cdn.example/paid.m3u8");
        JsonNode r = intent(alice, paid);
        webhook("evt_cheap", EventType.SUCCEEDED, 1, "USD");
        mvc.perform(asUser(get("/api/v1/payments/" + r.get("transactionId").asText()), alice))
                .andExpect(jsonPath("$.data.status").value("FAILED"));
        mvc.perform(asUser(get("/api/v1/playback/" + paid), alice)).andExpect(status().isForbidden());
    }

    @Test
    void failedPaymentIsRecordedWithoutAccess() throws Exception {
        JsonNode r = intent(alice, paid);
        webhook("evt_fail", EventType.FAILED, 499, "USD");
        mvc.perform(asUser(get("/api/v1/payments/" + r.get("transactionId").asText()), alice))
                .andExpect(jsonPath("$.data.status").value("FAILED"))
                .andExpect(jsonPath("$.data.errorMessage").value("card declined"));
        mvc.perform(asUser(get("/api/v1/users/me/purchases"), alice)).andExpect(jsonPath("$.data.totalItems").value(0));
    }

    @Test
    void transactionsAreOwnerOnly() throws Exception {
        JsonNode r = intent(alice, paid);
        TestUser mallory = register("mallory@example.com");
        mvc.perform(asUser(get("/api/v1/payments/" + r.get("transactionId").asText()), mallory))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.data.code").value("TRANSACTION_NOT_FOUND"));
    }

    @Test
    void invalidSignatureIsRejected() throws Exception {
        when(gateway.parseWebhook(anyString(), anyString()))
                .thenThrow(new space.nhatcoi.nozie.exception.ApiException(space.nhatcoi.nozie.exception.ErrorCode.INVALID_WEBHOOK));
        mvc.perform(post("/api/v1/webhooks/stripe").header("Stripe-Signature", "forged").content("{}").contentType("application/json"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.data.code").value("INVALID_WEBHOOK"));
        verify(gateway, never()).createCustomer(any(), any());
    }

    @Test
    void freeMovieStreamsWithoutPurchase() throws Exception {
        UUID free = movie("freebie", 0);
        episode(free, "E1", "https://cdn.example/free.m3u8");
        mvc.perform(asUser(get("/api/v1/playback/" + free), alice))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.streamUrl").value("https://cdn.example/free.m3u8"));
        mvc.perform(get("/api/v1/playback/" + free)).andExpect(status().isUnauthorized());
    }
}
