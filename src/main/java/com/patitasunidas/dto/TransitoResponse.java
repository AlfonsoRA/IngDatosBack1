package com.patitasunidas.dto;

import com.patitasunidas.model.Transito;

import java.time.LocalDate;

public class TransitoResponse {
    private Long id;
    private Long animalId;
    private String animalNombre;
    private Long hogarTransitoId;
    private String hogarTransitoNombre;
    private Long refugioId;
    private String refugioNombre;
    private LocalDate fechaInicio;
    private LocalDate fechaFinEstimada;
    private LocalDate fechaFinReal;
    private String estadoActual;
    private String observaciones;

    public static TransitoResponse from(Transito t) {
        TransitoResponse r = new TransitoResponse();
        r.setId(t.getId());
        r.setAnimalId(t.getAnimal().getId());
        r.setAnimalNombre(t.getAnimal().getNombre());
        r.setHogarTransitoId(t.getHogarTransito().getId());
        r.setHogarTransitoNombre(t.getHogarTransito().getNombre() + " " + t.getHogarTransito().getApellido());
        r.setRefugioId(t.getRefugio().getId());
        r.setRefugioNombre(t.getRefugio().getNombre());
        r.setFechaInicio(t.getFechaInicio());
        r.setFechaFinEstimada(t.getFechaFinEstimada());
        r.setFechaFinReal(t.getFechaFinReal());
        r.setEstadoActual(t.getEstadoActual());
        r.setObservaciones(t.getObservaciones());
        return r;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }
    public String getAnimalNombre() { return animalNombre; }
    public void setAnimalNombre(String animalNombre) { this.animalNombre = animalNombre; }
    public Long getHogarTransitoId() { return hogarTransitoId; }
    public void setHogarTransitoId(Long hogarTransitoId) { this.hogarTransitoId = hogarTransitoId; }
    public String getHogarTransitoNombre() { return hogarTransitoNombre; }
    public void setHogarTransitoNombre(String hogarTransitoNombre) { this.hogarTransitoNombre = hogarTransitoNombre; }
    public Long getRefugioId() { return refugioId; }
    public void setRefugioId(Long refugioId) { this.refugioId = refugioId; }
    public String getRefugioNombre() { return refugioNombre; }
    public void setRefugioNombre(String refugioNombre) { this.refugioNombre = refugioNombre; }
    public LocalDate getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDate fechaInicio) { this.fechaInicio = fechaInicio; }
    public LocalDate getFechaFinEstimada() { return fechaFinEstimada; }
    public void setFechaFinEstimada(LocalDate fechaFinEstimada) { this.fechaFinEstimada = fechaFinEstimada; }
    public LocalDate getFechaFinReal() { return fechaFinReal; }
    public void setFechaFinReal(LocalDate fechaFinReal) { this.fechaFinReal = fechaFinReal; }
    public String getEstadoActual() { return estadoActual; }
    public void setEstadoActual(String estadoActual) { this.estadoActual = estadoActual; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}
