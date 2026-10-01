package space.nhatcoi.nozie;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.security.GoogleTokenVerifier;
import space.nhatcoi.nozie.service.MailService;

@AutoConfigureMockMvc
class AuthApiTest extends AbstractIntegrationTest {

    static final String PASSWORD = "Passw0rd-ok";

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    @Autowired JdbcTemplate jdbc;
    @MockitoBean MailService mailService;
    @MockitoBean GoogleTokenVerifier googleVerifier;

    @BeforeEach
    void clean() {
        jdbc.update("delete from password_resets");
        jdbc.update("delete from refresh_tokens");
        jdbc.update("delete from users");
    }

    ResultActions call(String path, Object body) throws Exception {
        return mvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post("/api/v1" + path).contentType(MediaType.APPLICATION_JSON).content(json.writeValueAsString(body)));
    }

    JsonNode data(ResultActions r) throws Exception {
        return json.readTree(r.andReturn().getResponse().getContentAsString()).get("data");
    }

    JsonNode register(String email) throws Exception {
        return data(call("/auth/register", Map.of("email", email, "password", PASSWORD, "fullName", "Test User"))
                .andExpect(status().isCreated()));
    }

    @Test
    void registerThenMeThenDuplicate() throws Exception {
        JsonNode auth = register("A@Example.com");
        assertThat(auth.get("user").get("email").asText()).isEqualTo("a@example.com");
        assertThat(auth.get("tokenType").asText()).isEqualTo("Bearer");

        mvc.perform(get("/api/v1/users/me").header("Authorization", "Bearer " + auth.get("accessToken").asText()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.fullName").value("Test User"));

        call("/auth/register", Map.of("email", "a@example.com", "password", PASSWORD, "fullName", "X"))
                .andExpect(status().isConflict()).andExpect(jsonPath("$.data.code").value("EMAIL_TAKEN"));
    }

    @Test
    void weakPasswordRejected() throws Exception {
        call("/auth/register", Map.of("email", "w@example.com", "password", "short", "fullName", "W"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.data.code").value("VALIDATION_FAILED"));
    }

    @Test
    void loginSuccessAndGenericFailure() throws Exception {
        register("l@example.com");
        call("/auth/login", Map.of("email", "L@example.com", "password", PASSWORD)).andExpect(status().isOk());
        call("/auth/login", Map.of("email", "l@example.com", "password", "wrong-Pass1"))
                .andExpect(status().isUnauthorized()).andExpect(jsonPath("$.data.code").value("INVALID_CREDENTIALS"));
        call("/auth/login", Map.of("email", "nobody@example.com", "password", PASSWORD))
                .andExpect(status().isUnauthorized()).andExpect(jsonPath("$.data.code").value("INVALID_CREDENTIALS"));
    }

    @Test
    void tamperedAccessTokenIsRejected() throws Exception {
        String token = register("t@example.com").get("accessToken").asText();
        mvc.perform(get("/api/v1/users/me").header("Authorization", "Bearer " + token + "x"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void refreshRotatesAndReplayRevokesFamily() throws Exception {
        String r1 = register("r@example.com").get("refreshToken").asText();
        JsonNode second = data(call("/auth/refresh", Map.of("refreshToken", r1)).andExpect(status().isOk()));
        String r2 = second.get("refreshToken").asText();
        assertThat(r2).isNotEqualTo(r1);

        // replaying the already-used token fails and burns the whole family
        call("/auth/refresh", Map.of("refreshToken", r1)).andExpect(status().isUnauthorized());
        call("/auth/refresh", Map.of("refreshToken", r2)).andExpect(status().isUnauthorized());
    }

    @Test
    void logoutRevokesRefreshToken() throws Exception {
        String r = register("o@example.com").get("refreshToken").asText();
        call("/auth/logout", Map.of("refreshToken", r)).andExpect(status().isOk());
        call("/auth/refresh", Map.of("refreshToken", r)).andExpect(status().isUnauthorized());
    }

    @Test
    void googleLoginCreatesThenReusesAccount() throws Exception {
        when(googleVerifier.verify("good")).thenReturn(new GoogleTokenVerifier.GoogleIdentity("sub-1", "g@example.com", true, "Gee"));
        when(googleVerifier.verify("bad")).thenThrow(new ApiException(ErrorCode.INVALID_GOOGLE_TOKEN));

        String id1 = data(call("/auth/google", Map.of("idToken", "good")).andExpect(status().isOk())).get("user").get("id").asText();
        String id2 = data(call("/auth/google", Map.of("idToken", "good")).andExpect(status().isOk())).get("user").get("id").asText();
        assertThat(id1).isEqualTo(id2);
        call("/auth/google", Map.of("idToken", "bad")).andExpect(status().isUnauthorized());
    }

    @Test
    void googleLoginLinksExistingPasswordAccount() throws Exception {
        String id = register("link@example.com").get("user").get("id").asText();
        when(googleVerifier.verify("g")).thenReturn(new GoogleTokenVerifier.GoogleIdentity("sub-2", "link@example.com", true, "L"));
        String gid = data(call("/auth/google", Map.of("idToken", "g")).andExpect(status().isOk())).get("user").get("id").asText();
        assertThat(gid).isEqualTo(id);
    }

    @Test
    void updateProfileAndUsernameUniqueness() throws Exception {
        String t1 = register("p1@example.com").get("accessToken").asText();
        String t2 = register("p2@example.com").get("accessToken").asText();
        mvc.perform(patch("/api/v1/users/me").header("Authorization", "Bearer " + t1)
                        .contentType(MediaType.APPLICATION_JSON).content("{\"username\":\"coolguy\",\"country\":\"VN\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.username").value("coolguy"));
        mvc.perform(patch("/api/v1/users/me").header("Authorization", "Bearer " + t2)
                        .contentType(MediaType.APPLICATION_JSON).content("{\"username\":\"CoolGuy\"}"))
                .andExpect(status().isConflict()).andExpect(jsonPath("$.data.code").value("USERNAME_TAKEN"));
    }

    @Test
    void passwordResetFlow() throws Exception {
        String refresh = register("reset@example.com").get("refreshToken").asText();

        call("/auth/password/otp", Map.of("email", "reset@example.com")).andExpect(status().isOk());
        ArgumentCaptor<String> code = ArgumentCaptor.forClass(String.class);
        verify(mailService).sendPasswordResetOtp(eq("reset@example.com"), code.capture(), anyLong());

        // wrong code is rejected, right code accepted
        call("/auth/password/verify", Map.of("email", "reset@example.com", "code", "000000".equals(code.getValue()) ? "111111" : "000000"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.data.code").value("INVALID_OTP"));
        String token = data(call("/auth/password/verify", Map.of("email", "reset@example.com", "code", code.getValue()))
                .andExpect(status().isOk())).get("resetToken").asText();

        // a verified OTP cannot be verified twice
        call("/auth/password/verify", Map.of("email", "reset@example.com", "code", code.getValue())).andExpect(status().isBadRequest());

        call("/auth/password/reset", Map.of("resetToken", token, "newPassword", "Brand-New-1")).andExpect(status().isOk());
        call("/auth/password/reset", Map.of("resetToken", token, "newPassword", "Another-One-2"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.data.code").value("INVALID_RESET_TOKEN"));

        call("/auth/login", Map.of("email", "reset@example.com", "password", "Brand-New-1")).andExpect(status().isOk());
        call("/auth/login", Map.of("email", "reset@example.com", "password", PASSWORD)).andExpect(status().isUnauthorized());
        call("/auth/refresh", Map.of("refreshToken", refresh)).andExpect(status().isUnauthorized());
    }

    @Test
    void otpLockedAfterTooManyWrongAttempts() throws Exception {
        register("lock@example.com");
        call("/auth/password/otp", Map.of("email", "lock@example.com")).andExpect(status().isOk());
        ArgumentCaptor<String> code = ArgumentCaptor.forClass(String.class);
        verify(mailService).sendPasswordResetOtp(eq("lock@example.com"), code.capture(), anyLong());
        String wrong = "000000".equals(code.getValue()) ? "111111" : "000000";
        for (int i = 0; i < 5; i++) {
            call("/auth/password/verify", Map.of("email", "lock@example.com", "code", wrong)).andExpect(status().isBadRequest());
        }
        // even the correct code is refused now
        call("/auth/password/verify", Map.of("email", "lock@example.com", "code", code.getValue())).andExpect(status().isBadRequest());
    }

    @Test
    void otpRequestForUnknownEmailLooksIdentical() throws Exception {
        call("/auth/password/otp", Map.of("email", "ghost@example.com")).andExpect(status().isOk());
        org.mockito.Mockito.verifyNoInteractions(mailService);
    }
}
