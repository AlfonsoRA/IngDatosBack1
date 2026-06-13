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
    @Column(name = "id_direccion")
    private Long id;

    @Column(nullable = false, length = 120)
    private String calle;

    @Column(length = 20)
    private String numero;

    @Column(nullable = false, length = 100)
    private String localidad;

    @Column(length = 100)
    private String partido;

    @Column(length = 10)
    private String cp;

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
    public String getCp() { return cp; }
    public void setCp(String cp) { this.cp = cp; }

    public String formatoCompleto() {
        StringBuilder sb = new StringBuilder(calle);
        if (numero != null && !numero.isBlank()) sb.append(" ").append(numero);
        sb.append(", ").append(localidad);
        if (partido != null && !partido.isBlank()) sb.append(" (").append(partido).append(")");
        if (cp != null && !cp.isBlank()) sb.append(" CP ").append(cp);
        return sb.toString();
    }
}
