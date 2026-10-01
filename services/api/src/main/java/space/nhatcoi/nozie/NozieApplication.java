package space.nhatcoi.nozie;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class NozieApplication {

    public static void main(String[] args) {
        SpringApplication.run(NozieApplication.class, args);
    }
}
