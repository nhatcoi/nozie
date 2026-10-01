package space.nhatcoi.nozie.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import space.nhatcoi.nozie.entity.Genre;

public interface GenreRepository extends JpaRepository<Genre, Short> {

    List<Genre> findAllByOrderByNameAsc();

    List<Genre> findBySlugIn(java.util.Collection<String> slugs);
}
