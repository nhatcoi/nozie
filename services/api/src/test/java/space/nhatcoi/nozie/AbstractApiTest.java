package space.nhatcoi.nozie;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

import java.util.Map;
import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

/** Shared helpers for tests that call the API as a logged-in user. */
@AutoConfigureMockMvc
abstract class AbstractApiTest extends AbstractIntegrationTest {

    static final String PASSWORD = "Passw0rd-ok";

    @Autowired protected MockMvc mvc;
    @Autowired protected ObjectMapper json;
    @Autowired protected JdbcTemplate jdbc;

    record TestUser(UUID id, String token) {
        String bearer() {
            return "Bearer " + token;
        }
    }

    protected TestUser register(String email) throws Exception {
        String body = json.writeValueAsString(Map.of("email", email, "password", PASSWORD, "fullName", "User " + email));
        String res = mvc.perform(post("/api/v1/auth/register").contentType(MediaType.APPLICATION_JSON).content(body))
                .andReturn().getResponse().getContentAsString();
        JsonNode data = json.readTree(res).get("data");
        return new TestUser(UUID.fromString(data.get("user").get("id").asText()), data.get("accessToken").asText());
    }

    protected MockHttpServletRequestBuilder asUser(MockHttpServletRequestBuilder b, TestUser u) {
        return b.header("Authorization", u.bearer());
    }

    protected MockHttpServletRequestBuilder withJson(MockHttpServletRequestBuilder b, Object body) throws Exception {
        return b.contentType(MediaType.APPLICATION_JSON).content(json.writeValueAsString(body));
    }

    protected JsonNode data(ResultActions r) throws Exception {
        return json.readTree(r.andReturn().getResponse().getContentAsString()).get("data");
    }

    protected UUID movie(String slug, int priceCents) {
        UUID id = UUID.randomUUID();
        jdbc.update("insert into movies (id, slug, name, type, year, price_cents) values (?, ?, ?, 'single', 2020, ?)",
                id, slug, "Movie " + slug, priceCents);
        return id;
    }

    protected UUID episode(UUID movieId, String name, String url) {
        UUID id = UUID.randomUUID();
        jdbc.update("insert into episodes (id, movie_id, name, slug, stream_url, position) values (?, ?, ?, ?, ?, 0)",
                id, movieId, name, name.toLowerCase(), url);
        return id;
    }
}
