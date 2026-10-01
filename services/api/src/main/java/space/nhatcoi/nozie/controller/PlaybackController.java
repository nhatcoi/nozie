package space.nhatcoi.nozie.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.dto.response.AccessResponse;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.EpisodeResponse;
import space.nhatcoi.nozie.dto.response.StreamResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.PlaybackService;

@RestController
@Tag(name = "Playback")
public class PlaybackController {

    private final PlaybackService playbackService;

    public PlaybackController(PlaybackService playbackService) {
        this.playbackService = playbackService;
    }

    /** Public listing (no URLs). Lives under /movies so it inherits the public-GET rule. */
    @GetMapping("/movies/{movieId}/episodes")
    public ApiResponse<List<EpisodeResponse>> episodes(@PathVariable UUID movieId) {
        return ApiResponse.ok(playbackService.listEpisodes(movieId));
    }

    @GetMapping("/playback/{movieId}/access")
    public ApiResponse<AccessResponse> access(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId) {
        return ApiResponse.ok(playbackService.access(user.id(), movieId));
    }

    /** Deliberately NOT under /movies: this path requires a token and an entitlement. */
    @GetMapping("/playback/{movieId}")
    public ApiResponse<StreamResponse> stream(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID movieId,
            @RequestParam(required = false) UUID episodeId) {
        return ApiResponse.ok(playbackService.resolveStream(user.id(), movieId, episodeId));
    }
}
