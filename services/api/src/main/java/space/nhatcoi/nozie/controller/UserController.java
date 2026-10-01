package space.nhatcoi.nozie.controller;

import java.util.List;

import jakarta.validation.Valid;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.dto.request.ChangePasswordRequest;
import space.nhatcoi.nozie.dto.request.FavoriteGenresRequest;
import space.nhatcoi.nozie.dto.request.UpdateProfileRequest;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.GenreResponse;
import space.nhatcoi.nozie.dto.response.UserResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.FavoriteGenreService;
import space.nhatcoi.nozie.service.UserService;

/** The caller's identity always comes from the JWT; no user id is ever accepted from the client. */
@RestController
@RequestMapping("/users/me")
@Tag(name = "User")
public class UserController {

    private final UserService userService;
    private final FavoriteGenreService favoriteGenreService;

    public UserController(UserService userService, FavoriteGenreService favoriteGenreService) {
        this.userService = userService;
        this.favoriteGenreService = favoriteGenreService;
    }

    @GetMapping
    public ApiResponse<UserResponse> me(@AuthenticationPrincipal AuthenticatedUser user) {
        return ApiResponse.ok(userService.getProfile(user.id()));
    }

    @PatchMapping
    public ApiResponse<UserResponse> update(@AuthenticationPrincipal AuthenticatedUser user,
            @Valid @RequestBody UpdateProfileRequest request) {
        return ApiResponse.ok(userService.updateProfile(user.id(), request));
    }

    @GetMapping("/favorite-genres")
    public ApiResponse<List<GenreResponse>> favoriteGenres(@AuthenticationPrincipal AuthenticatedUser user) {
        return ApiResponse.ok(favoriteGenreService.list(user.id()));
    }

    @PutMapping("/favorite-genres")
    public ApiResponse<List<GenreResponse>> setFavoriteGenres(@AuthenticationPrincipal AuthenticatedUser user,
            @Valid @RequestBody FavoriteGenresRequest request) {
        return ApiResponse.ok(favoriteGenreService.replace(user.id(), request.genres()));
    }

    @PostMapping("/password")
    public ApiResponse<Void> changePassword(@AuthenticationPrincipal AuthenticatedUser user,
            @Valid @RequestBody ChangePasswordRequest request) {
        userService.changePassword(user.id(), request);
        return ApiResponse.ok("Password updated");
    }
}
