package space.nhatcoi.nozie;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.Assertions.assertThat;

@AutoConfigureMockMvc
class ApiSmokeTest extends AbstractIntegrationTest {

    @Autowired
    MockMvc mvc;

    @Autowired
    JdbcTemplate jdbc;

    @Test
    void healthIsPublic() throws Exception {
        mvc.perform(get("/actuator/health")).andExpect(status().isOk()).andExpect(jsonPath("$.status").value("UP"));
    }

    @Test
    void protectedRouteRequiresAuth() throws Exception {
        mvc.perform(get("/api/v1/users/me")).andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.data.code").value("UNAUTHORIZED"));
    }

    @Test
    void flywayMigrationCreatesSchema() {
        Integer tables = jdbc.queryForObject(
                "select count(*) from information_schema.tables where table_schema = 'public' "
                        + "and table_name in ('users','movies','purchases','transactions','processed_events')",
                Integer.class);
        assertThat(tables).isEqualTo(5);
    }
}
