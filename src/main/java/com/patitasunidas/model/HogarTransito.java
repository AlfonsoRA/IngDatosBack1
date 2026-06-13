package com.patitasunidas.model;

import jakarta.persistence.*;

@Entity
@Table(name = "hogar_transito")
public class HogarTransito {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_hogar_transito")
    private Long id;

    @OneToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "id_direccion", nullable = false, unique = true)
    private Direccion direccion;

    @Column(nullable = false, length = 20, unique = true)
    private String dni;

    @Column(nullable = false, length = 80)
    private String nombre;

    @Column(nullable = false, length = 80)
    private String apellido;

    @Column(length = 120)
    private String email;

    @Column(length = 30)
    private String telefono;

    @Column(name = "capacidad_maxima", nullable = false)
    private Integer capacidadMaxima;

    @Column(name = "tiene_gatos", nullable = false)
    private Boolean tieneGatos = false;

    @Column(name = "tiene_perros", nullable = false)
    private Boolean tienePerros = false;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Direccion getDireccion() { return direccion; }
    public void setDireccion(Direccion direccion) { this.direccion = direccion; }
    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public Integer getCapacidadMaxima() { return capacidadMaxima; }
    public void setCapacidadMaxima(Integer capacidadMaxima) { this.capacidadMaxima = capacidadMaxima; }
    public Boolean getTieneGatos() { return tieneGatos; }
    public void setTieneGatos(Boolean tieneGatos) { this.tieneGatos = tieneGatos; }
    public Boolean getTienePerros() { return tienePerros; }
    public void setTienePerros(Boolean tienePerros) { this.tienePerros = tienePerros; }
}
