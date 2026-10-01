package space.nhatcoi.nozie.exception;

import org.springframework.http.HttpStatus;

/** Stable machine-readable error codes. The client switches on {@code code}, never on the message. */
public enum ErrorCode {

    VALIDATION_FAILED(HttpStatus.BAD_REQUEST, "Request validation failed"),
    MALFORMED_REQUEST(HttpStatus.BAD_REQUEST, "Malformed request"),
    INVALID_SORT(HttpStatus.BAD_REQUEST, "Unsupported sort field"),

    UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "Authentication required"),
    INVALID_CREDENTIALS(HttpStatus.UNAUTHORIZED, "Invalid email or password"),
    INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "Invalid or expired token"),
    INVALID_GOOGLE_TOKEN(HttpStatus.UNAUTHORIZED, "Invalid Google credential"),
    FORBIDDEN(HttpStatus.FORBIDDEN, "Access denied"),
    ACCOUNT_DISABLED(HttpStatus.FORBIDDEN, "Account is disabled"),

    NOT_FOUND(HttpStatus.NOT_FOUND, "Resource not found"),
    MOVIE_NOT_FOUND(HttpStatus.NOT_FOUND, "Movie not found"),
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "User not found"),
    METHOD_NOT_ALLOWED(HttpStatus.METHOD_NOT_ALLOWED, "Method not allowed"),

    REVIEW_NOT_FOUND(HttpStatus.NOT_FOUND, "Review not found"),
    EPISODE_NOT_FOUND(HttpStatus.NOT_FOUND, "Episode not found"),
    TRANSACTION_NOT_FOUND(HttpStatus.NOT_FOUND, "Transaction not found"),
    NOTIFICATION_NOT_FOUND(HttpStatus.NOT_FOUND, "Notification not found"),

    FREE_MOVIE(HttpStatus.BAD_REQUEST, "This movie is free and does not need a purchase"),
    INVALID_WEBHOOK(HttpStatus.BAD_REQUEST, "Invalid webhook signature"),
    PURCHASE_REQUIRED(HttpStatus.FORBIDDEN, "Purchase required to watch this movie"),
    ALREADY_PURCHASED(HttpStatus.CONFLICT, "You already own this movie"),
    PAYMENT_PROVIDER_ERROR(HttpStatus.BAD_GATEWAY, "Payment provider unavailable"),

    EMAIL_TAKEN(HttpStatus.CONFLICT, "Email is already registered"),
    USERNAME_TAKEN(HttpStatus.CONFLICT, "Username is already taken"),

    FILE_TOO_LARGE(HttpStatus.PAYLOAD_TOO_LARGE, "File is too large"),
    UNSUPPORTED_FILE_TYPE(HttpStatus.UNSUPPORTED_MEDIA_TYPE, "Unsupported file type"),

    INVALID_OTP(HttpStatus.BAD_REQUEST, "Invalid or expired code"),
    INVALID_RESET_TOKEN(HttpStatus.BAD_REQUEST, "Invalid or expired reset token"),

    TOO_MANY_REQUESTS(HttpStatus.TOO_MANY_REQUESTS, "Too many requests, try again later"),

    INTERNAL_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "Unexpected error");

    private final HttpStatus status;
    private final String defaultMessage;

    ErrorCode(HttpStatus status, String defaultMessage) {
        this.status = status;
        this.defaultMessage = defaultMessage;
    }

    public HttpStatus status() {
        return status;
    }

    public String defaultMessage() {
        return defaultMessage;
    }
}
