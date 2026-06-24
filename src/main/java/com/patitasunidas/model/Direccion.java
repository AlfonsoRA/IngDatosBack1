package com.patitasunidas.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "direccion")
public class Direccion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @SqlIntIdentity
    @Column(name = "id_direccion")
    private Long id;

    @Column(nullable = false, length = 120)
    private String nombre;

    @Column(nullable = false)
    private Integer altura;

    @Column(length = 80)
    private String localidad;

    @Column(length = 80)
    private String partido;

    @Column(nullable = false, length = 50)
    private String provincia = "BUENOS AIRES";

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public Integer getAltura() { return altura; }
    public void setAltura(Integer altura) { this.altura = altura; }
    public String getLocalidad() { return localidad; }
    public void setLocalidad(String localidad) { this.localidad = localidad; }
    public String getPartido() { return partido; }
    public void setPartido(String partido) { this.partido = partido; }
    public String getProvincia() { return provincia; }
    public void setProvincia(String provincia) { this.provincia = provincia; }

    public String formatoCompleto() {
        StringBuilder sb = new StringBuilder(nombre);
        if (altura != null && altura > 0) sb.append(" ").append(altura);
        if (localidad != null && !localidad.isBlank()) sb.append(", ").append(localidad);
        if (partido != null && !partido.isBlank()) sb.append(" (").append(partido).append(")");
        return sb.toString();
    }
}
