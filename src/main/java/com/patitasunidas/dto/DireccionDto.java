package com.patitasunidas.dto;

import jakarta.validation.constraints.NotBlank;

public class DireccionDto {
    private Long id;
    /** API/front: equivale a nombre en BD */
    @NotBlank
    private String calle;
    private String numero;
    @NotBlank
    private String localidad;
    private String partido;
    private String provincia = "BUENOS AIRES";
    private String cp;
    private Long cpaId;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCalle() { return calle; }
    public void setCalle(String calle) { this.calle = calle; }
    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }
    public String getLocalidad() { return localidad; }
    public void setLocalidad(String localidad) { this.localidad = localidad; }
    public String getPartido() { return partido; }
    public void setPartido(String partido) { this.partido = partido; }
    public String getProvincia() { return provincia; }
    public void setProvincia(String provincia) { this.provincia = provincia; }
    public String getCp() { return cp; }
    public void setCp(String cp) { this.cp = cp; }
    public Long getCpaId() { return cpaId; }
    public void setCpaId(Long cpaId) { this.cpaId = cpaId; }
}
