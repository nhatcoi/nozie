package space.nhatcoi.nozie.service.impl;

import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.response.GenreResponse;
import space.nhatcoi.nozie.entity.Genre;
import space.nhatcoi.nozie.entity.UserFavoriteGenre;
import space.nhatcoi.nozie.mapper.GenreMapper;
import space.nhatcoi.nozie.repository.GenreRepository;
import space.nhatcoi.nozie.repository.UserFavoriteGenreRepository;
import space.nhatcoi.nozie.service.FavoriteGenreService;

@Service
@Transactional
public class FavoriteGenreServiceImpl implements FavoriteGenreService {

    private final UserFavoriteGenreRepository repository;
    private final GenreRepository genreRepository;
    private final GenreMapper genreMapper;

    public FavoriteGenreServiceImpl(UserFavoriteGenreRepository repository, GenreRepository genreRepository, GenreMapper genreMapper) {
        this.repository = repository;
        this.genreRepository = genreRepository;
        this.genreMapper = genreMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<GenreResponse> list(UUID userId) {
        Set<Short> ids = Set.copyOf(repository.findGenreIds(userId));
        return genreRepository.findAllByOrderByNameAsc().stream().filter(g -> ids.contains(g.getId())).map(genreMapper::toResponse).toList();
    }

    @Override
    public List<GenreResponse> replace(UUID userId, List<String> requested) {
        Set<String> keys = requested.stream().filter(s -> s != null && !s.isBlank())
                .map(s -> s.trim().toLowerCase(Locale.ROOT)).collect(Collectors.toSet());
        List<Genre> matched = genreRepository.findAll().stream()
                .filter(g -> keys.contains(g.getSlug().toLowerCase(Locale.ROOT)) || keys.contains(g.getName().toLowerCase(Locale.ROOT)))
                .toList();
        repository.deleteAllForUser(userId);
        matched.forEach(g -> repository.save(new UserFavoriteGenre(userId, g.getId())));
        return matched.stream().sorted(java.util.Comparator.comparing(Genre::getName)).map(genreMapper::toResponse).toList();
    }
}
