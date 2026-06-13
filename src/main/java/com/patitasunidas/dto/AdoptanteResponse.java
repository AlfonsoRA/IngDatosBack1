package com.patitasunidas.dto;

import com.patitasunidas.model.Adoptante;

public class AdoptanteResponse {
    private Long id;
    private String dni;
    private String nombre;
    private String apellido;
    private String email;
    private String telefono;
    private Boolean adoptantePrevio;
    private DireccionDto direccion;

    public static AdoptanteResponse from(Adoptante a) {
        AdoptanteResponse r = new AdoptanteResponse();
        r.setId(a.getId());
        r.setDni(a.getDni());
        r.setNombre(a.getNombre());
        r.setApellido(a.getApellido());
        r.setEmail(a.getEmail());
        r.setTelefono(a.getTelefono());
        r.setAdoptantePrevio(a.getAdoptantePrevio());
        r.setDireccion(DireccionMapper.toDto(a.getDireccion()));
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
    public Boolean getAdoptantePrevio() { return adoptantePrevio; }
    public void setAdoptantePrevio(Boolean adoptantePrevio) { this.adoptantePrevio = adoptantePrevio; }
    public DireccionDto getDireccion() { return direccion; }
    public void setDireccion(DireccionDto direccion) { this.direccion = direccion; }
}
