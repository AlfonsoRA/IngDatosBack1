package com.patitasunidas.service;

import com.patitasunidas.dto.UbicacionAnimalResponse;
import com.patitasunidas.repository.UbicacionAnimalRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional(readOnly = true)
public class UbicacionAnimalService {

    private final UbicacionAnimalRepository repository;

    public UbicacionAnimalService(UbicacionAnimalRepository repository) {
        this.repository = repository;
    }

    public List<UbicacionAnimalResponse> listar(Long animalId) {
        var list = animalId != null
                ? repository.findByAnimalIdOrderByFechaIngresoDesc(animalId)
                : repository.findAll();
        return list.stream().map(UbicacionAnimalResponse::from).toList();
    }

    public UbicacionAnimalResponse obtener(Long id) {
        return UbicacionAnimalResponse.from(repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Ubicacion no encontrada")));
    }
}
