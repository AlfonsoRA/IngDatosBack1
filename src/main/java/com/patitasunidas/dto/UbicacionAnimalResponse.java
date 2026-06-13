package com.patitasunidas.dto;

import com.patitasunidas.model.UbicacionAnimal;

import java.time.LocalDate;

public class UbicacionAnimalResponse {
    private Long id;
    private Long animalId;
    private String animalNombre;
    private Long refugioId;
    private String refugioNombre;
    private LocalDate fechaIngreso;
    private String motivoTraslado;
    private LocalDate fechaSalida;
    private Boolean esActual;

    public static UbicacionAnimalResponse from(UbicacionAnimal u) {
        UbicacionAnimalResponse r = new UbicacionAnimalResponse();
        r.setId(u.getId());
        r.setAnimalId(u.getAnimal().getId());
        r.setAnimalNombre(u.getAnimal().getNombre());
        r.setRefugioId(u.getRefugio().getId());
        r.setRefugioNombre(u.getRefugio().getNombre());
        r.setFechaIngreso(u.getFechaIngreso());
        r.setMotivoTraslado(u.getMotivoTraslado());
        r.setFechaSalida(u.getFechaSalida());
        r.setEsActual(u.getEsActual());
        return r;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }
    public String getAnimalNombre() { return animalNombre; }
    public void setAnimalNombre(String animalNombre) { this.animalNombre = animalNombre; }
    public Long getRefugioId() { return refugioId; }
    public void setRefugioId(Long refugioId) { this.refugioId = refugioId; }
    public String getRefugioNombre() { return refugioNombre; }
    public void setRefugioNombre(String refugioNombre) { this.refugioNombre = refugioNombre; }
    public LocalDate getFechaIngreso() { return fechaIngreso; }
    public void setFechaIngreso(LocalDate fechaIngreso) { this.fechaIngreso = fechaIngreso; }
    public String getMotivoTraslado() { return motivoTraslado; }
    public void setMotivoTraslado(String motivoTraslado) { this.motivoTraslado = motivoTraslado; }
    public LocalDate getFechaSalida() { return fechaSalida; }
    public void setFechaSalida(LocalDate fechaSalida) { this.fechaSalida = fechaSalida; }
    public Boolean getEsActual() { return esActual; }
    public void setEsActual(Boolean esActual) { this.esActual = esActual; }
}
