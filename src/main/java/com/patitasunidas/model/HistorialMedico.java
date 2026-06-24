package com.patitasunidas.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "historial_medico")
public class HistorialMedico {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @SqlIntIdentity
    @Column(name = "id_historial_medico")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_animal", nullable = false)
    private Animal animal;

    @Column(name = "nombre_veterinaria", length = 100)
    private String nombreVeterinaria;

    @Column(length = 200)
    private String observacion;

    @Column(length = 150)
    private String medicamento;

    @Column(length = 150)
    private String diagnostico;

    @Column(name = "tipo_intervencion", nullable = false, length = 100)
    private String tipoIntervencion;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(name = "antirrabica_anual", nullable = false)
    private Boolean antirrabicaAnual = false;

    @Column(name = "sextuple_anual", nullable = false)
    private Boolean sextupleAnual = false;

    @Column(name = "triple_anual", nullable = false)
    private Boolean tripleAnual = false;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Animal getAnimal() { return animal; }
    public void setAnimal(Animal animal) { this.animal = animal; }
    public String getNombreVeterinaria() { return nombreVeterinaria; }
    public void setNombreVeterinaria(String nombreVeterinaria) { this.nombreVeterinaria = nombreVeterinaria; }
    public String getObservacion() { return observacion; }
    public void setObservacion(String observacion) { this.observacion = observacion; }
    public String getMedicamento() { return medicamento; }
    public void setMedicamento(String medicamento) { this.medicamento = medicamento; }
    public String getDiagnostico() { return diagnostico; }
    public void setDiagnostico(String diagnostico) { this.diagnostico = diagnostico; }
    public String getTipoIntervencion() { return tipoIntervencion; }
    public void setTipoIntervencion(String tipoIntervencion) { this.tipoIntervencion = tipoIntervencion; }
    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }
    public Boolean getAntirrabicaAnual() { return antirrabicaAnual; }
    public void setAntirrabicaAnual(Boolean antirrabicaAnual) { this.antirrabicaAnual = antirrabicaAnual; }
    public Boolean getSextupleAnual() { return sextupleAnual; }
    public void setSextupleAnual(Boolean sextupleAnual) { this.sextupleAnual = sextupleAnual; }
    public Boolean getTripleAnual() { return tripleAnual; }
    public void setTripleAnual(Boolean tripleAnual) { this.tripleAnual = tripleAnual; }
}
