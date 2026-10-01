package space.nhatcoi.nozie.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.response.GenreResponse;
import space.nhatcoi.nozie.mapper.GenreMapper;
import space.nhatcoi.nozie.repository.GenreRepository;
import space.nhatcoi.nozie.service.GenreService;

@Service
@Transactional(readOnly = true)
public class GenreServiceImpl implements GenreService {

    private final GenreRepository genreRepository;
    private final GenreMapper genreMapper;

    public GenreServiceImpl(GenreRepository genreRepository, GenreMapper genreMapper) {
        this.genreRepository = genreRepository;
        this.genreMapper = genreMapper;
    }

    @Override
    public List<GenreResponse> listAll() {
        return genreRepository.findAllByOrderByNameAsc().stream().map(genreMapper::toResponse).toList();
    }
}
