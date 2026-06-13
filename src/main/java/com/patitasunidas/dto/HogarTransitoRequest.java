package com.patitasunidas.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.Valid;

public class HogarTransitoRequest {
    @NotBlank private String dni;
    @NotBlank private String nombre;
    @NotBlank private String apellido;
    private String email;
    private String telefono;
    @NotNull @Min(1) private Integer capacidadMaxima;
    private Boolean tieneGatos;
    private Boolean tienePerros;
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
    public Integer getCapacidadMaxima() { return capacidadMaxima; }
    public void setCapacidadMaxima(Integer capacidadMaxima) { this.capacidadMaxima = capacidadMaxima; }
    public Boolean getTieneGatos() { return tieneGatos; }
    public void setTieneGatos(Boolean tieneGatos) { this.tieneGatos = tieneGatos; }
    public Boolean getTienePerros() { return tienePerros; }
    public void setTienePerros(Boolean tienePerros) { this.tienePerros = tienePerros; }
    public DireccionDto getDireccion() { return direccion; }
    public void setDireccion(DireccionDto direccion) { this.direccion = direccion; }
}
