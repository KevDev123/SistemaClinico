package model;

/**
 *
 * @author Hello
 */
public class Receta {
    private int id;
    private int idConsulta;
    private String nombreConsulta;
    private int idMedicamento;
    private String nombreMedicamento;
    private int cantidad;
    private String nombrePaciente;
   private String nombreMedico;


    public Receta() {
    }

    public Receta(int id, int idConsulta, String nombreConsulta, int idMedicamento, String nombreMedicamento, int cantidad) {
        this.id = id;
        this.idConsulta = idConsulta;
        this.nombreConsulta = nombreConsulta;
        this.idMedicamento = idMedicamento;
        this.nombreMedicamento = nombreMedicamento;
        this.cantidad = cantidad;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdConsulta() {
        return idConsulta;
    }

    public void setIdConsulta(int idConsulta) {
        this.idConsulta = idConsulta;
    }

    public String getNombreConsulta() {
        return nombreConsulta;
    }

    public void setNombreConsulta(String nombreConsulta) {
        this.nombreConsulta = nombreConsulta;
    }

    public int getIdMedicamento() {
        return idMedicamento;
    }

    public void setIdMedicamento(int idMedicamento) {
        this.idMedicamento = idMedicamento;
    }

    public String getNombreMedicamento() {
        return nombreMedicamento;
    }

    public void setNombreMedicamento(String nombreMedicamento) {
        this.nombreMedicamento = nombreMedicamento;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public String getNombrePaciente() {
        return nombrePaciente;
    }

    public void setNombrePaciente(String nombrePaciente) {
        this.nombrePaciente = nombrePaciente;
    }

    public String getNombreMedico() {
        return nombreMedico;
    }

    public void setNombreMedico(String nombreMedico) {
        this.nombreMedico = nombreMedico;
    }
    
    
    
    
    
    
    
    
    
    
}