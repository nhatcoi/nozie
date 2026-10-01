package space.nhatcoi.nozie;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;

@AutoConfigureMockMvc
class CatalogApiTest extends AbstractIntegrationTest {

    @Autowired
    MockMvc mvc;

    @Autowired
    JdbcTemplate jdbc;

    UUID paidId = UUID.randomUUID();

    @BeforeEach
    void seed() {
        jdbc.update("delete from movie_genres");
        jdbc.update("delete from movies");
        jdbc.update("delete from genres");
        jdbc.update("insert into genres (slug, name) values ('action','Action'), ('drama','Drama')");
        jdbc.update("insert into movies (id, slug, name, type, year, price_cents) values (?, 'big-fight', 'Big Fight 100%', 'single', 2020, 499)", paidId);
        jdbc.update("insert into movies (slug, name, type, year, price_cents) values ('quiet-day', 'Quiet Day', 'series', 2021, 0)");
        jdbc.update("insert into movie_genres select ?, id from genres where slug = 'action'", paidId);
    }

    @Test
    void listsAllMoviesPublicly() throws Exception {
        mvc.perform(get("/api/v1/movies"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.totalItems").value(2))
                .andExpect(jsonPath("$.data.items.length()").value(2));
    }

    @Test
    void filtersByGenreAndFreeFlag() throws Exception {
        mvc.perform(get("/api/v1/movies").param("genre", "action"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.totalItems").value(1))
                .andExpect(jsonPath("$.data.items[0].slug").value("big-fight"))
                .andExpect(jsonPath("$.data.items[0].genres[0]").value("Action"))
                .andExpect(jsonPath("$.data.items[0].free").value(false));
        mvc.perform(get("/api/v1/movies").param("free", "true"))
                .andExpect(jsonPath("$.data.totalItems").value(1))
                .andExpect(jsonPath("$.data.items[0].slug").value("quiet-day"));
    }

    @Test
    void textSearchTreatsLikeWildcardsLiterally() throws Exception {
        mvc.perform(get("/api/v1/movies").param("q", "100%")).andExpect(jsonPath("$.data.totalItems").value(1));
        mvc.perform(get("/api/v1/movies").param("q", "%")).andExpect(jsonPath("$.data.totalItems").value(1));
        mvc.perform(get("/api/v1/movies").param("q", "fight")).andExpect(jsonPath("$.data.totalItems").value(1));
    }

    @Test
    void rejectsUnknownSortField() throws Exception {
        mvc.perform(get("/api/v1/movies").param("sort", "password"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.data.code").value("INVALID_SORT"));
    }

    @Test
    void detailAndNotFound() throws Exception {
        mvc.perform(get("/api/v1/movies/" + paidId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.name").value("Big Fight 100%"))
                .andExpect(jsonPath("$.data.priceCents").value(499))
                .andExpect(jsonPath("$.data.genres[0].slug").value("action"));
        mvc.perform(get("/api/v1/movies/by-slug/quiet-day")).andExpect(status().isOk());
        mvc.perform(get("/api/v1/movies/" + UUID.randomUUID()))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.data.code").value("MOVIE_NOT_FOUND"));
    }

    @Test
    void listsGenres() throws Exception {
        mvc.perform(get("/api/v1/genres"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].name").value("Action"))
                .andExpect(jsonPath("$.data.length()").value(2));
    }
}
