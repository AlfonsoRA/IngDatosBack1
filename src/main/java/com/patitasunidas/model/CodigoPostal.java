package com.patitasunidas.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "codigo_postal")
public class CodigoPostal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @SqlIntIdentity
    @Column(name = "cpa_id")
    private Long id;

    @Column(name = "nombre_calle", nullable = false, length = 100)
    private String nombreCalle;

    @Column(length = 50)
    private String localidad;

    @Column(length = 50)
    private String partido;

    @Column(nullable = false, length = 50)
    private String provincia = "BUENOS AIRES";

    @Column(name = "altura_desde", nullable = false)
    private Integer alturaDesde;

    @Column(name = "altura_hasta", nullable = false)
    private Integer alturaHasta;

    @Column(nullable = false, length = 10)
    private String paridad = "AMBOS";

    @JdbcTypeCode(SqlTypes.CHAR)
    @Column(name = "codigo_postal", nullable = false, length = 8)
    private String codigoPostal;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNombreCalle() { return nombreCalle; }
    public void setNombreCalle(String nombreCalle) { this.nombreCalle = nombreCalle; }
    public String getLocalidad() { return localidad; }
    public void setLocalidad(String localidad) { this.localidad = localidad; }
    public String getPartido() { return partido; }
    public void setPartido(String partido) { this.partido = partido; }
    public String getProvincia() { return provincia; }
    public void setProvincia(String provincia) { this.provincia = provincia; }
    public Integer getAlturaDesde() { return alturaDesde; }
    public void setAlturaDesde(Integer alturaDesde) { this.alturaDesde = alturaDesde; }
    public Integer getAlturaHasta() { return alturaHasta; }
    public void setAlturaHasta(Integer alturaHasta) { this.alturaHasta = alturaHasta; }
    public String getParidad() { return paridad; }
    public void setParidad(String paridad) { this.paridad = paridad; }
    public String getCodigoPostal() { return codigoPostal; }
    public void setCodigoPostal(String codigoPostal) { this.codigoPostal = codigoPostal; }
}
