package com.patitasunidas.controller;

import com.patitasunidas.dto.*;
import com.patitasunidas.service.*;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/historial-medico")
class HistorialMedicoController {

    private final HistorialMedicoService service;

    public HistorialMedicoController(HistorialMedicoService service) { this.service = service; }

    @GetMapping
    public List<HistorialMedicoResponse> listar(@RequestParam(required = false) Long animalId) {
        return service.listar(animalId);
    }

    @GetMapping("/{id}")
    public HistorialMedicoResponse obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public HistorialMedicoResponse crear(@Valid @RequestBody HistorialMedicoRequest req) { return service.crear(req); }

    @PutMapping("/{id}")
    public HistorialMedicoResponse actualizar(@PathVariable Long id, @Valid @RequestBody HistorialMedicoRequest req) {
        return service.actualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) { service.eliminar(id); }
}

@RestController
@RequestMapping("/api/ubicaciones-animal")
class UbicacionAnimalController {

    private final UbicacionAnimalService service;

    UbicacionAnimalController(UbicacionAnimalService service) { this.service = service; }

    @GetMapping
    public List<UbicacionAnimalResponse> listar(@RequestParam(required = false) Long animalId) {
        return service.listar(animalId);
    }

    @GetMapping("/{id}")
    public UbicacionAnimalResponse obtener(@PathVariable Long id) { return service.obtener(id); }
}

@RestController
@RequestMapping("/api/adoptantes")
class AdoptanteController {

    private final AdoptanteService service;

    AdoptanteController(AdoptanteService service) { this.service = service; }

    @GetMapping
    public List<AdoptanteResponse> listar() { return service.listar(); }

    @GetMapping("/{id}")
    public AdoptanteResponse obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public AdoptanteResponse crear(@Valid @RequestBody AdoptanteRequest req) { return service.crear(req); }

    @PutMapping("/{id}")
    public AdoptanteResponse actualizar(@PathVariable Long id, @Valid @RequestBody AdoptanteRequest req) {
        return service.actualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) { service.eliminar(id); }
}

@RestController
@RequestMapping("/api/hogares-transito")
class HogarTransitoController {

    private final HogarTransitoService service;

    HogarTransitoController(HogarTransitoService service) { this.service = service; }

    @GetMapping
    public List<HogarTransitoResponse> listar() { return service.listar(); }

    @GetMapping("/{id}")
    public HogarTransitoResponse obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public HogarTransitoResponse crear(@Valid @RequestBody HogarTransitoRequest req) { return service.crear(req); }

    @PutMapping("/{id}")
    public HogarTransitoResponse actualizar(@PathVariable Long id, @Valid @RequestBody HogarTransitoRequest req) {
        return service.actualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) { service.eliminar(id); }
}

@RestController
@RequestMapping("/api/adopciones")
class AdopcionController {

    private final AdopcionService service;

    AdopcionController(AdopcionService service) { this.service = service; }

    @GetMapping
    public List<AdopcionResponse> listar(@RequestParam(required = false) String estado) { return service.listar(estado); }

    @GetMapping("/{id}")
    public AdopcionResponse obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public AdopcionResponse crear(@Valid @RequestBody AdopcionRequest req) { return service.crear(req); }

    @PutMapping("/{id}")
    public AdopcionResponse actualizar(@PathVariable Long id, @Valid @RequestBody AdopcionRequest req) {
        return service.actualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) { service.eliminar(id); }
}

@RestController
@RequestMapping("/api/etapas-adopcion")
class EtapaAdopcionController {

    private final EtapaAdopcionService service;

    EtapaAdopcionController(EtapaAdopcionService service) { this.service = service; }

    @GetMapping
    public List<EtapaAdopcionResponse> listar(@RequestParam(required = false) Long adopcionId) {
        return service.listar(adopcionId);
    }

    @GetMapping("/{id}")
    public EtapaAdopcionResponse obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public EtapaAdopcionResponse crear(@Valid @RequestBody EtapaAdopcionRequest req) { return service.crear(req); }

    @PutMapping("/{id}")
    public EtapaAdopcionResponse actualizar(@PathVariable Long id, @Valid @RequestBody EtapaAdopcionRequest req) {
        return service.actualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) { service.eliminar(id); }
}

@RestController
@RequestMapping("/api/transitos")
class TransitoController {

    private final TransitoService service;

    TransitoController(TransitoService service) { this.service = service; }

    @GetMapping
    public List<TransitoResponse> listar(
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long animalId) {
        return service.listar(estado, animalId);
    }

    @GetMapping("/{id}")
    public TransitoResponse obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TransitoResponse crear(@Valid @RequestBody TransitoRequest req) { return service.crear(req); }

    @PutMapping("/{id}")
    public TransitoResponse actualizar(@PathVariable Long id, @Valid @RequestBody TransitoRequest req) {
        return service.actualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) { service.eliminar(id); }
}

@RestController
@RequestMapping("/api/reportes")
class ReporteController {

    private final ReporteService service;

    ReporteController(ReporteService service) { this.service = service; }

    @GetMapping("/animales-disponibles")
    public List<Map<String, Object>> animalesDisponibles() { return service.animalesDisponibles(); }

    @GetMapping("/refugios-ocupacion")
    public List<Map<String, Object>> refugiosOcupacion() { return service.refugiosOcupacion(); }

    @GetMapping("/adopciones-detalle")
    public List<Map<String, Object>> adopcionesDetalle() { return service.adopcionesDetalle(); }

    @GetMapping("/transitos-activos")
    public List<Map<String, Object>> transitosActivos() { return service.transitosActivos(); }

    @GetMapping("/adopciones-por-mes")
    public List<Map<String, Object>> adopcionesPorMes() { return service.adopcionesPorMes(); }

    @GetMapping("/traslados-refugios")
    public List<Map<String, Object>> trasladosRefugios() { return service.trasladosRefugios(); }
}
