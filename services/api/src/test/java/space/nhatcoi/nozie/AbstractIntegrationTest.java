package space.nhatcoi.nozie;

import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.testcontainers.containers.PostgreSQLContainer;

@SpringBootTest
@ActiveProfiles("test")
public abstract class AbstractIntegrationTest {

    /** Singleton: started once and shared, so Spring's cached contexts never point at a stopped container. */
    @ServiceConnection
    static final PostgreSQLContainer<?> POSTGRES = new PostgreSQLContainer<>("postgres:16");

    static {
        POSTGRES.start();
    }

    @Autowired
    private JdbcTemplate baseJdbc;

    /** Every test starts from an empty database regardless of which class ran before it. */
    @BeforeEach
    void resetDatabase() {
        baseJdbc.execute("TRUNCATE users, movies, genres, processed_events RESTART IDENTITY CASCADE");
    }
}
