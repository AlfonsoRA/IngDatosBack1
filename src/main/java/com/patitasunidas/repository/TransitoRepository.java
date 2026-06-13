package com.patitasunidas.repository;

import com.patitasunidas.model.Transito;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransitoRepository extends JpaRepository<Transito, Long> {
    List<Transito> findByEstadoActual(String estado);
    List<Transito> findByAnimalId(Long animalId);
}
