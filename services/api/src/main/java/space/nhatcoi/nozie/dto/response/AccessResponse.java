package space.nhatcoi.nozie.dto.response;

/** Whether the caller may watch a movie, and why. */
public record AccessResponse(boolean canWatch, boolean free, boolean owned) {
}
