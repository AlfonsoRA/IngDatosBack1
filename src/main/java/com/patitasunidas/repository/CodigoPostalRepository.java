package com.patitasunidas.repository;

import com.patitasunidas.model.CodigoPostal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CodigoPostalRepository extends JpaRepository<CodigoPostal, Long> {
    List<CodigoPostal> findByDireccionId(Long direccionId);
    Optional<CodigoPostal> findFirstByDireccionId(Long direccionId);
}
