<%@page import="model.Consulta"%>
<%@page import="dao.ConsultaDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page import="model.MedicoSelect"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.ArrayList, java.util.List"%>
<%
    // Obtener parámetros de la URL
    String accion = request.getParameter("accion");
    boolean isEdit = "editar".equals(accion);
    

    IConexion cons = new ConexionBD();
    ConsultaDAO co = new ConsultaDAO(cons);
    List<MedicoSelect> medicos = co.obtenerMedicosParaSelect();
    
     // Variables para datos del paciente y médico
    String nombrePacienteMod = "";
    String observacionesMod = "";
    int idMedicoMod = 0;
    int idConsulta = 0;
    int idPaciente = 0;
    
    // Obtener fecha actual en formato YYYY-MM-DD
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaConsultaMod = sdf.format(new Date());
    
    
    // Obtener ID de paciente (usando el mismo nombre de parámetro que en la URL)
    if (request.getParameter("id_paciente") != null && !request.getParameter("id_paciente").isEmpty()) {
        try {
            idPaciente = Integer.parseInt(request.getParameter("id_paciente"));
            nombrePacienteMod = co.obtenerNombrePacientePorId(idPaciente);
        } catch (NumberFormatException e) {
            out.println("<script>alert('ID de paciente no válido');</script>");
        }
    }

    // Verificar si es edición
    if (isEdit && request.getParameter("id") != null) {
        try {
            idConsulta = Integer.parseInt(request.getParameter("id"));
            Consulta con = co.enviarDatosID(idConsulta);
             idPaciente = con.getIdPaciente();
            nombrePacienteMod = con.getNombrePaciente();
            idMedicoMod = con.getIdMedico();
            observacionesMod = con.getObservaciones();
            fechaConsultaMod = con.getFecha();
          
        } catch (NumberFormatException e) {
            out.println("<script>alert('ID de consulta no válido');</script>");
        }
    }


  
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= isEdit ? "Editar" : "Agregar"%> Consulta Médica</title>
        <style>
            .bg-secondary {
                background-color: #6c757d !important;
            }
            .card {
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Consulta Médica" : "Nueva Consulta Médica"%></h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="ConsultaServlet">
                                <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= idConsulta %>">
                                <% } %>
                                
                                <input type="hidden" name="idPaciente" value="<%= idPaciente %>">

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Paciente</label>
                                        <input type="text" class="form-control" value="<%= nombrePacienteMod %>" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="idMedico" class="form-label">Médico</label>
                                        <select class="form-select" id="idMedico" name="idMedico" required>
                                            <option value="" selected disabled>Seleccione un médico</option>
                                            <% for (MedicoSelect m : medicos){ %>
                                                <option value="<%= m.getId() %>" 
                                                        <%= (isEdit && idMedicoMod == m.getId()) ? "selected" : "" %>>
                                                    <%= m.getNombreCompleto() %>
                                                </option>
                                            <% } %>
                                        </select>

                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="fechaConsulta" class="form-label">Fecha de la Consulta</label>
                                        <input type="date" class="form-control" id="fechaConsulta" name="fechaConsulta" 
                                               value="<%= isEdit && fechaConsultaMod != null ? fechaConsultaMod.replace(" ", "T") : "" %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="observaciones" class="form-label">Observaciones</label>
                                        <input type="text" class="form-control" id="observaciones" name="observaciones" 
                                               value="<%= observacionesMod != null ? observacionesMod : "" %>">
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="consultas.jsp?id_paciente=<%= idPaciente %>" class="btn btn-danger">
                                        <i class="bi bi-x-circle"></i> Cancelar
                                    </a>
                                    <button type="submit" name="submit" class="btn btn-success">
                                        <i class="bi bi-check-circle"></i> <%= isEdit ? "Actualizar" : "Agregar" %>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>