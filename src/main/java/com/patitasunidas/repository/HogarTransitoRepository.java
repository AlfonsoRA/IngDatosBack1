package com.patitasunidas.repository;

import com.patitasunidas.model.HogarTransito;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HogarTransitoRepository extends JpaRepository<HogarTransito, Long> {
    boolean existsByDni(String dni);
}
