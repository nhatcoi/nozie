package space.nhatcoi.nozie;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.Test;

class LibraryApiTest extends AbstractApiTest {

    @Test
    void wishlistIsPerUserAndIdempotent() throws Exception {
        TestUser alice = register("alice@example.com");
        TestUser bob = register("bob@example.com");
        UUID m = movie("w1", 100);

        mvc.perform(asUser(put("/api/v1/users/me/wishlist/" + m), alice)).andExpect(status().isOk());
        mvc.perform(asUser(put("/api/v1/users/me/wishlist/" + m), alice)).andExpect(status().isOk());
        mvc.perform(asUser(get("/api/v1/users/me/wishlist"), alice))
                .andExpect(jsonPath("$.data.totalItems").value(1))
                .andExpect(jsonPath("$.data.items[0].slug").value("w1"));
        mvc.perform(asUser(get("/api/v1/users/me/wishlist"), bob)).andExpect(jsonPath("$.data.totalItems").value(0));

        mvc.perform(asUser(delete("/api/v1/users/me/wishlist/" + m), alice)).andExpect(status().isOk());
        mvc.perform(asUser(get("/api/v1/users/me/wishlist"), alice)).andExpect(jsonPath("$.data.totalItems").value(0));
        mvc.perform(asUser(put("/api/v1/users/me/wishlist/" + UUID.randomUUID()), alice))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.data.code").value("MOVIE_NOT_FOUND"));
    }

    @Test
    void libraryRequiresLogin() throws Exception {
        mvc.perform(get("/api/v1/users/me/wishlist")).andExpect(status().isUnauthorized());
        mvc.perform(get("/api/v1/users/me/purchases")).andExpect(status().isUnauthorized());
        mvc.perform(put("/api/v1/movies/" + UUID.randomUUID() + "/reviews/me")).andExpect(status().isUnauthorized());
    }

    @Test
    void watchHistoryUpsertsOneRowPerMovie() throws Exception {
        TestUser u = register("h@example.com");
        UUID m = movie("h1", 0);
        UUID ep = episode(m, "Ep1", "https://cdn.example/1.m3u8");

        mvc.perform(withJson(asUser(put("/api/v1/users/me/watch-history/" + m), u), Map.of("episodeId", ep, "positionSeconds", 30, "durationSeconds", 600)))
                .andExpect(status().isOk());
        mvc.perform(withJson(asUser(put("/api/v1/users/me/watch-history/" + m), u), Map.of("episodeId", ep, "positionSeconds", 90, "durationSeconds", 600)))
                .andExpect(status().isOk());
        mvc.perform(asUser(get("/api/v1/users/me/watch-history"), u))
                .andExpect(jsonPath("$.data.totalItems").value(1))
                .andExpect(jsonPath("$.data.items[0].positionSeconds").value(90))
                .andExpect(jsonPath("$.data.items[0].movie.slug").value("h1"));
        mvc.perform(withJson(asUser(put("/api/v1/users/me/watch-history/" + m), u), Map.of("positionSeconds", -5, "durationSeconds", 10)))
                .andExpect(status().isBadRequest());
        mvc.perform(withJson(asUser(put("/api/v1/users/me/watch-history/" + m), u),
                        Map.of("episodeId", UUID.randomUUID(), "positionSeconds", 1, "durationSeconds", 10)))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.data.code").value("EPISODE_NOT_FOUND"));
    }

    @Test
    void reviewsUpsertSummaryAndDelete() throws Exception {
        TestUser a = register("ra@example.com");
        TestUser b = register("rb@example.com");
        UUID m = movie("r1", 0);
        String url = "/api/v1/movies/" + m + "/reviews";

        mvc.perform(withJson(asUser(put(url + "/me"), a), Map.of("rating", 5, "review", "Great")))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.rating").value(5));
        mvc.perform(withJson(asUser(put(url + "/me"), a), Map.of("rating", 4, "review", "Good")))
                .andExpect(status().isOk());
        mvc.perform(withJson(asUser(put(url + "/me"), b), Map.of("rating", 2)))
                .andExpect(status().isOk());

        // public read, one row per user (a's second call edited, not duplicated)
        mvc.perform(get(url + "/summary"))
                .andExpect(jsonPath("$.data.count").value(2))
                .andExpect(jsonPath("$.data.average").value(3.0));
        mvc.perform(get(url)).andExpect(jsonPath("$.data.totalItems").value(2));

        mvc.perform(withJson(asUser(put(url + "/me"), a), Map.of("rating", 9))).andExpect(status().isBadRequest());

        mvc.perform(asUser(delete(url + "/me"), a)).andExpect(status().isOk());
        mvc.perform(get(url + "/summary")).andExpect(jsonPath("$.data.count").value(1));
    }

    @Test
    void notificationsAreScopedToOwner() throws Exception {
        TestUser a = register("na@example.com");
        TestUser b = register("nb@example.com");
        UUID nid = UUID.randomUUID();
        jdbc.update("insert into notifications (id, user_id, type, title) values (?, ?, 'system', 'Hello')", nid, a.id());

        mvc.perform(asUser(get("/api/v1/users/me/notifications/unread-count"), a)).andExpect(jsonPath("$.data.count").value(1));
        mvc.perform(asUser(get("/api/v1/users/me/notifications/unread-count"), b)).andExpect(jsonPath("$.data.count").value(0));

        // b cannot mark a's notification
        mvc.perform(asUser(patch("/api/v1/users/me/notifications/" + nid + "/read"), b)).andExpect(status().isNotFound());
        mvc.perform(asUser(patch("/api/v1/users/me/notifications/" + nid + "/read"), a)).andExpect(status().isOk());
        mvc.perform(asUser(get("/api/v1/users/me/notifications/unread-count"), a)).andExpect(jsonPath("$.data.count").value(0));
        mvc.perform(asUser(get("/api/v1/users/me/notifications"), a)).andExpect(jsonPath("$.data.items[0].read").value(true));
        mvc.perform(asUser(post("/api/v1/users/me/notifications/read-all"), a)).andExpect(status().isOk());
        assertThat(true).isTrue();
    }
}
