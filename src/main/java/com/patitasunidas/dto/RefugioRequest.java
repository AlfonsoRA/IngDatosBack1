package com.patitasunidas.dto;

import com.patitasunidas.model.Direccion;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class RefugioRequest {

    @NotBlank
    private String nombre;
    private String email;
    private String telefono;
    @NotNull @Min(1)
    private Integer capacidad;
    /** Compatibilidad front anterior */
    private Integer capacidadMaxima;
    @NotBlank
    private String responsable;
    @Valid
    private DireccionDto direccion;
    /** Compatibilidad: si no hay direccion, se usa como calle */
    private String domicilio;

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public Integer getCapacidad() { return capacidad != null ? capacidad : capacidadMaxima; }
    public void setCapacidad(Integer capacidad) { this.capacidad = capacidad; }
    public Integer getCapacidadMaxima() { return getCapacidad(); }
    public void setCapacidadMaxima(Integer capacidadMaxima) { this.capacidadMaxima = capacidadMaxima; }
    public String getResponsable() { return responsable; }
    public void setResponsable(String responsable) { this.responsable = responsable; }
    public DireccionDto getDireccion() { return direccion; }
    public void setDireccion(DireccionDto direccion) { this.direccion = direccion; }
    public String getDomicilio() { return domicilio; }
    public void setDomicilio(String domicilio) { this.domicilio = domicilio; }

    public DireccionDto direccionEfectiva() {
        if (direccion != null && direccion.getCalle() != null) return direccion;
        DireccionDto d = new DireccionDto();
        d.setCalle(domicilio != null ? domicilio : "Sin domicilio");
        d.setLocalidad("AMBA");
        return d;
    }
}
