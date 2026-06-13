package com.patitasunidas.repository;

import com.patitasunidas.model.Adoptante;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdoptanteRepository extends JpaRepository<Adoptante, Long> {
    boolean existsByDni(String dni);
}
