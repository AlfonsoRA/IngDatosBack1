package com.patitasunidas.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.Valid;

public class AdoptanteRequest {
    @NotBlank private String dni;
    @NotBlank private String nombre;
    @NotBlank private String apellido;
    private String email;
    private String telefono;
    private Boolean adoptantePrevio;
    @Valid @NotNull private DireccionDto direccion;

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
