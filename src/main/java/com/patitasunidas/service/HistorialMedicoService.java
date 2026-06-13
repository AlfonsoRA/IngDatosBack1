package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.*;
import com.patitasunidas.repository.*;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class HistorialMedicoService {

    private final HistorialMedicoRepository repository;
    private final AnimalRepository animalRepository;

    public HistorialMedicoService(HistorialMedicoRepository repository, AnimalRepository animalRepository) {
        this.repository = repository;
        this.animalRepository = animalRepository;
    }

    @Transactional(readOnly = true)
    public List<HistorialMedicoResponse> listar(Long animalId) {
        List<HistorialMedico> list = animalId != null
                ? repository.findByAnimalIdOrderByFechaDesc(animalId)
                : repository.findAll();
        return list.stream().map(HistorialMedicoResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public HistorialMedicoResponse obtener(Long id) {
        return HistorialMedicoResponse.from(buscar(id));
    }

    public HistorialMedicoResponse crear(HistorialMedicoRequest req) {
        HistorialMedico h = new HistorialMedico();
        h.setAnimal(buscarAnimal(req.getAnimalId()));
        aplicar(h, req);
        return HistorialMedicoResponse.from(repository.save(h));
    }

    public HistorialMedicoResponse actualizar(Long id, HistorialMedicoRequest req) {
        HistorialMedico h = buscar(id);
        if (!h.getAnimal().getId().equals(req.getAnimalId())) {
            h.setAnimal(buscarAnimal(req.getAnimalId()));
        }
        aplicar(h, req);
        return HistorialMedicoResponse.from(repository.save(h));
    }

    public void eliminar(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Historial medico no encontrado");
        }
        repository.deleteById(id);
    }

    private HistorialMedico buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Historial medico no encontrado"));
    }

    private Animal buscarAnimal(Long id) {
        return animalRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Animal no encontrado"));
    }

    private void aplicar(HistorialMedico h, HistorialMedicoRequest req) {
        h.setNombreVeterinaria(req.getNombreVeterinaria());
        h.setObservacion(req.getObservacion());
        h.setMedicamento(req.getMedicamento());
        h.setDiagnostico(req.getDiagnostico());
        h.setTipoIntervencion(req.getTipoIntervencion());
        h.setFecha(req.getFecha());
        h.setAntirrabicaAnual(Boolean.TRUE.equals(req.getAntirrabicaAnual()));
        h.setSextupleAnual(Boolean.TRUE.equals(req.getSextupleAnual()));
        h.setTripleAnual(Boolean.TRUE.equals(req.getTripleAnual()));
    }
}
