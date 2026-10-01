package space.nhatcoi.nozie.configuration;

import java.time.Duration;
import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "nozie")
public record AppProperties(Cors cors, Jwt jwt, Google google, Otp otp, Mail mail, Stripe stripe) {

    public AppProperties {
        cors = cors == null ? new Cors(null) : cors;
        google = google == null ? new Google(null) : google;
        otp = otp == null ? new Otp(null, 0, 0) : otp;
        mail = mail == null ? new Mail(null) : mail;
        stripe = stripe == null ? new Stripe(null, null) : stripe;
    }

    public record Cors(List<String> allowedOrigins) {
        public Cors {
            allowedOrigins = allowedOrigins == null ? List.of() : List.copyOf(allowedOrigins);
        }
    }

    /** HS256 signing secret must be at least 32 bytes; startup fails otherwise. */
    public record Jwt(String secret, Duration accessTtl, Duration refreshTtl) {
        public Jwt {
            if (secret == null || secret.getBytes(java.nio.charset.StandardCharsets.UTF_8).length < 32) {
                throw new IllegalStateException("nozie.jwt.secret (JWT_SECRET) must be at least 32 bytes");
            }
            accessTtl = accessTtl == null ? Duration.ofMinutes(15) : accessTtl;
            refreshTtl = refreshTtl == null ? Duration.ofDays(30) : refreshTtl;
        }
    }

    /** OAuth client ids (web/android/ios) whose Google ID tokens we accept. */
    public record Google(List<String> clientIds) {
        public Google {
            clientIds = clientIds == null ? List.of() : List.copyOf(clientIds);
        }
    }

    public record Otp(Duration ttl, int maxAttempts, int maxRequests) {
        public Otp {
            ttl = ttl == null ? Duration.ofMinutes(10) : ttl;
            maxAttempts = maxAttempts <= 0 ? 5 : maxAttempts;
            maxRequests = maxRequests <= 0 ? 3 : maxRequests;
        }
    }

    public record Mail(String from) {
        public Mail {
            from = from == null || from.isBlank() ? "no-reply@nozie.local" : from;
        }
    }

    /** Stripe credentials. Blank is allowed at startup; payment endpoints then fail with PAYMENT_PROVIDER_ERROR. */
    public record Stripe(String secretKey, String webhookSecret) {
    }
}
