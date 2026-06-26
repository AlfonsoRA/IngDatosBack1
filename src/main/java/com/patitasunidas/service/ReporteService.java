package com.patitasunidas.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class ReporteService {

    private final JdbcTemplate jdbc;

    public ReporteService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Map<String, Object>> animalesDisponibles() {
        return jdbc.queryForList("SELECT * FROM dbo.VW_AnimalesDisponibles ORDER BY refugio_actual, animal");
    }

    public List<Map<String, Object>> refugiosOcupacion() {
        return jdbc.queryForList("SELECT * FROM dbo.VW_OcupacionRefugios ORDER BY refugio");
    }

    public List<Map<String, Object>> adopcionesDetalle() {
        return jdbc.queryForList("SELECT * FROM dbo.VW_HistorialAdopciones ORDER BY fecha_solicitud DESC");
    }

    public List<Map<String, Object>> historialMedicoCompleto() {
        return jdbc.queryForList("SELECT * FROM dbo.VW_HistorialMedicoCompleto ORDER BY fecha_atencion DESC");
    }

    public List<Map<String, Object>> transitosActivos() {
        return jdbc.queryForList("""
                SELECT a.nombre AS animal,
                       ht.nombre + ' ' + ht.apellido AS hogar_transito,
                       t.fecha_inicio
                FROM dbo.transito t
                JOIN dbo.animal a ON t.id_animal = a.id_animal
                JOIN dbo.hogar_transito ht ON t.id_hogar_transito = ht.id_hogar_transito
                WHERE t.estado_actual = N'En tránsito'
                ORDER BY t.fecha_inicio DESC
                """);
    }

    public List<Map<String, Object>> adopcionesPorMes() {
        return jdbc.queryForList("""
                SELECT YEAR(fecha_solicitud) AS anio,
                       MONTH(fecha_solicitud) AS mes,
                       COUNT(*) AS cantidad_adopciones
                FROM dbo.adopcion
                WHERE estado_actual = 'Concretada'
                GROUP BY YEAR(fecha_solicitud), MONTH(fecha_solicitud)
                ORDER BY anio, mes
                """);
    }

    public List<Map<String, Object>> trasladosRefugios() {
        return jdbc.queryForList("""
                SELECT a.nombre AS animal,
                       r.nombre AS refugio,
                       ua.fecha_ingreso,
                       ua.motivo_traslado
                FROM dbo.ubicacion_animal ua
                JOIN dbo.animal a ON ua.id_animal = a.id_animal
                JOIN dbo.refugio r ON ua.id_refugio = r.id_refugio
                WHERE ua.motivo_traslado IS NOT NULL
                ORDER BY ua.fecha_ingreso DESC
                """);
    }
}
