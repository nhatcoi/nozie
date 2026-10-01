package space.nhatcoi.nozie.dto.response;

import java.util.UUID;

/** Public episode listing; never contains stream URLs. */
public record EpisodeResponse(UUID id, String serverName, String name, String slug, int position) {
}
