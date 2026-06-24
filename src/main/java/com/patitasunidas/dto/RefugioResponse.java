package com.patitasunidas.dto;

import com.patitasunidas.model.Refugio;

public class RefugioResponse {

    private Long id;
    private String nombre;
    private String email;
    private String telefono;
    private Integer capacidad;
    private Integer capacidadMaxima;
    private String responsable;
    private DireccionDto direccion;
    private String domicilio;

    public static RefugioResponse from(Refugio r) {
        RefugioResponse res = new RefugioResponse();
        res.setId(r.getId());
        res.setNombre(r.getNombre());
        res.setEmail(r.getEmail() != null ? r.getEmail().strip() : null);
        res.setTelefono(r.getTelefono());
        res.setCapacidad(r.getCapacidad());
        res.setCapacidadMaxima(r.getCapacidad());
        res.setResponsable(r.getResponsable());
        if (r.getDireccion() != null) {
            res.setDomicilio(r.getDireccion().formatoCompleto());
        }
        return res;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public Integer getCapacidad() { return capacidad; }
    public void setCapacidad(Integer capacidad) { this.capacidad = capacidad; }
    public Integer getCapacidadMaxima() { return capacidadMaxima; }
    public void setCapacidadMaxima(Integer capacidadMaxima) { this.capacidadMaxima = capacidadMaxima; }
    public String getResponsable() { return responsable; }
    public void setResponsable(String responsable) { this.responsable = responsable; }
    public DireccionDto getDireccion() { return direccion; }
    public void setDireccion(DireccionDto direccion) { this.direccion = direccion; }
    public String getDomicilio() { return domicilio; }
    public void setDomicilio(String domicilio) { this.domicilio = domicilio; }
}
