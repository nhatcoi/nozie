package space.nhatcoi.nozie.service;

import space.nhatcoi.nozie.dto.request.GoogleLoginRequest;
import space.nhatcoi.nozie.dto.request.LoginRequest;
import space.nhatcoi.nozie.dto.request.RefreshTokenRequest;
import space.nhatcoi.nozie.dto.request.RegisterRequest;
import space.nhatcoi.nozie.dto.response.AuthResponse;
import space.nhatcoi.nozie.util.ClientInfo;

public interface AuthService {

    AuthResponse register(RegisterRequest request, ClientInfo client);

    AuthResponse login(LoginRequest request, ClientInfo client);

    AuthResponse loginWithGoogle(GoogleLoginRequest request, ClientInfo client);

    AuthResponse refresh(RefreshTokenRequest request, ClientInfo client);

    void logout(RefreshTokenRequest request);
}
