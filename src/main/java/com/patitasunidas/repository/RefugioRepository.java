package com.patitasunidas.repository;

import com.patitasunidas.model.Refugio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RefugioRepository extends JpaRepository<Refugio, Long> {
}
