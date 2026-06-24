package com.patitasunidas.model;

import jakarta.persistence.*;

@Entity
@Table(name = "adoptante")
public class Adoptante {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @SqlIntIdentity
    @Column(name = "id_adoptante")
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "id_direccion", nullable = false)
    private Direccion direccion;

    @Column(nullable = false, length = 20, unique = true)
    private String dni;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 100)
    private String apellido;

    @Column(length = 100)
    private String email;

    @Column(nullable = false, length = 50)
    private String telefono;

    @Column(name = "adoptante_previo", nullable = false)
    private Boolean adoptantePrevio = false;

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
    public Boolean getAdoptantePrevio() { return adoptantePrevio; }
    public void setAdoptantePrevio(Boolean adoptantePrevio) { this.adoptantePrevio = adoptantePrevio; }
}
