package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.Adoptante;
import com.patitasunidas.repository.AdoptanteRepository;
import com.patitasunidas.repository.DireccionRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class AdoptanteService {

    private final AdoptanteRepository repository;
    private final DireccionRepository direccionRepository;

    public AdoptanteService(AdoptanteRepository repository, DireccionRepository direccionRepository) {
        this.repository = repository;
        this.direccionRepository = direccionRepository;
    }

    @Transactional(readOnly = true)
    public List<AdoptanteResponse> listar() {
        return repository.findAll().stream().map(AdoptanteResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public AdoptanteResponse obtener(Long id) {
        return AdoptanteResponse.from(buscar(id));
    }

    public AdoptanteResponse crear(AdoptanteRequest req) {
        if (repository.existsByDni(req.getDni())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya existe un adoptante con ese DNI");
        }
        Adoptante a = new Adoptante();
        a.setDireccion(direccionRepository.save(DireccionMapper.toEntity(req.getDireccion())));
        aplicar(a, req);
        return AdoptanteResponse.from(repository.save(a));
    }

    public AdoptanteResponse actualizar(Long id, AdoptanteRequest req) {
        Adoptante a = buscar(id);
        if (req.getDireccion() != null) {
            var dir = a.getDireccion();
            var dto = req.getDireccion();
            dir.setCalle(dto.getCalle());
            dir.setNumero(dto.getNumero());
            dir.setLocalidad(dto.getLocalidad());
            dir.setPartido(dto.getPartido());
            dir.setCp(dto.getCp());
            direccionRepository.save(dir);
        }
        aplicar(a, req);
        return AdoptanteResponse.from(repository.save(a));
    }

    public void eliminar(Long id) {
        Adoptante a = buscar(id);
        repository.delete(a);
        direccionRepository.delete(a.getDireccion());
    }

    Adoptante buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Adoptante no encontrado"));
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
