
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.ArrayList, java.util.List"%>
<%
    // Obtener parámetros de la URL
    String accion = request.getParameter("accion");
    boolean isEdit = "editar".equals(accion);
    int idReceta = 0;
    int idConsultaParam = 0;
    int idPaciente = 0;
    
    // Verificar si es edición
    if (isEdit && request.getParameter("id") != null) {
        idReceta = Integer.parseInt(request.getParameter("id"));
    }
    
    // Obtener ID de consulta (siempre presente)
    if (request.getParameter("idConsulta") != null) {
        idConsultaParam = Integer.parseInt(request.getParameter("idConsulta"));
    }

    // Variables para datos de la consulta
    String nombrePacienteParam = "";
    String nombreMedicoParam = "";
    
    // Variables para datos de la receta (en caso de edición)
    int idMedicamentoMod = 0;
    int cantidadMod = 0;

    // Obtener datos de la consulta
    Connection conConsulta = null;
    PreparedStatement pstConsulta = null;
    ResultSet rsConsulta = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conConsulta = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
        
        // Obtener información de la consulta (paciente y médico)
        pstConsulta = conConsulta.prepareStatement(
            "SELECT CONCAT(p.nombre_paciente, ' ', p.apellido_paciente) AS paciente, " +
            "CONCAT(m.nombre_medico, ' ', m.apellido_medico) AS medico, " +
            "c.id_paciente " +
            "FROM consultas c " +
            "INNER JOIN pacientes p ON c.id_paciente = p.id_paciente " +
            "INNER JOIN medicos m ON c.id_medico = m.id_medico " +
            "WHERE c.id_consulta = ?");
        pstConsulta.setInt(1, idConsultaParam);
        rsConsulta = pstConsulta.executeQuery();
        
        if (rsConsulta.next()) {
            nombrePacienteParam = rsConsulta.getString("paciente");
            nombreMedicoParam = rsConsulta.getString("medico");
            idPaciente = rsConsulta.getInt("id_paciente");
        }
        
        // Si es edición, obtener datos de la receta existente
        if (isEdit) {
            PreparedStatement pstReceta = conConsulta.prepareStatement(
                "SELECT id_medicamento, cantidad FROM recetas WHERE id_receta = ?");
            pstReceta.setInt(1, idReceta);
            ResultSet rsReceta = pstReceta.executeQuery();
            
            if (rsReceta.next()) {
                idMedicamentoMod = rsReceta.getInt("id_medicamento");
                cantidadMod = rsReceta.getInt("cantidad");
            }
            rsReceta.close();
            pstReceta.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsConsulta != null) rsConsulta.close();
        if (pstConsulta != null) pstConsulta.close();
        if (conConsulta != null) conConsulta.close();
    }

    // Procesar formulario
    if (request.getParameter("submit") != null) {
        int idMedicamento = Integer.parseInt(request.getParameter("idMedicamento"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        
        Connection con = null;
        PreparedStatement pst = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

            if (isEdit) {
                // Consulta UPDATE para modificación
                pst = con.prepareStatement("UPDATE recetas SET id_medicamento=?, cantidad=? WHERE id_receta=?");
                pst.setInt(1, idMedicamento);
                pst.setInt(2, cantidad);
                pst.setInt(3, idReceta);
            } else {
                // Consulta INSERT para nuevo registro
                pst = con.prepareStatement("INSERT INTO recetas(id_consulta, id_medicamento, cantidad) VALUES (?,?,?)");
                pst.setInt(1, idConsultaParam);
                pst.setInt(2, idMedicamento);
                pst.setInt(3, cantidad);
            }

            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
                String message = isEdit ? "Receta actualizada correctamente" : "Receta guardada correctamente";
%>
<script>
    alert("<%= message%>");
    window.location.href = "recetas.jsp?idPaciente=<%= idPaciente %>";
</script>
<%
            }
        } catch (Exception e) {
%>
<script>
    alert("Error: <%= e.getMessage()%>");
    console.error("<%= e.toString()%>");
</script>
<%
        } finally {
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
    }

    // Obtener lista de medicamentos para el select
    List<String[]> medicamentos = new ArrayList<>();
    Connection conMedicamentos = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conMedicamentos = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
        
        Statement stmt = conMedicamentos.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT id_medicamento, nombre_medicamento FROM medicamentos ORDER BY nombre_medicamento");
        
        while (rs.next()) {
            medicamentos.add(new String[]{rs.getString("id_medicamento"), rs.getString("nombre_medicamento")});
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conMedicamentos != null) conMedicamentos.close();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= isEdit ? "Editar" : "Agregar"%> Receta Médica</title>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Receta Médica" : "Nueva Receta Médica"%></h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="">

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Consulta</label>
                                        <input type="text" class="form-control" 
                                               value="Consulta #<%= idConsultaParam%> - <%= nombrePacienteParam%> / <%= nombreMedicoParam%>" readonly>
                                    </div>                                   

                                    <div class="col-md-6">
                                        <label for="idMedicamento" class="form-label">Medicamento</label>
                                        <select class="form-select" id="idMedicamento" name="idMedicamento" required>
                                            <option value="" selected disabled>Seleccione un medicamento</option>
                                            <% for (String[] medicamento : medicamentos) {%>
                                            <option value="<%= medicamento[0]%>" 
                                                    <%= (isEdit && idMedicamentoMod == Integer.parseInt(medicamento[0])) ? "selected" : ""%>>
                                                <%= medicamento[1]%>
                                            </option>
                                            <% }%>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="cantidad" class="form-label">Cantidad</label>
                                    <input type="number" class="form-control" id="cantidad" name="cantidad" 
                                           min="1" value="<%= cantidadMod == 0 ? "1" : cantidadMod%>" required>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href=<%= isEdit ? "recetas.jsp" : "consultas.jsp?id_paciente=" + idPaciente %> class="btn btn-danger">Cancelar</a>
                                    <button type="submit" name="submit" class="btn btn-success">
                                        <%= isEdit ? "Actualizar" : "Agregar"%>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Validar la cantidad (mínimo 1)
                const cantidadInput = document.getElementById('cantidad');
                if (cantidadInput) {
                    cantidadInput.addEventListener('input', function () {
                        if (this.value < 1) {
                            this.value = 1;
                        }
                    });
                }
            });
        </script>
    </body>
</html>