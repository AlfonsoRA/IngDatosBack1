package com.patitasunidas.controller;

import com.patitasunidas.dto.AnimalRequest;
import com.patitasunidas.dto.AnimalResponse;
import com.patitasunidas.service.AnimalService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/animales")
public class AnimalController {

    private final AnimalService animalService;

    public AnimalController(AnimalService animalService) {
        this.animalService = animalService;
    }

    @GetMapping
    public List<AnimalResponse> listar(
            @RequestParam(required = false) Long refugioId,
            @RequestParam(required = false) String especie,
            @RequestParam(required = false) String estadoDisponibilidad) {
        return animalService.listar(refugioId, especie, estadoDisponibilidad);
    }

    @GetMapping("/{id}")
    public AnimalResponse obtener(@PathVariable Long id) {
        return animalService.obtener(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public AnimalResponse crear(@Valid @RequestBody AnimalRequest request) {
        return animalService.crear(request);
    }

    @PutMapping("/{id}")
    public AnimalResponse actualizar(@PathVariable Long id, @Valid @RequestBody AnimalRequest request) {
        return animalService.actualizar(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) {
        animalService.eliminar(id);
    }
}
