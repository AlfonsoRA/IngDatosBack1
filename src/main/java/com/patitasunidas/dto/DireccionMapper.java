package com.patitasunidas.dto;

import com.patitasunidas.model.CodigoPostal;
import com.patitasunidas.model.Direccion;
import com.patitasunidas.repository.CodigoPostalRepository;

public final class DireccionMapper {

    private DireccionMapper() {}

    public static DireccionDto toDto(Direccion d, CodigoPostalRepository cpRepo) {
        DireccionDto dto = new DireccionDto();
        dto.setId(d.getId());
        dto.setCalle(d.getNombre());
        dto.setNumero(d.getAltura() != null && d.getAltura() > 0 ? String.valueOf(d.getAltura()) : null);
        dto.setLocalidad(d.getLocalidad());
        dto.setPartido(d.getPartido());
        dto.setProvincia(d.getProvincia());
        cpRepo.findFirstByDireccionId(d.getId())
                .ifPresent(cp -> dto.setCp(cp.getCodigoPostal().trim()));
        return dto;
    }

    public static Direccion toEntity(DireccionDto dto) {
        Direccion d = new Direccion();
        if (dto.getId() != null) d.setId(dto.getId());
        d.setNombre(dto.getCalle());
        d.setAltura(parseAltura(dto.getNumero()));
        d.setLocalidad(dto.getLocalidad());
        d.setPartido(dto.getPartido());
        d.setProvincia(dto.getProvincia() != null && !dto.getProvincia().isBlank()
                ? dto.getProvincia() : "BUENOS AIRES");
        return d;
    }

    public static void guardarCodigoPostal(Direccion direccion, DireccionDto dto, CodigoPostalRepository cpRepo) {
        if (dto.getCp() == null || dto.getCp().isBlank()) return;
        String cp = String.format("%-8s", dto.getCp().trim()).substring(0, 8);
        CodigoPostal registro = cpRepo.findFirstByDireccionId(direccion.getId()).orElseGet(CodigoPostal::new);
        registro.setDireccion(direccion);
        registro.setAlturaDesde(direccion.getAltura());
        registro.setAlturaHasta(direccion.getAltura());
        registro.setParidad("AMBOS");
        registro.setCodigoPostal(cp);
        cpRepo.save(registro);
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
