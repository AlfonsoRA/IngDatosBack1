package com.patitasunidas.service;

import com.patitasunidas.dto.DireccionMapper;
import com.patitasunidas.dto.RefugioRequest;
import com.patitasunidas.dto.RefugioResponse;
import com.patitasunidas.model.Refugio;
import com.patitasunidas.repository.AnimalRepository;
import com.patitasunidas.repository.DireccionRepository;
import com.patitasunidas.repository.RefugioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class RefugioService {

    private final RefugioRepository refugioRepository;
    private final DireccionRepository direccionRepository;
    private final AnimalRepository animalRepository;

    public RefugioService(RefugioRepository refugioRepository,
                          DireccionRepository direccionRepository,
                          AnimalRepository animalRepository) {
        this.refugioRepository = refugioRepository;
        this.direccionRepository = direccionRepository;
        this.animalRepository = animalRepository;
    }

    @Transactional(readOnly = true)
    public List<RefugioResponse> listar() {
        return refugioRepository.findAll().stream().map(RefugioResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public RefugioResponse obtener(Long id) {
        return RefugioResponse.from(buscar(id));
    }

    public RefugioResponse crear(RefugioRequest request) {
        Refugio refugio = new Refugio();
        refugio.setDireccion(direccionRepository.save(DireccionMapper.toEntity(request.direccionEfectiva())));
        aplicarDatos(refugio, request);
        return RefugioResponse.from(refugioRepository.save(refugio));
    }

    public RefugioResponse actualizar(Long id, RefugioRequest request) {
        Refugio refugio = buscar(id);
        if (request.getDireccion() != null || request.getDomicilio() != null) {
            var dto = request.direccionEfectiva();
            var dir = refugio.getDireccion();
            dir.setCalle(dto.getCalle());
            dir.setNumero(dto.getNumero());
            dir.setLocalidad(dto.getLocalidad() != null ? dto.getLocalidad() : dir.getLocalidad());
            dir.setPartido(dto.getPartido());
            dir.setCp(dto.getCp());
            direccionRepository.save(dir);
        }
        aplicarDatos(refugio, request);
        return RefugioResponse.from(refugioRepository.save(refugio));
    }

    public void eliminar(Long id) {
        if (!refugioRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Refugio no encontrado");
        }
        if (animalRepository.existsByRefugioId(id)) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "No se puede eliminar el refugio porque tiene animales registrados");
        }
        Refugio refugio = buscar(id);
        refugioRepository.delete(refugio);
        direccionRepository.delete(refugio.getDireccion());
    }

    Refugio buscar(Long id) {
        return refugioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Refugio no encontrado"));
    }

    private void aplicarDatos(Refugio refugio, RefugioRequest request) {
        refugio.setNombre(request.getNombre());
        String email = request.getEmail();
        refugio.setEmail(email != null && !email.isBlank() ? email.strip() : null);
        refugio.setTelefono(request.getTelefono());
        refugio.setCapacidad(request.getCapacidad());
        refugio.setResponsable(request.getResponsable());
    }
}
