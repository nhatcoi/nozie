package space.nhatcoi.nozie.controller;

import java.util.UUID;

import jakarta.validation.Valid;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.dto.request.PaymentIntentRequest;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.PaymentIntentResponse;
import space.nhatcoi.nozie.dto.response.TransactionResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.PaymentService;

@RestController
@RequestMapping("/payments")
@Tag(name = "Payments")
public class PaymentController {

    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/intents")
    public ApiResponse<PaymentIntentResponse> createIntent(@AuthenticationPrincipal AuthenticatedUser user,
            @Valid @RequestBody PaymentIntentRequest request) {
        return ApiResponse.ok(paymentService.createIntent(user.id(), request));
    }

    /** Clients poll this after the payment sheet closes; the webhook is what actually grants access. */
    @GetMapping("/{transactionId}")
    public ApiResponse<TransactionResponse> get(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID transactionId) {
        return ApiResponse.ok(paymentService.getTransaction(user.id(), transactionId));
    }
}
