package com.patitasunidas.dto;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public class EtapaAdopcionRequest {
    @NotNull private Long adopcionId;
    @NotNull private Long refugioId;
    @NotNull private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String observaciones;

    public Long getAdopcionId() { return adopcionId; }
    public void setAdopcionId(Long adopcionId) { this.adopcionId = adopcionId; }
    public Long getRefugioId() { return refugioId; }
    public void setRefugioId(Long refugioId) { this.refugioId = refugioId; }
    public LocalDate getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDate fechaInicio) { this.fechaInicio = fechaInicio; }
    public LocalDate getFechaFin() { return fechaFin; }
    public void setFechaFin(LocalDate fechaFin) { this.fechaFin = fechaFin; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}
