# Nozie API

Spring Boot 3.4 · Java 21 · Maven · PostgreSQL · Flyway · JWT.

## Layout (`space.nhatcoi.nozie`)

| Package | Role |
|---|---|
| `configuration` | Security, CORS, OpenAPI, JPA auditing, async, `/api/v1` prefix, typed `AppProperties` |
| `controller` | REST endpoints only: validate input, call a service, wrap in `ApiResponse` |
| `service` / `service.impl` | Business logic behind interfaces; owns transactions |
| `repository` | Spring Data JPA |
| `entity` | JPA entities (`BaseEntity` gives `createdAt`/`updatedAt`) |
| `dto.request` / `dto.response` | API contract. Entities never leave the service layer |
| `mapper` | Entity → response DTO |
| `specification` | Composable query filters |
| `security` | JWT service/filter, Google token verifier, 401/403 handlers |
| `exception` | `ApiException`, `ErrorCode`, global handler |
| `enums`, `constant`, `util` | Shared small pieces |

Every response is `{ status, message, data }`. Errors carry `data.code` (see `ErrorCode`); clients switch on the code, not the message.

## Run

```bash
cp infra/.env.example infra/.env
docker compose -f infra/docker-compose.yml up -d postgres mailhog
cd services/api
DB_URL=jdbc:postgresql://localhost:5432/nozie DB_USER=nozie DB_PASSWORD=change-me-dev-only \
JWT_SECRET=$(openssl rand -base64 48) MAIL_HOST=localhost \
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

Swagger UI (dev only): http://localhost:8080/swagger-ui.html · OTP emails: http://localhost:8025

## Test

`mvn verify` — integration tests run against a real PostgreSQL via Testcontainers (Docker required).
