package space.nhatcoi.nozie.util;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.http.HttpHeaders;

/** Caller metadata stored with refresh tokens for session auditing. */
public record ClientInfo(String userAgent, String ip) {

    public static ClientInfo from(HttpServletRequest request) {
        return new ClientInfo(request.getHeader(HttpHeaders.USER_AGENT), request.getRemoteAddr());
    }
}
