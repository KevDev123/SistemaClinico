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
public class MedicamentoSelect {
     private int id;
    private String nombreMedicamento;

    public MedicamentoSelect() {
    }

    public MedicamentoSelect(int id, String nombreMedicamento) {
        this.id = id;
        this.nombreMedicamento = nombreMedicamento;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombreMedicamento() {
        return nombreMedicamento;
    }

    public void setNombreMedicamento(String nombreMedicamento) {
        this.nombreMedicamento = nombreMedicamento;
    }
    
   
    
}
