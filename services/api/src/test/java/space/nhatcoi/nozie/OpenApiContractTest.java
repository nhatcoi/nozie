package space.nhatcoi.nozie;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;

/**
 * Regenerates {@code contracts/openapi.json}, the single source of truth the Flutter client is generated from.
 * Run {@code mvn verify}, then commit the changed file. With {@code -Dcontract.check=true} (CI) the test fails
 * instead of rewriting, so an API change cannot be merged without updating the contract.
 */
@AutoConfigureMockMvc
@TestPropertySource(properties = {"springdoc.api-docs.enabled=true"})
class OpenApiContractTest extends AbstractIntegrationTest {

    private static final Path CONTRACT = Path.of("../../contracts/openapi.json");

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;

    @Test
    void contractIsUpToDate() throws Exception {
        String raw = mvc.perform(get("/v3/api-docs")).andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        JsonNode tree = mapper.readTree(raw);
        String pretty = mapper.copy().enable(SerializationFeature.ORDER_MAP_ENTRIES_BY_KEYS)
                .enable(SerializationFeature.INDENT_OUTPUT).writeValueAsString(
                        mapper.copy().enable(SerializationFeature.ORDER_MAP_ENTRIES_BY_KEYS)
                                .convertValue(tree, Object.class)) + "\n";

        assertThat(tree.get("paths").has("/api/v1/auth/login")).isTrue();
        assertThat(tree.get("paths").has("/api/v1/payments/intents")).isTrue();

        if (Boolean.getBoolean("contract.check")) {
            assertThat(Files.exists(CONTRACT)).as("contracts/openapi.json must be committed").isTrue();
            assertThat(Files.readString(CONTRACT, StandardCharsets.UTF_8))
                    .as("contracts/openapi.json is stale: run `mvn verify` locally and commit it")
                    .isEqualTo(pretty);
        } else {
            Files.createDirectories(CONTRACT.getParent());
            Files.writeString(CONTRACT, pretty, StandardCharsets.UTF_8);
        }
    }
}
