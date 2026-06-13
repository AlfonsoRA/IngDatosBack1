package com.patitasunidas.dto;

import com.patitasunidas.model.EtapaAdopcion;

import java.time.LocalDate;

public class EtapaAdopcionResponse {
    private Long id;
    private Long adopcionId;
    private Long refugioId;
    private String refugioNombre;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String observaciones;

    public static EtapaAdopcionResponse from(EtapaAdopcion e) {
        EtapaAdopcionResponse r = new EtapaAdopcionResponse();
        r.setId(e.getId());
        r.setAdopcionId(e.getAdopcion().getId());
        r.setRefugioId(e.getRefugio().getId());
        r.setRefugioNombre(e.getRefugio().getNombre());
        r.setFechaInicio(e.getFechaInicio());
        r.setFechaFin(e.getFechaFin());
        r.setObservaciones(e.getObservaciones());
        return r;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getAdopcionId() { return adopcionId; }
    public void setAdopcionId(Long adopcionId) { this.adopcionId = adopcionId; }
    public Long getRefugioId() { return refugioId; }
    public void setRefugioId(Long refugioId) { this.refugioId = refugioId; }
    public String getRefugioNombre() { return refugioNombre; }
    public void setRefugioNombre(String refugioNombre) { this.refugioNombre = refugioNombre; }
    public LocalDate getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDate fechaInicio) { this.fechaInicio = fechaInicio; }
    public LocalDate getFechaFin() { return fechaFin; }
    public void setFechaFin(LocalDate fechaFin) { this.fechaFin = fechaFin; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}
