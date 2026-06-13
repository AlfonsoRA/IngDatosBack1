package com.patitasunidas.repository;

import com.patitasunidas.model.UbicacionAnimal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UbicacionAnimalRepository extends JpaRepository<UbicacionAnimal, Long> {
    List<UbicacionAnimal> findByAnimalIdOrderByFechaIngresoDesc(Long animalId);
}
