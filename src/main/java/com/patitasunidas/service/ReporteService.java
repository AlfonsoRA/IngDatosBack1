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
        return jdbc.queryForList("SELECT * FROM dbo.vw_animales_disponibles_resumen ORDER BY refugio_nombre, nombre");
    }

    public List<Map<String, Object>> refugiosOcupacion() {
        return jdbc.queryForList("SELECT * FROM dbo.vw_refugios_ocupacion ORDER BY nombre");
    }

    public List<Map<String, Object>> adopcionesDetalle() {
        return jdbc.queryForList("SELECT * FROM dbo.vw_adopciones_detalle ORDER BY fecha_solicitud DESC");
    }
}
