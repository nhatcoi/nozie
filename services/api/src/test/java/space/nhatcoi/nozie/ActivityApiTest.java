package space.nhatcoi.nozie;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;

class ActivityApiTest extends AbstractApiTest {

    static final byte[] PNG = {(byte) 0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 0};

    UUID movieWithName(String slug, String name, int price) {
        UUID id = UUID.randomUUID();
        jdbc.update("insert into movies (id, slug, name, type, year, price_cents, tmdb) values (?,?,?,'single',2020,?, '{\"vote_average\": 8, \"vote_count\": 50}'::jsonb)",
                id, slug, name, price);
        jdbc.update("update movies set rating = 4.0, rating_count = 50 where id = ?", id);
        return id;
    }

    // ---------- wishlist / purchases ----------

    @Test
    void wishlistSearchAndIds() throws Exception {
        TestUser u = register("w@example.com");
        UUID a = movieWithName("a", "Alpha Quest", 0);
        UUID b = movieWithName("b", "Beta Run", 0);
        mvc.perform(asUser(put("/api/v1/users/me/wishlist/" + a), u)).andExpect(status().isOk());
        mvc.perform(asUser(put("/api/v1/users/me/wishlist/" + b), u)).andExpect(status().isOk());

        mvc.perform(asUser(get("/api/v1/users/me/wishlist?q=alp"), u))
                .andExpect(jsonPath("$.data.totalItems").value(1)).andExpect(jsonPath("$.data.items[0].slug").value("a"));
        mvc.perform(asUser(get("/api/v1/users/me/wishlist?q=%25"), u)).andExpect(jsonPath("$.data.totalItems").value(0));
        mvc.perform(asUser(get("/api/v1/users/me/wishlist"), u)).andExpect(jsonPath("$.data.totalItems").value(2));
        mvc.perform(asUser(get("/api/v1/users/me/wishlist/ids"), u)).andExpect(jsonPath("$.data.length()").value(2));
    }

    @Test
    void purchasesIdsAndSearch() throws Exception {
        TestUser u = register("p@example.com");
        UUID a = movieWithName("pa", "Paid Alpha", 300);
        UUID b = movieWithName("pb", "Paid Beta", 300);
        jdbc.update("insert into purchases (user_id, movie_id) values (?, ?), (?, ?)", u.id(), a, u.id(), b);
        mvc.perform(asUser(get("/api/v1/users/me/purchases/ids"), u)).andExpect(jsonPath("$.data.length()").value(2));
        mvc.perform(asUser(get("/api/v1/users/me/purchases?q=beta"), u))
                .andExpect(jsonPath("$.data.totalItems").value(1)).andExpect(jsonPath("$.data.items[0].movie.slug").value("pb"));
    }

    // ---------- reviews ----------

    @Test
    void reviewsLikesDistributionAndMovieRatingSync() throws Exception {
        TestUser a = register("ra@example.com");
        TestUser b = register("rb@example.com");
        UUID m = movieWithName("rev", "Reviewed", 0);
        String url = "/api/v1/movies/" + m + "/reviews";

        mvc.perform(withJson(asUser(put(url + "/me"), a), Map.of("rating", 5, "review", "Great"))).andExpect(status().isOk());
        mvc.perform(withJson(asUser(put(url + "/me"), b), Map.of("rating", 3))).andExpect(status().isOk());

        // viewer reviews replace the imported TMDB rating (4.0 / 50 votes)
        mvc.perform(get("/api/v1/movies/" + m)).andExpect(jsonPath("$.data.rating").value(4.0)).andExpect(jsonPath("$.data.ratingCount").value(2));
        mvc.perform(get(url + "/summary"))
                .andExpect(jsonPath("$.data.distribution.5").value(1))
                .andExpect(jsonPath("$.data.distribution.3").value(1))
                .andExpect(jsonPath("$.data.distribution.1").value(0));

        // b likes a's review; likes are idempotent and personal
        mvc.perform(asUser(put(url + "/" + a.id() + "/like"), b)).andExpect(status().isOk());
        mvc.perform(asUser(put(url + "/" + a.id() + "/like"), b)).andExpect(status().isOk());
        mvc.perform(asUser(get(url), b)).andExpect(jsonPath("$.data.items[?(@.userId=='" + a.id() + "')].likes").value(1))
                .andExpect(jsonPath("$.data.items[?(@.userId=='" + a.id() + "')].likedByMe").value(true));
        mvc.perform(get(url)).andExpect(jsonPath("$.data.items[?(@.userId=='" + a.id() + "')].likedByMe").value(false));
        mvc.perform(asUser(delete(url + "/" + a.id() + "/like"), b)).andExpect(status().isOk());
        mvc.perform(asUser(get(url), b)).andExpect(jsonPath("$.data.items[?(@.userId=='" + a.id() + "')].likes").value(0));
        mvc.perform(asUser(put(url + "/" + UUID.randomUUID() + "/like"), b))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.data.code").value("REVIEW_NOT_FOUND"));

        // deleting every review restores the imported rating
        mvc.perform(asUser(delete(url + "/me"), a)).andExpect(status().isOk());
        mvc.perform(asUser(delete(url + "/me"), b)).andExpect(status().isOk());
        mvc.perform(get("/api/v1/movies/" + m)).andExpect(jsonPath("$.data.rating").value(4.0)).andExpect(jsonPath("$.data.ratingCount").value(50));
    }

    // ---------- reports ----------

    @Test
    void reportsRequireLoginAndAreThrottled() throws Exception {
        UUID m = movieWithName("rep", "Reported", 0);
        mvc.perform(post("/api/v1/movies/" + m + "/reports").contentType("application/json").content("{}")).andExpect(status().isUnauthorized());
        TestUser u = register("rep@example.com");
        for (int i = 0; i < 10; i++) {
            mvc.perform(withJson(asUser(post("/api/v1/movies/" + m + "/reports"), u), Map.of("issueType", "Cannot play", "description", "x", "errorMessage", "boom")))
                    .andExpect(status().isCreated());
        }
        mvc.perform(withJson(asUser(post("/api/v1/movies/" + m + "/reports"), u), Map.of("issueType", "Cannot play")))
                .andExpect(status().isTooManyRequests()).andExpect(jsonPath("$.data.code").value("TOO_MANY_REQUESTS"));
        mvc.perform(withJson(asUser(post("/api/v1/movies/" + UUID.randomUUID() + "/reports"), register("rep2@example.com")), Map.of("issueType", "x")))
                .andExpect(status().isNotFound());
        mvc.perform(withJson(asUser(post("/api/v1/movies/" + m + "/reports"), register("rep3@example.com")), Map.of("description", "no type")))
                .andExpect(status().isBadRequest());
        assertThat(jdbc.queryForObject("select count(*) from reports", Integer.class)).isEqualTo(10);
    }

    // ---------- avatar ----------

    @Test
    void avatarUploadServeAndRemove() throws Exception {
        TestUser u = register("av@example.com");
        mvc.perform(multipart("/api/v1/users/me/avatar").file(new MockMultipartFile("file", "a.png", "image/png", PNG))
                        .with(r -> { r.setMethod("PUT"); return r; }).header("Authorization", u.bearer()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.avatarUrl").value(org.hamcrest.Matchers.startsWith("/api/v1/users/" + u.id() + "/avatar?v=")));

        // public, served with the sniffed type and long cache
        mvc.perform(get("/api/v1/users/" + u.id() + "/avatar"))
                .andExpect(status().isOk()).andExpect(header().string("Content-Type", "image/png"))
                .andExpect(header().string("Cache-Control", org.hamcrest.Matchers.containsString("max-age")))
                .andExpect(content().bytes(PNG));
        mvc.perform(asUser(get("/api/v1/users/me"), u)).andExpect(jsonPath("$.data.avatarUrl").isNotEmpty());

        mvc.perform(asUser(delete("/api/v1/users/me/avatar"), u)).andExpect(status().isOk()).andExpect(jsonPath("$.data.avatarUrl").doesNotExist());
        mvc.perform(get("/api/v1/users/" + u.id() + "/avatar")).andExpect(status().isNotFound());
    }

    @Test
    void avatarRejectsNonImagesAndOversizeFiles() throws Exception {
        TestUser u = register("av2@example.com");
        byte[] html = "<html><script>alert(1)</script></html>".getBytes();
        mvc.perform(multipart("/api/v1/users/me/avatar").file(new MockMultipartFile("file", "a.png", "image/png", html))
                        .with(r -> { r.setMethod("PUT"); return r; }).header("Authorization", u.bearer()))
                .andExpect(status().isUnsupportedMediaType()).andExpect(jsonPath("$.data.code").value("UNSUPPORTED_FILE_TYPE"));
        byte[] svg = "<svg xmlns='http://www.w3.org/2000/svg'/>".getBytes();
        mvc.perform(multipart("/api/v1/users/me/avatar").file(new MockMultipartFile("file", "a.svg", "image/svg+xml", svg))
                        .with(r -> { r.setMethod("PUT"); return r; }).header("Authorization", u.bearer()))
                .andExpect(status().isUnsupportedMediaType());
        byte[] big = new byte[2 * 1024 * 1024 + 1];
        System.arraycopy(PNG, 0, big, 0, PNG.length);
        mvc.perform(multipart("/api/v1/users/me/avatar").file(new MockMultipartFile("file", "a.png", "image/png", big))
                        .with(r -> { r.setMethod("PUT"); return r; }).header("Authorization", u.bearer()))
                .andExpect(status().isPayloadTooLarge()).andExpect(jsonPath("$.data.code").value("FILE_TOO_LARGE"));
        mvc.perform(multipart("/api/v1/users/me/avatar").file(new MockMultipartFile("file", "a.png", "image/png", PNG))
                        .with(r -> { r.setMethod("PUT"); return r; }))
                .andExpect(status().isUnauthorized());
    }

    // ---------- playback ----------

    @Test
    void accessEndpointAndViewCounter() throws Exception {
        TestUser u = register("pl@example.com");
        UUID free = movieWithName("pf", "Free", 0);
        UUID paid = movieWithName("pp", "Paid", 500);
        episode(free, "E1", "https://cdn/f.m3u8");
        episode(paid, "E1", "https://cdn/p.m3u8");

        mvc.perform(asUser(get("/api/v1/playback/" + free + "/access"), u))
                .andExpect(jsonPath("$.data.canWatch").value(true)).andExpect(jsonPath("$.data.free").value(true));
        mvc.perform(asUser(get("/api/v1/playback/" + paid + "/access"), u))
                .andExpect(jsonPath("$.data.canWatch").value(false)).andExpect(jsonPath("$.data.owned").value(false));
        jdbc.update("insert into purchases (user_id, movie_id) values (?, ?)", u.id(), paid);
        mvc.perform(asUser(get("/api/v1/playback/" + paid + "/access"), u))
                .andExpect(jsonPath("$.data.canWatch").value(true)).andExpect(jsonPath("$.data.owned").value(true));

        mvc.perform(asUser(get("/api/v1/playback/" + free), u)).andExpect(status().isOk());
        mvc.perform(asUser(get("/api/v1/playback/" + free), u)).andExpect(status().isOk());
        assertThat(jdbc.queryForObject("select view_count from movies where id = ?", Long.class, free)).isEqualTo(2L);
        assertThat(jdbc.queryForObject("select view_count from movies where id = ?", Long.class, paid)).isEqualTo(0L);
    }
}
