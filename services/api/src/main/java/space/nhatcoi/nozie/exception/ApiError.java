package space.nhatcoi.nozie.exception;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;

/** Payload of {@code ApiResponse.data} when a request fails. */
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public record ApiError(String code, String path, List<FieldViolation> violations) {

    public record FieldViolation(String field, String message) {
    }
}
