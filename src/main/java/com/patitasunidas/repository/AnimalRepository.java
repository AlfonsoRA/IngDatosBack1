package com.patitasunidas.repository;

import com.patitasunidas.model.Animal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnimalRepository extends JpaRepository<Animal, Long> {

    List<Animal> findByRefugioId(Long refugioId);

    List<Animal> findByEspecieIgnoreCase(String especie);

    boolean existsByRefugioId(Long refugioId);

    long countByRefugioId(Long refugioId);
}
