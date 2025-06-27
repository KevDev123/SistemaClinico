<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.ArrayList, java.util.List"%>
<%
    // Obtener parámetros de la URL
    String accion = request.getParameter("accion");
    boolean isEdit = "editar".equals(accion);
    int idConsulta = 0;
    int idPacienteParam = 0;
    
    // Obtener ID de paciente (usando el mismo nombre de parámetro que en la URL)
    if (request.getParameter("id_paciente") != null && !request.getParameter("id_paciente").isEmpty()) {
        try {
            idPacienteParam = Integer.parseInt(request.getParameter("id_paciente"));
        } catch (NumberFormatException e) {
            out.println("<script>alert('ID de paciente no válido');</script>");
        }
    }

    // Verificar si es edición
    if (isEdit && request.getParameter("id") != null) {
        try {
            idConsulta = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            out.println("<script>alert('ID de consulta no válido');</script>");
        }
    }

    // Variables para datos del paciente y médico
    String nombrePacienteParam = "Paciente no encontrado";
    String nombreMedicoParam = "";
    
    // Variables para datos de la consulta (en caso de edición)
    String observacionesMod = "";
    int idMedicoMod = 0;
    
    // Obtener fecha actual en formato YYYY-MM-DD
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaConsultaMod = sdf.format(new Date());

    // Obtener datos de la consulta y relaciones
    Connection conConsulta = null;
    PreparedStatement pstConsulta = null;
    ResultSet rsConsulta = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conConsulta = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
        
        if (isEdit) {
            // Obtener información completa de la consulta existente
            pstConsulta = conConsulta.prepareStatement(
                "SELECT c.*, CONCAT(p.nombre_paciente, ' ', p.apellido_paciente) AS paciente, " +
                "CONCAT(m.nombre_medico, ' ', m.apellido_medico) AS medico, " +
                "c.fecha_consulta " +
                "FROM consultas c " +
                "INNER JOIN pacientes p ON c.id_paciente = p.id_paciente " +
                "INNER JOIN medicos m ON c.id_medico = m.id_medico " +
                "WHERE c.id_consulta = ?");
            pstConsulta.setInt(1, idConsulta);
            rsConsulta = pstConsulta.executeQuery();
            
            if (rsConsulta.next()) {
                nombrePacienteParam = rsConsulta.getString("paciente");
                nombreMedicoParam = rsConsulta.getString("medico");
                idPacienteParam = rsConsulta.getInt("id_paciente");
                idMedicoMod = rsConsulta.getInt("id_medico");
                fechaConsultaMod = rsConsulta.getString("fecha_consulta");
                observacionesMod = rsConsulta.getString("observaciones");
            }
        } else if (idPacienteParam > 0) {
            // Para nueva consulta, obtener solo datos del paciente
            pstConsulta = conConsulta.prepareStatement(
                "SELECT CONCAT(nombre_paciente, ' ', apellido_paciente) AS paciente " +
                "FROM pacientes WHERE id_paciente = ?");
            pstConsulta.setInt(1, idPacienteParam);
            rsConsulta = pstConsulta.executeQuery();
            
            if (rsConsulta.next()) {
                nombrePacienteParam = rsConsulta.getString("paciente");
            } else {
                out.println("<script>alert('No se encontró el paciente con ID: " + idPacienteParam + "');</script>");
            }
        }
    } catch (Exception e) {
        out.println("<script>alert('Error al conectar con la base de datos: " + e.getMessage() + "');</script>");
        e.printStackTrace();
    } finally {
        if (rsConsulta != null) try { rsConsulta.close(); } catch (SQLException e) {}
        if (pstConsulta != null) try { pstConsulta.close(); } catch (SQLException e) {}
        if (conConsulta != null) try { conConsulta.close(); } catch (SQLException e) {}
    }

    // Procesar formulario
    if (request.getParameter("submit") != null) {
        int idPaciente = 0;
        int idMedico = 0;
        String fechaConsulta = "";
        String observaciones = "";
        
        try {
            idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            idMedico = Integer.parseInt(request.getParameter("idMedico"));
            fechaConsulta = request.getParameter("fechaConsulta");
            observaciones = request.getParameter("observaciones");
        } catch (NumberFormatException e) {
            out.println("<script>alert('Datos del formulario no válidos');</script>");
        }
        
        Connection con = null;
        PreparedStatement pst = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

            if (isEdit) {
                // Consulta UPDATE para modificación
                pst = con.prepareStatement("UPDATE consultas SET id_paciente=?, id_medico=?, fecha_consulta=?, observaciones=? WHERE id_consulta=?");
                pst.setInt(1, idPaciente);
                pst.setInt(2, idMedico);
                pst.setString(3, fechaConsulta);
                pst.setString(4, observaciones);
                pst.setInt(5, idConsulta);
            } else {
                // Consulta INSERT para nuevo registro
                pst = con.prepareStatement("INSERT INTO consultas(id_paciente, id_medico, fecha_consulta, observaciones) VALUES (?,?,?,?)");
                pst.setInt(1, idPaciente);
                pst.setInt(2, idMedico);
                pst.setString(3, fechaConsulta);
                pst.setString(4, observaciones);
            }

            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
                String message = isEdit ? "Consulta actualizada correctamente" : "Consulta guardada correctamente";
%>
<script>
    alert("<%= message %>");
    window.location.href = "consultas.jsp?id_paciente=<%= idPaciente %>";
</script>
<%
            } else {
                out.println("<script>alert('No se pudo guardar la consulta');</script>");
            }
        } catch (Exception e) {
%>
<script>
    alert("Error: <%= e.getMessage() %>");
    console.error("<%= e.toString() %>");
</script>
<%
        } finally {
            if (pst != null) try { pst.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // Obtener lista de médicos para el select
    List<String[]> medicos = new ArrayList<>();
    Connection conMedicos = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conMedicos = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
        
        stmt = conMedicos.createStatement();
        rs = stmt.executeQuery("SELECT id_medico, CONCAT(nombre_medico, ' ', apellido_medico) AS nombre_completo FROM medicos ORDER BY nombre_medico");
        
        while (rs.next()) {
            medicos.add(new String[]{rs.getString("id_medico"), rs.getString("nombre_completo")});
        }
    } catch (Exception e) {
        out.println("<script>alert('Error al cargar lista de médicos');</script>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conMedicos != null) try { conMedicos.close(); } catch (SQLException e) {}
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
                            <form method="post" action="">
                                <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= idConsulta %>">
                                <% } %>
                                
                                <input type="hidden" name="idPaciente" value="<%= idPacienteParam %>">

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Paciente</label>
                                        <input type="text" class="form-control" value="<%= nombrePacienteParam %>" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="idMedico" class="form-label">Médico</label>
                                        <select class="form-select" id="idMedico" name="idMedico" required>
                                            <option value="" selected disabled>Seleccione un médico</option>
                                            <% for (String[] medico : medicos) { %>
                                            <option value="<%= medico[0] %>" 
                                                    <%= (isEdit && idMedicoMod == Integer.parseInt(medico[0])) ? "selected" : "" %>>
                                                <%= medico[1] %>
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
                                    <a href="consultas.jsp?id_paciente=<%= idPacienteParam %>" class="btn btn-danger">
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