package com.patitasunidas.service;

import com.patitasunidas.dto.*;
import com.patitasunidas.model.EtapaAdopcion;
import com.patitasunidas.repository.EtapaAdopcionRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@Transactional
public class EtapaAdopcionService {

    private final EtapaAdopcionRepository repository;
    private final AdopcionService adopcionService;
    private final RefugioService refugioService;

    public EtapaAdopcionService(EtapaAdopcionRepository repository,
                                AdopcionService adopcionService,
                                RefugioService refugioService) {
        this.repository = repository;
        this.adopcionService = adopcionService;
        this.refugioService = refugioService;
    }

    @Transactional(readOnly = true)
    public List<EtapaAdopcionResponse> listar(Long adopcionId) {
        List<EtapaAdopcion> list = adopcionId != null
                ? repository.findByAdopcionIdOrderByFechaInicioAsc(adopcionId)
                : repository.findAll();
        return list.stream().map(EtapaAdopcionResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public EtapaAdopcionResponse obtener(Long id) {
        return EtapaAdopcionResponse.from(buscar(id));
    }

    public EtapaAdopcionResponse crear(EtapaAdopcionRequest req) {
        EtapaAdopcion e = new EtapaAdopcion();
        e.setAdopcion(adopcionService.buscar(req.getAdopcionId()));
        e.setRefugio(refugioService.buscar(req.getRefugioId()));
        aplicar(e, req);
        return EtapaAdopcionResponse.from(repository.save(e));
    }

    public EtapaAdopcionResponse actualizar(Long id, EtapaAdopcionRequest req) {
        EtapaAdopcion e = buscar(id);
        e.setAdopcion(adopcionService.buscar(req.getAdopcionId()));
        e.setRefugio(refugioService.buscar(req.getRefugioId()));
        aplicar(e, req);
        return EtapaAdopcionResponse.from(repository.save(e));
    }

    public void eliminar(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Etapa de adopcion no encontrada");
        }
        repository.deleteById(id);
    }

    private EtapaAdopcion buscar(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Etapa de adopcion no encontrada"));
    }

    private void aplicar(EtapaAdopcion e, EtapaAdopcionRequest req) {
        e.setFechaInicio(req.getFechaInicio());
        e.setFechaFin(req.getFechaFin());
        e.setObservaciones(req.getObservaciones());
    }
}
