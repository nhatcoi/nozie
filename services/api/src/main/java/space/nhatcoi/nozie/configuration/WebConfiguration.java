package space.nhatcoi.nozie.configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.HandlerTypePredicate;
import org.springframework.web.servlet.config.annotation.PathMatchConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/** Every {@code @RestController} in the controller package is served under {@value #API_PREFIX}. */
@Configuration
public class WebConfiguration implements WebMvcConfigurer {

    public static final String API_PREFIX = "/api/v1";

    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.addPathPrefix(API_PREFIX,
                HandlerTypePredicate.forAnnotation(RestController.class)
                        .and(HandlerTypePredicate.forBasePackage("space.nhatcoi.nozie.controller")));
    }
}
