package com.patitasunidas.repository;

import com.patitasunidas.model.Adopcion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AdopcionRepository extends JpaRepository<Adopcion, Long> {
    Optional<Adopcion> findByAnimalId(Long animalId);
    List<Adopcion> findByEstadoActual(String estado);
}
