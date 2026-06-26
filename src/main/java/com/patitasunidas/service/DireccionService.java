package com.patitasunidas.service;

import com.patitasunidas.dto.DireccionDto;
import com.patitasunidas.dto.DireccionMapper;
import com.patitasunidas.model.CodigoPostal;
import com.patitasunidas.model.Direccion;
import com.patitasunidas.repository.CodigoPostalRepository;
import com.patitasunidas.repository.DireccionRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

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
        CodigoPostal cp = resolverCodigoPostal(dto);
        return direccionRepository.save(DireccionMapper.toEntity(dto, cp));
    }

    public void actualizar(Direccion direccion, DireccionDto dto) {
        CodigoPostal cp = resolverCodigoPostal(dto);
        direccion.setCodigoPostal(cp);
        direccion.setNombre(dto.getCalle());
        direccion.setAltura(DireccionMapper.toEntity(dto, cp).getAltura());
        direccion.setLocalidad(dto.getLocalidad() != null ? dto.getLocalidad() : direccion.getLocalidad());
        direccion.setPartido(dto.getPartido());
        if (dto.getProvincia() != null && !dto.getProvincia().isBlank()) {
            direccion.setProvincia(dto.getProvincia());
        }
        direccionRepository.save(direccion);
    }

    @Transactional(readOnly = true)
    public DireccionDto toDto(Direccion direccion) {
        return DireccionMapper.toDto(direccion);
    }

    public void eliminar(Direccion direccion) {
        direccionRepository.delete(direccion);
    }

    private CodigoPostal resolverCodigoPostal(DireccionDto dto) {
        if (dto.getCpaId() != null) {
            return codigoPostalRepository.findById(dto.getCpaId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Codigo postal no encontrado"));
        }
        if (dto.getCp() != null && !dto.getCp().isBlank()) {
            return codigoPostalRepository.findFirstByCodigoPostal(DireccionMapper.formatCp(dto.getCp()))
                    .orElseGet(() -> codigoPostalRepository.save(DireccionMapper.crearCodigoPostal(dto)));
        }
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Debe indicar cpaId o codigo postal (cp)");
    }
}
