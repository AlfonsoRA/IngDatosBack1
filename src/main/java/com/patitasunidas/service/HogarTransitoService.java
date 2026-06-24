package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.HogarTransito;
import com.patitasunidas.repository.HogarTransitoRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class HogarTransitoService {

    private final HogarTransitoRepository repository;
    private final DireccionService direccionService;

    public HogarTransitoService(HogarTransitoRepository repository, DireccionService direccionService) {
        this.repository = repository;
        this.direccionService = direccionService;
    }

    @Transactional(readOnly = true)
    public List<HogarTransitoResponse> listar() {
        return repository.findAll().stream().map(this::toResponse).toList();
    }

    @Transactional(readOnly = true)
    public HogarTransitoResponse obtener(Long id) {
        return toResponse(buscar(id));
    }

    public HogarTransitoResponse crear(HogarTransitoRequest req) {
        if (repository.existsByDni(req.getDni())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya existe un hogar de transito con ese DNI");
        }
        HogarTransito h = new HogarTransito();
        h.setDireccion(direccionService.guardar(req.getDireccion()));
        aplicar(h, req);
        return toResponse(repository.save(h));
    }

    public HogarTransitoResponse actualizar(Long id, HogarTransitoRequest req) {
        HogarTransito h = buscar(id);
        if (req.getDireccion() != null) {
            direccionService.actualizar(h.getDireccion(), req.getDireccion());
        }
        aplicar(h, req);
        return toResponse(repository.save(h));
    }

    public void eliminar(Long id) {
        HogarTransito h = buscar(id);
        repository.delete(h);
        direccionService.eliminar(h.getDireccion());
    }

    HogarTransito buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Hogar de transito no encontrado"));
    }

    private HogarTransitoResponse toResponse(HogarTransito h) {
        HogarTransitoResponse r = HogarTransitoResponse.from(h);
        r.setDireccion(direccionService.toDto(h.getDireccion()));
        return r;
    }

    private void aplicar(HogarTransito h, HogarTransitoRequest req) {
        h.setDni(req.getDni());
        h.setNombre(req.getNombre());
        h.setApellido(req.getApellido());
        h.setEmail(req.getEmail());
        h.setTelefono(req.getTelefono());
        h.setCapacidadAceptada(req.getCapacidadMaxima());
        h.setAceptaGatos(Boolean.TRUE.equals(req.getTieneGatos()));
        h.setAceptaPerros(Boolean.TRUE.equals(req.getTienePerros()));
    }
}
