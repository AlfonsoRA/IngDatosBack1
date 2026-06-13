package com.patitasunidas.dto;

import com.patitasunidas.model.Animal;
import com.patitasunidas.repository.AdopcionRepository;

public class AnimalResponse {

    private Long id;
    private String nombre;
    private String especie;
    private String raza;
    private Integer edad;
    private java.time.LocalDate fechaIngreso;
    private Boolean esCastrado;
    private Long refugioId;
    private String refugioNombre;
    private String estadoDisponibilidad;

    public static AnimalResponse from(Animal a, AdopcionRepository adopcionRepository) {
        AnimalResponse r = new AnimalResponse();
        r.setId(a.getId());
        r.setNombre(a.getNombre());
        r.setEspecie(a.getEspecie());
        r.setRaza(a.getRaza());
        r.setEdad(a.getEdad());
        r.setFechaIngreso(a.getFechaIngreso());
        r.setEsCastrado(a.getEsCastrado());
        r.setRefugioId(a.getRefugio().getId());
        r.setRefugioNombre(a.getRefugio().getNombre());
        adopcionRepository.findByAnimalId(a.getId()).ifPresentOrElse(
                ad -> r.setEstadoDisponibilidad(
                        "COMPLETADA".equals(ad.getEstadoActual()) ? "ADOPTADO" : "EN_PROCESO"),
                () -> r.setEstadoDisponibilidad("DISPONIBLE"));
        return r;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEspecie() { return especie; }
    public void setEspecie(String especie) { this.especie = especie; }
    public String getRaza() { return raza; }
    public void setRaza(String raza) { this.raza = raza; }
    public Integer getEdad() { return edad; }
    public void setEdad(Integer edad) { this.edad = edad; }
    public java.time.LocalDate getFechaIngreso() { return fechaIngreso; }
    public void setFechaIngreso(java.time.LocalDate fechaIngreso) { this.fechaIngreso = fechaIngreso; }
    public Boolean getEsCastrado() { return esCastrado; }
    public void setEsCastrado(Boolean esCastrado) { this.esCastrado = esCastrado; }
    public Long getRefugioId() { return refugioId; }
    public void setRefugioId(Long refugioId) { this.refugioId = refugioId; }
    public String getRefugioNombre() { return refugioNombre; }
    public void setRefugioNombre(String refugioNombre) { this.refugioNombre = refugioNombre; }
    public String getEstadoDisponibilidad() { return estadoDisponibilidad; }
    public void setEstadoDisponibilidad(String estadoDisponibilidad) { this.estadoDisponibilidad = estadoDisponibilidad; }
}
