package com.patitasunidas.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public class AnimalRequest {

    @NotBlank
    private String nombre;
    @NotBlank
    private String especie;
    private String raza;
    private Integer edad;
    private LocalDate fechaNacimientoEstimada;
    private String sexo;
    @NotNull
    private LocalDate fechaIngreso;
    private Boolean esCastrado;
    @NotNull
    private Long refugioId;

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEspecie() { return especie; }
    public void setEspecie(String especie) { this.especie = especie; }
    public String getRaza() { return raza; }
    public void setRaza(String raza) { this.raza = raza; }
    public Integer getEdad() { return edad; }
    public void setEdad(Integer edad) { this.edad = edad; }
    public LocalDate getFechaNacimientoEstimada() {
        if (fechaNacimientoEstimada != null) return fechaNacimientoEstimada;
        if (edad != null && fechaIngreso != null) {
            return fechaIngreso.minusYears(edad);
        }
        return null;
    }
    public void setFechaNacimientoEstimada(LocalDate fechaNacimientoEstimada) { this.fechaNacimientoEstimada = fechaNacimientoEstimada; }
    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }
    public LocalDate getFechaIngreso() { return fechaIngreso; }
    public void setFechaIngreso(LocalDate fechaIngreso) { this.fechaIngreso = fechaIngreso; }
    public Boolean getEsCastrado() { return esCastrado; }
    public void setEsCastrado(Boolean esCastrado) { this.esCastrado = esCastrado; }
    public Long getRefugioId() { return refugioId; }
    public void setRefugioId(Long refugioId) { this.refugioId = refugioId; }
}
