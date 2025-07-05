/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/**
 *
 * @author Hello
 */
public class Medicamento {
    private int id;
    private String nombre;
    private String viaTransmision;
    private String fecha;
    private int cantidad;

    public Medicamento() {
    }

    public Medicamento(int id, String nombre, String viaTransmision, String fecha, int cantidad) {
        this.id = id;
        this.nombre = nombre;
        this.viaTransmision = viaTransmision;
        this.fecha = fecha;
        this.cantidad = cantidad;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getViaTransmision() {
        return viaTransmision;
    }

    public void setViaTransmision(String viaTransmision) {
        this.viaTransmision = viaTransmision;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }
    

    
}