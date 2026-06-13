package com.patitasunidas.repository;

import com.patitasunidas.model.HistorialMedico;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HistorialMedicoRepository extends JpaRepository<HistorialMedico, Long> {
    List<HistorialMedico> findByAnimalIdOrderByFechaDesc(Long animalId);
}
