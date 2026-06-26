package com.patitasunidas.dto;

import com.patitasunidas.model.CodigoPostal;
import com.patitasunidas.model.Direccion;
import com.patitasunidas.repository.CodigoPostalRepository;

public final class DireccionMapper {

    private DireccionMapper() {}

    public static DireccionDto toDto(Direccion d) {
        DireccionDto dto = new DireccionDto();
        dto.setId(d.getId());
        dto.setCalle(d.getNombre());
        dto.setNumero(d.getAltura() != null && d.getAltura() > 0 ? String.valueOf(d.getAltura()) : null);
        dto.setLocalidad(d.getLocalidad());
        dto.setPartido(d.getPartido());
        dto.setProvincia(d.getProvincia());
        if (d.getCodigoPostal() != null) {
            dto.setCpaId(d.getCodigoPostal().getId());
            dto.setCp(d.getCodigoPostal().getCodigoPostal().trim());
        }
        return dto;
    }

    public static Direccion toEntity(DireccionDto dto, CodigoPostal codigoPostal) {
        Direccion d = new Direccion();
        if (dto.getId() != null) d.setId(dto.getId());
        d.setCodigoPostal(codigoPostal);
        d.setNombre(dto.getCalle());
        d.setAltura(parseAltura(dto.getNumero()));
        d.setLocalidad(dto.getLocalidad());
        d.setPartido(dto.getPartido());
        d.setProvincia(dto.getProvincia() != null && !dto.getProvincia().isBlank()
                ? dto.getProvincia() : "BUENOS AIRES");
        return d;
    }

    public static CodigoPostal crearCodigoPostal(DireccionDto dto) {
        CodigoPostal cp = new CodigoPostal();
        cp.setNombreCalle(dto.getCalle());
        cp.setLocalidad(dto.getLocalidad());
        cp.setPartido(dto.getPartido());
        cp.setProvincia(dto.getProvincia() != null && !dto.getProvincia().isBlank()
                ? dto.getProvincia() : "BUENOS AIRES");
        int altura = parseAltura(dto.getNumero());
        cp.setAlturaDesde(1);
        cp.setAlturaHasta(Math.max(altura, 9999));
        cp.setParidad("AMBOS");
        cp.setCodigoPostal(formatCp(dto.getCp()));
        return cp;
    }

    public static String formatCp(String cp) {
        if (cp == null || cp.isBlank()) return "0000    ";
        return String.format("%-8s", cp.trim()).substring(0, 8);
    }

    private static int parseAltura(String numero) {
        if (numero == null || numero.isBlank()) return 0;
        try {
            return Integer.parseInt(numero.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
