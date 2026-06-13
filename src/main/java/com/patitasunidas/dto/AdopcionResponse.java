package com.patitasunidas.dto;

import com.patitasunidas.model.Adopcion;

import java.time.LocalDate;

public class AdopcionResponse {
    private Long id;
    private Long animalId;
    private String animalNombre;
    private Long adoptanteId;
    private String adoptanteNombre;
    private LocalDate fechaSolicitud;
    private String estadoActual;

    public static AdopcionResponse from(Adopcion a) {
        AdopcionResponse r = new AdopcionResponse();
        r.setId(a.getId());
        r.setAnimalId(a.getAnimal().getId());
        r.setAnimalNombre(a.getAnimal().getNombre());
        r.setAdoptanteId(a.getAdoptante().getId());
        r.setAdoptanteNombre(a.getAdoptante().getNombre() + " " + a.getAdoptante().getApellido());
        r.setFechaSolicitud(a.getFechaSolicitud());
        r.setEstadoActual(a.getEstadoActual());
        return r;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }
    public String getAnimalNombre() { return animalNombre; }
    public void setAnimalNombre(String animalNombre) { this.animalNombre = animalNombre; }
    public Long getAdoptanteId() { return adoptanteId; }
    public void setAdoptanteId(Long adoptanteId) { this.adoptanteId = adoptanteId; }
    public String getAdoptanteNombre() { return adoptanteNombre; }
    public void setAdoptanteNombre(String adoptanteNombre) { this.adoptanteNombre = adoptanteNombre; }
    public LocalDate getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(LocalDate fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }
    public String getEstadoActual() { return estadoActual; }
    public void setEstadoActual(String estadoActual) { this.estadoActual = estadoActual; }
}
