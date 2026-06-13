package com.patitasunidas.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public class HistorialMedicoRequest {
    @NotNull private Long animalId;
    private String nombreVeterinaria;
    private String observacion;
    private String medicamento;
    private String diagnostico;
    private String tipoIntervencion;
    @NotNull private LocalDate fecha;
    private Boolean antirrabicaAnual;
    private Boolean sextupleAnual;
    private Boolean tripleAnual;

    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }
    public String getNombreVeterinaria() { return nombreVeterinaria; }
    public void setNombreVeterinaria(String v) { this.nombreVeterinaria = v; }
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
    public void setAntirrabicaAnual(Boolean b) { this.antirrabicaAnual = b; }
    public Boolean getSextupleAnual() { return sextupleAnual; }
    public void setSextupleAnual(Boolean b) { this.sextupleAnual = b; }
    public Boolean getTripleAnual() { return tripleAnual; }
    public void setTripleAnual(Boolean b) { this.tripleAnual = b; }
}
