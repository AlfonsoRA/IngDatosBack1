package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.Transito;
import com.patitasunidas.repository.AnimalRepository;
import com.patitasunidas.repository.TransitoRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class TransitoService {

    private final TransitoRepository repository;
    private final AnimalRepository animalRepository;
    private final HogarTransitoService hogarTransitoService;
    private final RefugioService refugioService;

    public TransitoService(TransitoRepository repository,
                           AnimalRepository animalRepository,
                           HogarTransitoService hogarTransitoService,
                           RefugioService refugioService) {
        this.repository = repository;
        this.animalRepository = animalRepository;
        this.hogarTransitoService = hogarTransitoService;
        this.refugioService = refugioService;
    }

    @Transactional(readOnly = true)
    public List<TransitoResponse> listar(String estado, Long animalId) {
        List<Transito> list;
        if (animalId != null) {
            list = repository.findByAnimalId(animalId);
        } else if (estado != null && !estado.isBlank()) {
            list = repository.findByEstadoActual(estado);
        } else {
            list = repository.findAll();
        }
        return list.stream().map(TransitoResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public TransitoResponse obtener(Long id) {
        return TransitoResponse.from(buscar(id));
    }

    public TransitoResponse crear(TransitoRequest req) {
        Transito t = new Transito();
        t.setAnimal(animalRepository.findById(req.getAnimalId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Animal no encontrado")));
        t.setHogarTransito(hogarTransitoService.buscar(req.getHogarTransitoId()));
        t.setRefugio(refugioService.buscar(req.getRefugioId()));
        aplicar(t, req);
        return TransitoResponse.from(repository.save(t));
    }

    public TransitoResponse actualizar(Long id, TransitoRequest req) {
        Transito t = buscar(id);
        t.setAnimal(animalRepository.findById(req.getAnimalId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Animal no encontrado")));
        t.setHogarTransito(hogarTransitoService.buscar(req.getHogarTransitoId()));
        t.setRefugio(refugioService.buscar(req.getRefugioId()));
        aplicar(t, req);
        return TransitoResponse.from(repository.save(t));
    }

    public void eliminar(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Transito no encontrado");
        }
        repository.deleteById(id);
    }

    private Transito buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Transito no encontrado"));
    }

    private void aplicar(Transito t, TransitoRequest req) {
        t.setFechaInicio(req.getFechaInicio());
        t.setFechaFinEstimada(req.getFechaFinEstimada());
        t.setFechaFinReal(req.getFechaFinReal());
        t.setEstadoActual(req.getEstadoActual());
        t.setObservaciones(req.getObservaciones());
    }
}
