package com.patitasunidas.controller;

import com.patitasunidas.dto.RefugioRequest;
import com.patitasunidas.dto.RefugioResponse;
import com.patitasunidas.service.RefugioService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/refugios")
public class RefugioController {

    private final RefugioService refugioService;

    public RefugioController(RefugioService refugioService) {
        this.refugioService = refugioService;
    }

    @GetMapping
    public List<RefugioResponse> listar() {
        return refugioService.listar();
    }

    @GetMapping("/{id}")
    public RefugioResponse obtener(@PathVariable Long id) {
        return refugioService.obtener(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public RefugioResponse crear(@Valid @RequestBody RefugioRequest request) {
        return refugioService.crear(request);
    }

    @PutMapping("/{id}")
    public RefugioResponse actualizar(@PathVariable Long id, @Valid @RequestBody RefugioRequest request) {
        return refugioService.actualizar(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void eliminar(@PathVariable Long id) {
        refugioService.eliminar(id);
    }
}
