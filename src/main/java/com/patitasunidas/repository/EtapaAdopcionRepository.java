package com.patitasunidas.repository;

import com.patitasunidas.model.EtapaAdopcion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EtapaAdopcionRepository extends JpaRepository<EtapaAdopcion, Long> {
    List<EtapaAdopcion> findByAdopcionIdOrderByFechaInicioAsc(Long adopcionId);
}
