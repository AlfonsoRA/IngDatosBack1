package com.patitasunidas.service;

import com.patitasunidas.dto.AnimalRequest;
import com.patitasunidas.dto.AnimalResponse;
import com.patitasunidas.model.Animal;
import com.patitasunidas.model.Refugio;
import com.patitasunidas.model.UbicacionAnimal;
import com.patitasunidas.repository.AdopcionRepository;
import com.patitasunidas.repository.AnimalRepository;
import com.patitasunidas.repository.UbicacionAnimalRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class AnimalService {

    private final AnimalRepository animalRepository;
    private final RefugioService refugioService;
    private final AdopcionRepository adopcionRepository;
    private final UbicacionAnimalRepository ubicacionAnimalRepository;

    public AnimalService(AnimalRepository animalRepository,
                         RefugioService refugioService,
                         AdopcionRepository adopcionRepository,
                         UbicacionAnimalRepository ubicacionAnimalRepository) {
        this.animalRepository = animalRepository;
        this.refugioService = refugioService;
        this.adopcionRepository = adopcionRepository;
        this.ubicacionAnimalRepository = ubicacionAnimalRepository;
    }

    @Transactional(readOnly = true)
    public List<AnimalResponse> listar(Long refugioId, String especie, String estadoDisponibilidad) {
        List<Animal> animales;
        if (refugioId != null) {
            animales = animalRepository.findByRefugioId(refugioId);
        } else if (especie != null && !especie.isBlank()) {
            animales = animalRepository.findByEspecieIgnoreCase(especie);
        } else {
            animales = animalRepository.findAll();
        }
        return animales.stream()
                .map(a -> AnimalResponse.from(a, adopcionRepository))
                .filter(r -> estadoDisponibilidad == null
                        || estadoDisponibilidad.isBlank()
                        || estadoDisponibilidad.equalsIgnoreCase(r.getEstadoDisponibilidad()))
                .toList();
    }

    @Transactional(readOnly = true)
    public AnimalResponse obtener(Long id) {
        return AnimalResponse.from(buscarAnimal(id), adopcionRepository);
    }

    public AnimalResponse crear(AnimalRequest request) {
        Refugio refugio = refugioService.buscar(request.getRefugioId());
        validarCapacidad(refugio);
        Animal animal = new Animal();
        aplicarDatos(animal, request, refugio);
        animal = animalRepository.save(animal);
        registrarUbicacionInicial(animal, refugio);
        return AnimalResponse.from(animal, adopcionRepository);
    }

    public AnimalResponse actualizar(Long id, AnimalRequest request) {
        Animal animal = buscarAnimal(id);
        Refugio refugio = refugioService.buscar(request.getRefugioId());
        if (!refugio.getId().equals(animal.getRefugio().getId())) {
            validarCapacidad(refugio);
        }
        aplicarDatos(animal, request, refugio);
        return AnimalResponse.from(animalRepository.save(animal), adopcionRepository);
    }

    public void eliminar(Long id) {
        if (!animalRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Animal no encontrado");
        }
        if (adopcionRepository.findByAnimalId(id).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "No se puede eliminar un animal con proceso de adopcion registrado");
        }
        animalRepository.deleteById(id);
    }

    private Animal buscarAnimal(Long id) {
        return animalRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Animal no encontrado"));
    }

    private void validarCapacidad(Refugio refugio) {
        long ocupacion = animalRepository.countByRefugioId(refugio.getId());
        if (ocupacion >= refugio.getCapacidad()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "El refugio alcanzo su capacidad maxima (" + refugio.getCapacidad() + ")");
        }
    }

    private void registrarUbicacionInicial(Animal animal, Refugio refugio) {
        UbicacionAnimal ua = new UbicacionAnimal();
        ua.setAnimal(animal);
        ua.setRefugio(refugio);
        ua.setFechaIngreso(animal.getFechaIngreso());
        ua.setMotivoTraslado("Ingreso inicial");
        ua.setEsActual(true);
        ubicacionAnimalRepository.save(ua);
    }

    private void aplicarDatos(Animal animal, AnimalRequest request, Refugio refugio) {
        animal.setNombre(request.getNombre());
        animal.setEspecie(request.getEspecie());
        animal.setRaza(request.getRaza());
        animal.setEdad(request.getEdad());
        animal.setFechaIngreso(request.getFechaIngreso());
        animal.setEsCastrado(request.getEsCastrado() != null ? request.getEsCastrado() : false);
        animal.setRefugio(refugio);
    }
}
