package space.nhatcoi.nozie.security;

import java.io.IOException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.http.MediaType;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.exception.ApiError;
import space.nhatcoi.nozie.exception.ErrorCode;

/** Writes 401/403 produced by the security filter chain using the standard envelope. */
@Component
public class RestSecurityHandlers implements AuthenticationEntryPoint, AccessDeniedHandler {

    private final ObjectMapper objectMapper;

    public RestSecurityHandlers(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void commence(HttpServletRequest req, HttpServletResponse res, org.springframework.security.core.AuthenticationException ex)
            throws IOException {
        write(req, res, ErrorCode.UNAUTHORIZED);
    }

    @Override
    public void handle(HttpServletRequest req, HttpServletResponse res, org.springframework.security.access.AccessDeniedException ex)
            throws IOException {
        write(req, res, ErrorCode.FORBIDDEN);
    }

    private void write(HttpServletRequest req, HttpServletResponse res, ErrorCode code) throws IOException {
        res.setStatus(code.status().value());
        res.setContentType(MediaType.APPLICATION_JSON_VALUE);
        objectMapper.writeValue(res.getOutputStream(), ApiResponse.error(
                code.status(), code.defaultMessage(), new ApiError(code.name(), req.getRequestURI(), null)));
    }
}
