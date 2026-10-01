package space.nhatcoi.nozie.dto.response;

import org.springframework.http.HttpStatus;

/** Standard envelope for every response: {@code { status, message, data }}. */
public record ApiResponse<T>(int status, String message, T data) {

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(HttpStatus.OK.value(), "OK", data);
    }

    public static <T> ApiResponse<T> ok(String message, T data) {
        return new ApiResponse<>(HttpStatus.OK.value(), message, data);
    }

    public static <T> ApiResponse<T> created(T data) {
        return new ApiResponse<>(HttpStatus.CREATED.value(), "Created", data);
    }

    public static ApiResponse<Void> ok(String message) {
        return new ApiResponse<>(HttpStatus.OK.value(), message, null);
    }

    public static <T> ApiResponse<T> error(HttpStatus status, String message, T data) {
        return new ApiResponse<>(status.value(), message, data);
    }
}
