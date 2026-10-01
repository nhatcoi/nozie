package space.nhatcoi.nozie.security;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

import javax.crypto.SecretKey;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.configuration.AppProperties;

/** Issues and verifies short-lived access tokens. Refresh tokens are opaque and handled elsewhere. */
@Component
public class JwtService {

    private static final String ROLE_CLAIM = "role";

    private final SecretKey key;
    private final AppProperties.Jwt props;

    public JwtService(AppProperties properties) {
        this.props = properties.jwt();
        this.key = Keys.hmacShaKeyFor(props.secret().getBytes(StandardCharsets.UTF_8));
    }

    public String createAccessToken(UUID userId, String role) {
        Instant now = Instant.now();
        return Jwts.builder()
                .subject(userId.toString())
                .claim(ROLE_CLAIM, role)
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plus(props.accessTtl())))
                .signWith(key)
                .compact();
    }

    public long accessTtlSeconds() {
        return props.accessTtl().toSeconds();
    }

    /** Empty when the token is malformed, tampered with or expired. */
    public Optional<AuthenticatedUser> parse(String token) {
        try {
            Claims claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload();
            return Optional.of(new AuthenticatedUser(UUID.fromString(claims.getSubject()), claims.get(ROLE_CLAIM, String.class)));
        } catch (JwtException | IllegalArgumentException e) {
            return Optional.empty();
        }
    }
}
