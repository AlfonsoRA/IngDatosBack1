package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.Adopcion;
import com.patitasunidas.model.Animal;
import com.patitasunidas.repository.AdopcionRepository;
import com.patitasunidas.repository.AnimalRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class AdopcionService {

    private static final List<String> ESTADOS_ACTIVOS = List.of("Solicitada", "En proceso", "Aprobada");

    private final AdopcionRepository repository;
    private final AnimalRepository animalRepository;
    private final AdoptanteService adoptanteService;

    public AdopcionService(AdopcionRepository repository,
                           AnimalRepository animalRepository,
                           AdoptanteService adoptanteService) {
        this.repository = repository;
        this.animalRepository = animalRepository;
        this.adoptanteService = adoptanteService;
    }

    @Transactional(readOnly = true)
    public List<AdopcionResponse> listar(String estado) {
        List<Adopcion> list = estado != null && !estado.isBlank()
                ? repository.findByEstadoActual(estado)
                : repository.findAll();
        return list.stream().map(AdopcionResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public AdopcionResponse obtener(Long id) {
        return AdopcionResponse.from(buscar(id));
    }

    public AdopcionResponse crear(AdopcionRequest req) {
        Animal animal = animalRepository.findById(req.getAnimalId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Animal no encontrado"));
        validarNuevaAdopcion(animal);
        Adopcion a = new Adopcion();
        a.setAnimal(animal);
        a.setAdoptante(adoptanteService.buscar(req.getAdoptanteId()));
        a.setFechaSolicitud(req.getFechaSolicitud());
        a.setEstadoActual(req.getEstadoActual());
        return AdopcionResponse.from(repository.save(a));
    }

    public AdopcionResponse actualizar(Long id, AdopcionRequest req) {
        Adopcion a = buscar(id);
        if (!a.getAnimal().getId().equals(req.getAnimalId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No se puede cambiar el animal de una adopcion");
        }
        a.setAdoptante(adoptanteService.buscar(req.getAdoptanteId()));
        a.setFechaSolicitud(req.getFechaSolicitud());
        a.setEstadoActual(req.getEstadoActual());
        return AdopcionResponse.from(repository.save(a));
    }

    public void eliminar(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Adopcion no encontrada");
        }
        repository.deleteById(id);
    }

    Adopcion buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Adopcion no encontrada"));
    }

    private void validarNuevaAdopcion(Animal animal) {
        if ("Adoptado".equals(animal.getEstado())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "No se puede iniciar una adopcion: el animal ya figura como Adoptado");
        }
        if (repository.existsByAnimalIdAndEstadoActualIn(animal.getId(), ESTADOS_ACTIVOS)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "El animal ya tiene un proceso de adopcion activo");
        }
    }
}
