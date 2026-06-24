package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.Adoptante;
import com.patitasunidas.repository.AdoptanteRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class AdoptanteService {

    private final AdoptanteRepository repository;
    private final DireccionService direccionService;

    public AdoptanteService(AdoptanteRepository repository, DireccionService direccionService) {
        this.repository = repository;
        this.direccionService = direccionService;
    }

    @Transactional(readOnly = true)
    public List<AdoptanteResponse> listar() {
        return repository.findAll().stream().map(this::toResponse).toList();
    }

    @Transactional(readOnly = true)
    public AdoptanteResponse obtener(Long id) {
        return toResponse(buscar(id));
    }

    public AdoptanteResponse crear(AdoptanteRequest req) {
        if (repository.existsByDni(req.getDni())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya existe un adoptante con ese DNI");
        }
        Adoptante a = new Adoptante();
        a.setDireccion(direccionService.guardar(req.getDireccion()));
        aplicar(a, req);
        return toResponse(repository.save(a));
    }

    public AdoptanteResponse actualizar(Long id, AdoptanteRequest req) {
        Adoptante a = buscar(id);
        if (req.getDireccion() != null) {
            direccionService.actualizar(a.getDireccion(), req.getDireccion());
        }
        aplicar(a, req);
        return toResponse(repository.save(a));
    }

    public void eliminar(Long id) {
        Adoptante a = buscar(id);
        repository.delete(a);
        direccionService.eliminar(a.getDireccion());
    }

    Adoptante buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Adoptante no encontrado"));
    }

    private AdoptanteResponse toResponse(Adoptante a) {
        AdoptanteResponse r = AdoptanteResponse.from(a);
        r.setDireccion(direccionService.toDto(a.getDireccion()));
        return r;
    }

    private void aplicar(Adoptante a, AdoptanteRequest req) {
        a.setDni(req.getDni());
        a.setNombre(req.getNombre());
        a.setApellido(req.getApellido());
        a.setEmail(req.getEmail());
        a.setTelefono(req.getTelefono());
        a.setAdoptantePrevio(Boolean.TRUE.equals(req.getAdoptantePrevio()));
    }
}
