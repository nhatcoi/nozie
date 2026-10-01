package space.nhatcoi.nozie.security;

import java.util.List;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.configuration.AppProperties;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;

/** Verifies Google ID tokens server-side (signature, expiry, audience). The client never sends Google credentials beyond this token. */
@Component
public class GoogleTokenVerifierImpl implements GoogleTokenVerifier {

    private static final Logger log = LoggerFactory.getLogger(GoogleTokenVerifierImpl.class);

    private final GoogleIdTokenVerifier verifier;

    public GoogleTokenVerifierImpl(AppProperties properties) {
        List<String> clientIds = properties.google().clientIds().stream().filter(s -> !s.isBlank()).toList();
        if (clientIds.isEmpty()) {
            log.warn("nozie.google.client-ids is empty: Google sign-in is disabled");
            this.verifier = null;
        } else {
            this.verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), GsonFactory.getDefaultInstance())
                    .setAudience(clientIds)
                    .build();
        }
    }

    @Override
    public GoogleIdentity verify(String idToken) {
        if (verifier == null) {
            throw new ApiException(ErrorCode.INVALID_GOOGLE_TOKEN);
        }
        try {
            GoogleIdToken token = verifier.verify(idToken);
            if (token == null) {
                throw new ApiException(ErrorCode.INVALID_GOOGLE_TOKEN);
            }
            GoogleIdToken.Payload p = token.getPayload();
            return new GoogleIdentity(p.getSubject(), p.getEmail(), Boolean.TRUE.equals(p.getEmailVerified()),
                    (String) p.get("name"));
        } catch (ApiException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Google token verification failed: {}", e.toString());
            throw new ApiException(ErrorCode.INVALID_GOOGLE_TOKEN);
        }
    }
}
