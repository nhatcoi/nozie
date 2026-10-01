package space.nhatcoi.nozie.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Hidden;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;

import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.service.PaymentService;

/** Public by necessity; authenticity comes solely from the Stripe signature over the raw body. */
@RestController
@RequestMapping("/webhooks")
@Hidden
@SecurityRequirements
public class StripeWebhookController {

    private final PaymentService paymentService;

    public StripeWebhookController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/stripe")
    public ApiResponse<Void> stripe(@RequestBody String payload,
            @RequestHeader(value = "Stripe-Signature", required = false) String signature) {
        paymentService.handleWebhook(payload, signature);
        return ApiResponse.ok("Received");
    }
}
