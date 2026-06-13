package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.HogarTransito;
import com.patitasunidas.repository.DireccionRepository;
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
    private final DireccionRepository direccionRepository;

    public HogarTransitoService(HogarTransitoRepository repository, DireccionRepository direccionRepository) {
        this.repository = repository;
        this.direccionRepository = direccionRepository;
    }

    @Transactional(readOnly = true)
    public List<HogarTransitoResponse> listar() {
        return repository.findAll().stream().map(HogarTransitoResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public HogarTransitoResponse obtener(Long id) {
        return HogarTransitoResponse.from(buscar(id));
    }

    public HogarTransitoResponse crear(HogarTransitoRequest req) {
        if (repository.existsByDni(req.getDni())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya existe un hogar de transito con ese DNI");
        }
        HogarTransito h = new HogarTransito();
        h.setDireccion(direccionRepository.save(DireccionMapper.toEntity(req.getDireccion())));
        aplicar(h, req);
        return HogarTransitoResponse.from(repository.save(h));
    }

    public HogarTransitoResponse actualizar(Long id, HogarTransitoRequest req) {
        HogarTransito h = buscar(id);
        if (req.getDireccion() != null) {
            var dir = h.getDireccion();
            var dto = req.getDireccion();
            dir.setCalle(dto.getCalle());
            dir.setNumero(dto.getNumero());
            dir.setLocalidad(dto.getLocalidad());
            dir.setPartido(dto.getPartido());
            dir.setCp(dto.getCp());
            direccionRepository.save(dir);
        }
        aplicar(h, req);
        return HogarTransitoResponse.from(repository.save(h));
    }

    public void eliminar(Long id) {
        HogarTransito h = buscar(id);
        repository.delete(h);
        direccionRepository.delete(h.getDireccion());
    }

    HogarTransito buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Hogar de transito no encontrado"));
    }

    private void aplicar(HogarTransito h, HogarTransitoRequest req) {
        h.setDni(req.getDni());
        h.setNombre(req.getNombre());
        h.setApellido(req.getApellido());
        h.setEmail(req.getEmail());
        h.setTelefono(req.getTelefono());
        h.setCapacidadMaxima(req.getCapacidadMaxima());
        h.setTieneGatos(Boolean.TRUE.equals(req.getTieneGatos()));
        h.setTienePerros(Boolean.TRUE.equals(req.getTienePerros()));
    }
}
