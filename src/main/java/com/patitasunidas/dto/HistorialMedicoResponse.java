package com.patitasunidas.dto;

import com.patitasunidas.model.HistorialMedico;

import java.time.LocalDate;

public class HistorialMedicoResponse {
    private Long id;
    private Long animalId;
    private String animalNombre;
    private String nombreVeterinaria;
    private String observacion;
    private String medicamento;
    private String diagnostico;
    private String tipoIntervencion;
    private LocalDate fecha;
    private Boolean antirrabicaAnual;
    private Boolean sextupleAnual;
    private Boolean tripleAnual;

    public static HistorialMedicoResponse from(HistorialMedico h) {
        HistorialMedicoResponse r = new HistorialMedicoResponse();
        r.setId(h.getId());
        r.setAnimalId(h.getAnimal().getId());
        r.setAnimalNombre(h.getAnimal().getNombre());
        r.setNombreVeterinaria(h.getNombreVeterinaria());
        r.setObservacion(h.getObservacion());
        r.setMedicamento(h.getMedicamento());
        r.setDiagnostico(h.getDiagnostico());
        r.setTipoIntervencion(h.getTipoIntervencion());
        r.setFecha(h.getFecha());
        r.setAntirrabicaAnual(h.getAntirrabicaAnual());
        r.setSextupleAnual(h.getSextupleAnual());
        r.setTripleAnual(h.getTripleAnual());
        return r;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }
    public String getAnimalNombre() { return animalNombre; }
    public void setAnimalNombre(String animalNombre) { this.animalNombre = animalNombre; }
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
