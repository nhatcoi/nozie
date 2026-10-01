package space.nhatcoi.nozie;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class CatalogFiltersApiTest extends AbstractApiTest {

    UUID a, b, c, d;

    UUID insert(String slug, String name, int year, int views, int priceCents, Double rating, boolean cinema, String status, String... genres) {
        UUID id = UUID.randomUUID();
        jdbc.update("insert into movies (id, slug, name, type, year, view_count, price_cents, rating, is_cinema, status) values (?,?,?,'single',?,?,?,?,?,?)",
                id, slug, name, year, views, priceCents, rating, cinema, status);
        for (String g : genres) {
            jdbc.update("insert into genres (slug, name) values (?, ?) on conflict (slug) do nothing", g, g.toUpperCase());
            jdbc.update("insert into movie_genres select ?, id from genres where slug = ?", id, g);
        }
        return id;
    }

    @BeforeEach
    void seed() {
        a = insert("alpha-one", "Alpha One", 2024, 500, 0, 4.5, true, "completed", "action");
        b = insert("alpha-two", "Alpha Two", 2023, 300, 499, 3.0, false, "completed", "action", "drama");
        c = insert("beta", "Beta", 2020, 900, 999, 4.0, false, "upcoming", "drama");
        d = insert("gamma", "Gamma", 2024, 100, 0, null, false, null, "comedy");
    }

    List<String> slugs(String query) throws Exception {
        String res = mvc.perform(get("/api/v1/movies?" + query)).andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        List<String> out = new java.util.ArrayList<>();
        json.readTree(res).get("data").get("items").forEach(n -> out.add(n.get("slug").asText()));
        return out;
    }

    @org.junit.jupiter.api.Test
    void filtersCombine() throws Exception {
        org.assertj.core.api.Assertions.assertThat(slugs("ratingMin=4&sort=rating")).containsExactly("alpha-one", "beta");
        org.assertj.core.api.Assertions.assertThat(slugs("priceMinCents=400&priceMaxCents=600")).containsExactly("alpha-two");
        org.assertj.core.api.Assertions.assertThat(slugs("free=true&sort=viewCount")).containsExactly("alpha-one", "gamma");
        org.assertj.core.api.Assertions.assertThat(slugs("cinema=true")).containsExactly("alpha-one");
        org.assertj.core.api.Assertions.assertThat(slugs("minYear=2023&excludeStatus=upcoming&sort=year")).containsExactly("alpha-one", "gamma", "alpha-two");
        org.assertj.core.api.Assertions.assertThat(slugs("slugPrefix=alpha&sort=viewCount")).containsExactly("alpha-one", "alpha-two");
    }

    @org.junit.jupiter.api.Test
    void genreMatchesSlugOrNameAndSupportsLists() throws Exception {
        org.assertj.core.api.Assertions.assertThat(slugs("genre=drama&sort=viewCount")).containsExactly("beta", "alpha-two");
        org.assertj.core.api.Assertions.assertThat(slugs("genre=DRAMA&sort=viewCount")).containsExactly("beta", "alpha-two");
        org.assertj.core.api.Assertions.assertThat(slugs("genres=comedy&genres=action&sort=viewCount")).containsExactly("alpha-one", "alpha-two", "gamma");
        // a movie in two matching genres must not be listed twice
        org.assertj.core.api.Assertions.assertThat(slugs("genres=action&genres=drama")).hasSize(3).doesNotHaveDuplicates();
    }

    @org.junit.jupiter.api.Test
    void ratingIsExposedAndNullSortsLast() throws Exception {
        mvc.perform(get("/api/v1/movies/" + a)).andExpect(jsonPath("$.data.rating").value(4.5));
        org.assertj.core.api.Assertions.assertThat(slugs("sort=rating&direction=desc").get(3)).isEqualTo("gamma");
    }

    @Test
    void similarSharesGenreAndExcludesSelf() throws Exception {
        mvc.perform(get("/api/v1/movies/" + b + "/similar"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0].slug").value("beta"))     // most viewed first
                .andExpect(jsonPath("$.data[1].slug").value("alpha-one"));
    }

    @Test
    void suggestMatchesTitles() throws Exception {
        mvc.perform(get("/api/v1/movies/suggest?q=alp"))
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0]").value("Alpha One"));
        mvc.perform(get("/api/v1/movies/suggest?q=%25")).andExpect(jsonPath("$.data.length()").value(0));
    }

    @Test
    void recommendedUsesFavouriteGenresAndFallsBackToMostViewed() throws Exception {
        // anonymous and favourite-less users get the most viewed overall
        mvc.perform(get("/api/v1/movies/recommended")).andExpect(status().isOk()).andExpect(jsonPath("$.data[0].slug").value("beta"));

        TestUser u = register("fav@example.com");
        mvc.perform(withJson(asUser(put("/api/v1/users/me/favorite-genres"), u), Map.of("genres", List.of("comedy", "Unknown"))))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.length()").value(1)).andExpect(jsonPath("$.data[0].slug").value("comedy"));
        mvc.perform(asUser(get("/api/v1/movies/recommended"), u))
                .andExpect(jsonPath("$.data.length()").value(1)).andExpect(jsonPath("$.data[0].slug").value("gamma"));
        mvc.perform(asUser(get("/api/v1/users/me/favorite-genres"), u)).andExpect(jsonPath("$.data[0].name").value("COMEDY"));

        // replacing the set drops the old one
        mvc.perform(withJson(asUser(put("/api/v1/users/me/favorite-genres"), u), Map.of("genres", List.of("drama"))))
                .andExpect(jsonPath("$.data.length()").value(1));
        mvc.perform(asUser(get("/api/v1/movies/recommended"), u)).andExpect(jsonPath("$.data.length()").value(2));
    }

    @Test
    void invalidFilterValuesAreRejected() throws Exception {
        mvc.perform(get("/api/v1/movies?ratingMin=9")).andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/movies?priceMinCents=-1")).andExpect(status().isBadRequest());
    }
}
