package com.patitasunidas.repository;

import com.patitasunidas.model.Adopcion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface AdopcionRepository extends JpaRepository<Adopcion, Long> {
    List<Adopcion> findByEstadoActual(String estado);
    boolean existsByAnimalIdAndEstadoActualIn(Long animalId, Collection<String> estados);
    boolean existsByAnimalId(Long animalId);
}
