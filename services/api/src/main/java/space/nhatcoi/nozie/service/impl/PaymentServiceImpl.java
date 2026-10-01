package space.nhatcoi.nozie.service.impl;

import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.request.PaymentIntentRequest;
import space.nhatcoi.nozie.dto.response.PaymentIntentResponse;
import space.nhatcoi.nozie.dto.response.TransactionResponse;
import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.entity.PaymentTransaction;
import space.nhatcoi.nozie.entity.StripeCustomer;
import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.enums.TransactionStatus;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.integration.PaymentGateway;
import space.nhatcoi.nozie.integration.PaymentGateway.PaymentEvent;
import space.nhatcoi.nozie.mapper.LibraryMapper;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.repository.PaymentTransactionRepository;
import space.nhatcoi.nozie.repository.ProcessedEventRepository;
import space.nhatcoi.nozie.repository.StripeCustomerRepository;
import space.nhatcoi.nozie.repository.UserRepository;
import space.nhatcoi.nozie.service.NotificationService;
import space.nhatcoi.nozie.service.PaymentService;
import space.nhatcoi.nozie.service.PurchaseService;

@Service
@Transactional
public class PaymentServiceImpl implements PaymentService {

    private static final Logger log = LoggerFactory.getLogger(PaymentServiceImpl.class);

    private final PaymentGateway gateway;
    private final MovieRepository movieRepository;
    private final UserRepository userRepository;
    private final PaymentTransactionRepository transactionRepository;
    private final StripeCustomerRepository customerRepository;
    private final ProcessedEventRepository processedEvents;
    private final PurchaseService purchaseService;
    private final NotificationService notificationService;
    private final LibraryMapper mapper;

    public PaymentServiceImpl(PaymentGateway gateway, MovieRepository movieRepository, UserRepository userRepository,
            PaymentTransactionRepository transactionRepository, StripeCustomerRepository customerRepository,
            ProcessedEventRepository processedEvents, PurchaseService purchaseService,
            NotificationService notificationService, LibraryMapper mapper) {
        this.gateway = gateway;
        this.movieRepository = movieRepository;
        this.userRepository = userRepository;
        this.transactionRepository = transactionRepository;
        this.customerRepository = customerRepository;
        this.processedEvents = processedEvents;
        this.purchaseService = purchaseService;
        this.notificationService = notificationService;
        this.mapper = mapper;
    }

    @Override
    public PaymentIntentResponse createIntent(UUID userId, PaymentIntentRequest request) {
        Movie movie = movieRepository.findById(request.movieId())
                .orElseThrow(() -> new ApiException(ErrorCode.MOVIE_NOT_FOUND));
        if (movie.getPriceCents() <= 0) {
            throw new ApiException(ErrorCode.FREE_MOVIE);
        }
        if (purchaseService.owns(userId, movie.getId())) {
            throw new ApiException(ErrorCode.ALREADY_PURCHASED);
        }
        User user = userRepository.findById(userId).orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
        String customerId = customerRepository.findById(userId).map(StripeCustomer::getStripeCustomerId)
                .orElseGet(() -> customerRepository.save(
                        new StripeCustomer(userId, gateway.createCustomer(userId, user.getEmail()))).getStripeCustomerId());

        // Amount and currency come from our catalog, never from the request.
        PaymentTransaction tx = transactionRepository.saveAndFlush(
                new PaymentTransaction(userId, movie.getId(), movie.getPriceCents(), movie.getCurrency()));
        PaymentGateway.PaymentIntentResult intent = gateway.createPaymentIntent(
                customerId, tx.getAmountCents(), tx.getCurrency(), tx.getId());
        tx.setStripePaymentIntentId(intent.id());
        String ephemeralKey = gateway.createEphemeralKey(customerId);
        return new PaymentIntentResponse(intent.clientSecret(), ephemeralKey, customerId, tx.getId(),
                tx.getAmountCents(), tx.getCurrency());
    }

    @Override
    @Transactional(readOnly = true)
    public TransactionResponse getTransaction(UUID userId, UUID transactionId) {
        return transactionRepository.findByIdAndUserId(transactionId, userId).map(mapper::toResponse)
                .orElseThrow(() -> new ApiException(ErrorCode.TRANSACTION_NOT_FOUND));
    }

    @Override
    public void handleWebhook(String payload, String signatureHeader) {
        PaymentEvent event = gateway.parseWebhook(payload, signatureHeader);
        if (event.type() == PaymentGateway.EventType.IGNORED) {
            return;
        }
        if (processedEvents.tryInsert(event.eventId(), event.type().name()) == 0) {
            log.info("Stripe event {} already processed, skipping", event.eventId());
            return;
        }
        PaymentTransaction tx = transactionRepository.findByStripePaymentIntentId(event.paymentIntentId()).orElse(null);
        if (tx == null) {
            log.warn("Stripe event {} references unknown payment intent", event.eventId());
            return;
        }
        switch (event.type()) {
            case SUCCEEDED -> onSucceeded(tx, event);
            case FAILED -> {
                if (tx.getStatus() == TransactionStatus.PENDING) {
                    tx.markFailed(event.errorMessage());
                }
            }
            case CANCELED -> {
                if (tx.getStatus() == TransactionStatus.PENDING) {
                    tx.markCanceled();
                }
            }
            default -> { }
        }
    }

    private void onSucceeded(PaymentTransaction tx, PaymentEvent event) {
        if (tx.getStatus() == TransactionStatus.SUCCEEDED) {
            return;
        }
        boolean amountOk = event.amountCents() != null && event.amountCents() == tx.getAmountCents()
                && tx.getCurrency().equalsIgnoreCase(event.currency());
        if (!amountOk) {
            // Never grant access for a payment that does not match what we asked to charge.
            log.error("Amount mismatch for transaction {}: expected {} {}, got {} {}", tx.getId(),
                    tx.getAmountCents(), tx.getCurrency(), event.amountCents(), event.currency());
            tx.markFailed("Amount mismatch");
            return;
        }
        tx.markSucceeded(event.chargeId());
        purchaseService.grant(tx.getUserId(), tx.getMovieId(), tx.getId());
        notificationService.create(tx.getUserId(), "purchase", "Purchase successful",
                "Your payment succeeded and the movie was added to your library.", "movie:" + tx.getMovieId(),
                Map.of("movieId", tx.getMovieId().toString(), "transactionId", tx.getId().toString()));
    }
}
