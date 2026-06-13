package com.patitasunidas.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public class TransitoRequest {
    @NotNull private Long animalId;
    @NotNull private Long hogarTransitoId;
    @NotNull private Long refugioId;
    @NotNull private LocalDate fechaInicio;
    private LocalDate fechaFinEstimada;
    private LocalDate fechaFinReal;
    @NotBlank private String estadoActual;
    private String observaciones;

    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }
    public Long getHogarTransitoId() { return hogarTransitoId; }
    public void setHogarTransitoId(Long hogarTransitoId) { this.hogarTransitoId = hogarTransitoId; }
    public Long getRefugioId() { return refugioId; }
    public void setRefugioId(Long refugioId) { this.refugioId = refugioId; }
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
