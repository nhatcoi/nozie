package space.nhatcoi.nozie.dto.request;

import java.util.UUID;

import jakarta.validation.constraints.NotNull;

/** Only the movie id: the price is always read from the database, never from the client. */
public record PaymentIntentRequest(@NotNull UUID movieId) {
}
