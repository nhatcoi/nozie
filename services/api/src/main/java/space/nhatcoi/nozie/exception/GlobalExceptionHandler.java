package space.nhatcoi.nozie.exception;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.HandlerMethodValidationException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import space.nhatcoi.nozie.dto.response.ApiResponse;

/** Single place that turns exceptions into the {@link ApiResponse} envelope. Never leaks internals. */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(ApiException.class)
    ResponseEntity<ApiResponse<ApiError>> handleApi(ApiException ex, HttpServletRequest req) {
        return build(ex.errorCode(), ex.getMessage(), req, List.of());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<ApiResponse<ApiError>> handleValidation(MethodArgumentNotValidException ex, HttpServletRequest req) {
        List<ApiError.FieldViolation> violations = ex.getBindingResult().getFieldErrors().stream()
                .map(f -> new ApiError.FieldViolation(f.getField(), f.getDefaultMessage()))
                .toList();
        return build(ErrorCode.VALIDATION_FAILED, null, req, violations);
    }

    @ExceptionHandler({HttpMessageNotReadableException.class, MethodArgumentTypeMismatchException.class,
            MissingServletRequestParameterException.class, HandlerMethodValidationException.class})
    ResponseEntity<ApiResponse<ApiError>> handleMalformed(Exception ex, HttpServletRequest req) {
        return build(ErrorCode.MALFORMED_REQUEST, null, req, List.of());
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    ResponseEntity<ApiResponse<ApiError>> handleMethod(HttpRequestMethodNotSupportedException ex, HttpServletRequest req) {
        return build(ErrorCode.METHOD_NOT_ALLOWED, null, req, List.of());
    }

    @ExceptionHandler(NoResourceFoundException.class)
    ResponseEntity<ApiResponse<ApiError>> handleNoResource(NoResourceFoundException ex, HttpServletRequest req) {
        return build(ErrorCode.NOT_FOUND, null, req, List.of());
    }

    @ExceptionHandler(AccessDeniedException.class)
    ResponseEntity<ApiResponse<ApiError>> handleDenied(AccessDeniedException ex, HttpServletRequest req) {
        return build(ErrorCode.FORBIDDEN, null, req, List.of());
    }

    @ExceptionHandler(Exception.class)
    ResponseEntity<ApiResponse<ApiError>> handleUnexpected(Exception ex, HttpServletRequest req) {
        log.error("Unhandled exception on {} {}", req.getMethod(), req.getRequestURI(), ex);
        return build(ErrorCode.INTERNAL_ERROR, null, req, List.of());
    }

    private static ResponseEntity<ApiResponse<ApiError>> build(
            ErrorCode code, String message, HttpServletRequest req, List<ApiError.FieldViolation> violations) {
        String text = message != null ? message : code.defaultMessage();
        ApiError detail = new ApiError(code.name(), req.getRequestURI(), violations);
        return ResponseEntity.status(code.status()).body(ApiResponse.error(code.status(), text, detail));
    }
}
