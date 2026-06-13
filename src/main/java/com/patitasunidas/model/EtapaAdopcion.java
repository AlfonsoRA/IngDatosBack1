package com.patitasunidas.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "etapa_adopcion")
public class EtapaAdopcion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_etapa_adopcion")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_adopcion", nullable = false)
    private Adopcion adopcion;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_refugio", nullable = false)
    private Refugio refugio;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Column(length = 500)
    private String observaciones;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Adopcion getAdopcion() { return adopcion; }
    public void setAdopcion(Adopcion adopcion) { this.adopcion = adopcion; }
    public Refugio getRefugio() { return refugio; }
    public void setRefugio(Refugio refugio) { this.refugio = refugio; }
    public LocalDate getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDate fechaInicio) { this.fechaInicio = fechaInicio; }
    public LocalDate getFechaFin() { return fechaFin; }
    public void setFechaFin(LocalDate fechaFin) { this.fechaFin = fechaFin; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}
