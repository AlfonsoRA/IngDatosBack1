package com.patitasunidas.dto;

import com.patitasunidas.model.Direccion;

public final class DireccionMapper {

    private DireccionMapper() {}

    public static DireccionDto toDto(Direccion d) {
        DireccionDto dto = new DireccionDto();
        dto.setId(d.getId());
        dto.setCalle(d.getCalle());
        dto.setNumero(d.getNumero());
        dto.setLocalidad(d.getLocalidad());
        dto.setPartido(d.getPartido());
        dto.setCp(d.getCp());
        return dto;
    }

    public static Direccion toEntity(DireccionDto dto) {
        Direccion d = new Direccion();
        if (dto.getId() != null) d.setId(dto.getId());
        d.setCalle(dto.getCalle());
        d.setNumero(dto.getNumero());
        d.setLocalidad(dto.getLocalidad());
        d.setPartido(dto.getPartido());
        d.setCp(dto.getCp());
        return d;
    }
}
