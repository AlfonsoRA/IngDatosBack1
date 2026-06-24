package com.patitasunidas.service;

import com.patitasunidas.dto.DireccionDto;
import com.patitasunidas.dto.DireccionMapper;
import com.patitasunidas.model.Direccion;
import com.patitasunidas.repository.CodigoPostalRepository;
import com.patitasunidas.repository.DireccionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class DireccionService {

    private final DireccionRepository direccionRepository;
    private final CodigoPostalRepository codigoPostalRepository;

    public DireccionService(DireccionRepository direccionRepository,
                            CodigoPostalRepository codigoPostalRepository) {
        this.direccionRepository = direccionRepository;
        this.codigoPostalRepository = codigoPostalRepository;
    }

    public Direccion guardar(DireccionDto dto) {
        Direccion direccion = direccionRepository.save(DireccionMapper.toEntity(dto));
        DireccionMapper.guardarCodigoPostal(direccion, dto, codigoPostalRepository);
        return direccion;
    }

    public void actualizar(Direccion direccion, DireccionDto dto) {
        direccion.setNombre(dto.getCalle());
        direccion.setAltura(DireccionMapper.toEntity(dto).getAltura());
        direccion.setLocalidad(dto.getLocalidad() != null ? dto.getLocalidad() : direccion.getLocalidad());
        direccion.setPartido(dto.getPartido());
        if (dto.getProvincia() != null && !dto.getProvincia().isBlank()) {
            direccion.setProvincia(dto.getProvincia());
        }
        direccionRepository.save(direccion);
        DireccionMapper.guardarCodigoPostal(direccion, dto, codigoPostalRepository);
    }

    @Transactional(readOnly = true)
    public DireccionDto toDto(Direccion direccion) {
        return DireccionMapper.toDto(direccion, codigoPostalRepository);
    }

    public void eliminar(Direccion direccion) {
        codigoPostalRepository.findByDireccionId(direccion.getId())
                .forEach(cp -> codigoPostalRepository.delete(cp));
        direccionRepository.delete(direccion);
    }
}
