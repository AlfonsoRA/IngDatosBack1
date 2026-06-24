package com.patitasunidas.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "direccion_id", nullable = false)
    private Direccion direccion;

    @Column(name = "altura_desde", nullable = false)
    private Integer alturaDesde;

    @Column(name = "altura_hasta", nullable = false)
    private Integer alturaHasta;

    @Column(nullable = false, length = 5)
    private String paridad = "AMBOS";

    @JdbcTypeCode(SqlTypes.CHAR)
    @Column(name = "codigo_postal", nullable = false, length = 8)
    private String codigoPostal;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Direccion getDireccion() { return direccion; }
    public void setDireccion(Direccion direccion) { this.direccion = direccion; }
    public Integer getAlturaDesde() { return alturaDesde; }
    public void setAlturaDesde(Integer alturaDesde) { this.alturaDesde = alturaDesde; }
    public Integer getAlturaHasta() { return alturaHasta; }
    public void setAlturaHasta(Integer alturaHasta) { this.alturaHasta = alturaHasta; }
    public String getParidad() { return paridad; }
    public void setParidad(String paridad) { this.paridad = paridad; }
    public String getCodigoPostal() { return codigoPostal; }
    public void setCodigoPostal(String codigoPostal) { this.codigoPostal = codigoPostal; }
}
