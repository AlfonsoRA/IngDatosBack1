package com.patitasunidas.repository;

import com.patitasunidas.model.Animal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnimalRepository extends JpaRepository<Animal, Long> {

    @Query("""
        SELECT a FROM Animal a
        WHERE EXISTS (
            SELECT 1 FROM UbicacionAnimal ua
            WHERE ua.animal = a AND ua.esActual = true AND ua.refugio.id = :refugioId
        )
        """)
    List<Animal> findByRefugioId(@Param("refugioId") Long refugioId);

    List<Animal> findByEspecieIgnoreCase(String especie);

    @Query("""
        SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM Animal a
        WHERE EXISTS (
            SELECT 1 FROM UbicacionAnimal ua
            WHERE ua.animal = a AND ua.esActual = true AND ua.refugio.id = :refugioId
        )
        """)
    boolean existsByRefugioId(@Param("refugioId") Long refugioId);

    @Query("""
        SELECT COUNT(a) FROM Animal a
        WHERE EXISTS (
            SELECT 1 FROM UbicacionAnimal ua
            WHERE ua.animal = a AND ua.esActual = true AND ua.refugio.id = :refugioId
        ) AND (a.estado IS NULL OR a.estado <> 'Adoptado')
        """)
    long countByRefugioId(@Param("refugioId") Long refugioId);
}
