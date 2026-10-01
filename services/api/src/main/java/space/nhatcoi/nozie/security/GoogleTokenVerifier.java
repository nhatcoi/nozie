package space.nhatcoi.nozie.security;

public interface GoogleTokenVerifier {

    /** @throws space.nhatcoi.nozie.exception.ApiException INVALID_GOOGLE_TOKEN when the token is invalid, expired or has a foreign audience */
    GoogleIdentity verify(String idToken);

    record GoogleIdentity(String subject, String email, boolean emailVerified, String name) {
    }
}
