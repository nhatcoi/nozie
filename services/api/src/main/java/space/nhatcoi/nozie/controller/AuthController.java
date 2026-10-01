package space.nhatcoi.nozie.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.dto.request.ForgotPasswordRequest;
import space.nhatcoi.nozie.dto.request.GoogleLoginRequest;
import space.nhatcoi.nozie.dto.request.LoginRequest;
import space.nhatcoi.nozie.dto.request.RefreshTokenRequest;
import space.nhatcoi.nozie.dto.request.RegisterRequest;
import space.nhatcoi.nozie.dto.request.ResetPasswordRequest;
import space.nhatcoi.nozie.dto.request.VerifyOtpRequest;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.AuthResponse;
import space.nhatcoi.nozie.dto.response.ResetTokenResponse;
import space.nhatcoi.nozie.service.AuthService;
import space.nhatcoi.nozie.service.PasswordResetService;
import space.nhatcoi.nozie.util.ClientInfo;

@RestController
@RequestMapping("/auth")
@Tag(name = "Auth")
@SecurityRequirements
public class AuthController {

    private final AuthService authService;
    private final PasswordResetService passwordResetService;

    public AuthController(AuthService authService, PasswordResetService passwordResetService) {
        this.authService = authService;
        this.passwordResetService = passwordResetService;
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AuthResponse> register(@Valid @RequestBody RegisterRequest request, HttpServletRequest http) {
        return ApiResponse.created(authService.register(request, ClientInfo.from(http)));
    }

    @PostMapping("/login")
    public ApiResponse<AuthResponse> login(@Valid @RequestBody LoginRequest request, HttpServletRequest http) {
        return ApiResponse.ok(authService.login(request, ClientInfo.from(http)));
    }

    @PostMapping("/google")
    public ApiResponse<AuthResponse> google(@Valid @RequestBody GoogleLoginRequest request, HttpServletRequest http) {
        return ApiResponse.ok(authService.loginWithGoogle(request, ClientInfo.from(http)));
    }

    @PostMapping("/refresh")
    public ApiResponse<AuthResponse> refresh(@Valid @RequestBody RefreshTokenRequest request, HttpServletRequest http) {
        return ApiResponse.ok(authService.refresh(request, ClientInfo.from(http)));
    }

    @PostMapping("/logout")
    public ApiResponse<Void> logout(@Valid @RequestBody RefreshTokenRequest request) {
        authService.logout(request);
        return ApiResponse.ok("Logged out");
    }

    @PostMapping("/password/otp")
    public ApiResponse<Void> requestOtp(@Valid @RequestBody ForgotPasswordRequest request) {
        passwordResetService.requestOtp(request);
        return ApiResponse.ok("If the email is registered, a code has been sent");
    }

    @PostMapping("/password/verify")
    public ApiResponse<ResetTokenResponse> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        return ApiResponse.ok(passwordResetService.verifyOtp(request));
    }

    @PostMapping("/password/reset")
    public ApiResponse<Void> reset(@Valid @RequestBody ResetPasswordRequest request) {
        passwordResetService.resetPassword(request);
        return ApiResponse.ok("Password updated");
    }
}
