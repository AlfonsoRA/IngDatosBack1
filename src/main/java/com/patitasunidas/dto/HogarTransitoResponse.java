package com.patitasunidas.dto;

import com.patitasunidas.model.HogarTransito;

public class HogarTransitoResponse {
    private Long id;
    private String dni;
    private String nombre;
    private String apellido;
    private String email;
    private String telefono;
    private Integer capacidadMaxima;
    private Boolean tieneGatos;
    private Boolean tienePerros;
    private DireccionDto direccion;

    public static HogarTransitoResponse from(HogarTransito h) {
        HogarTransitoResponse r = new HogarTransitoResponse();
        r.setId(h.getId());
        r.setDni(h.getDni());
        r.setNombre(h.getNombre());
        r.setApellido(h.getApellido());
        r.setEmail(h.getEmail());
        r.setTelefono(h.getTelefono());
        r.setCapacidadMaxima(h.getCapacidadAceptada());
        r.setTieneGatos(h.getAceptaGatos());
        r.setTienePerros(h.getAceptaPerros());
        return r;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public Integer getCapacidadMaxima() { return capacidadMaxima; }
    public void setCapacidadMaxima(Integer capacidadMaxima) { this.capacidadMaxima = capacidadMaxima; }
    public Boolean getTieneGatos() { return tieneGatos; }
    public void setTieneGatos(Boolean tieneGatos) { this.tieneGatos = tieneGatos; }
    public Boolean getTienePerros() { return tienePerros; }
    public void setTienePerros(Boolean tienePerros) { this.tienePerros = tienePerros; }
    public DireccionDto getDireccion() { return direccion; }
    public void setDireccion(DireccionDto direccion) { this.direccion = direccion; }
}
