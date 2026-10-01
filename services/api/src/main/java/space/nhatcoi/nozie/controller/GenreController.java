package space.nhatcoi.nozie.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.GenreResponse;
import space.nhatcoi.nozie.service.GenreService;

@RestController
@RequestMapping("/genres")
@Tag(name = "Catalog")
public class GenreController {

    private final GenreService genreService;

    public GenreController(GenreService genreService) {
        this.genreService = genreService;
    }

    @GetMapping
    public ApiResponse<List<GenreResponse>> list() {
        return ApiResponse.ok(genreService.listAll());
    }
}
