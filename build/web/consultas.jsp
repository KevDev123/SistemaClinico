
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Historial de Consultas</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Historial de Consultas del Paciente</h5>
                <div>
                    <%
                        String id_paciente = request.getParameter("id_paciente");
                    %>

                    <a href="consultasCRUD.jsp?accion=nuevo&id_paciente=<%= id_paciente%>" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Agregar consulta
                    </a>
                    <a href="pacientes.jsp" class="btn">
                        <i class="bi bi-arrow-left"></i> Regresar
                    </a>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID Consulta</th>
                                <th>Paciente</th>
                                <th>Médico</th>
                                <th>Fecha</th>
                                <th>Observaciones</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection con = null;
                                Statement st = null;
                                ResultSet rs = null;;
                                String idPaciente = request.getParameter("id_paciente");

                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
                                    st = con.createStatement();
                                    String sql = "SELECT c.id_consulta, "
                                            + "CONCAT(p.nombre_paciente, ' ', p.apellido_paciente) AS paciente, "
                                            + "CONCAT(m.nombre_medico, ' ', m.apellido_medico) AS medico, "
                                            + "c.fecha_consulta, c.observaciones "
                                            + "FROM consultas c "
                                            + "INNER JOIN pacientes p ON c.id_paciente = p.id_paciente "
                                            + "INNER JOIN medicos m ON c.id_medico = m.id_medico "
                                            + "WHERE c.id_paciente = " + idPaciente;

                                    st = con.createStatement();
                                    rs = st.executeQuery(sql);

                                    if (!rs.isBeforeFirst()) {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">
                                    No se encontraron consultas para este paciente
                                </td>
                            </tr>
                            <%
                            } else {
                                while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id_consulta")%></td>
                                <td><%= rs.getString("paciente")%></td>
                                <td><%= rs.getString("medico")%></td>
                                <td><%= rs.getDate("fecha_consulta")%></td>
                                <td><%= rs.getString("observaciones") != null ? rs.getString("observaciones") : "-"%></td>
                                <td class="action-buttons">
                                    <a href="consultasCRUD.jsp?accion=editar&id=<%= rs.getInt("c.id_consulta")%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar consulta">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="consultasEliminar.jsp?accion=eliminar&id=<%= rs.getInt("c.id_consulta")%>&id_Paciente=<%= id_paciente%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Médico" 
                                       onclick="return confirm('¿Está seguro de eliminar esta consulta?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                    <a href="recetasCRUD.jsp?accion=nuevo&idConsulta=<%= rs.getInt("c.id_consulta")%>" 
                                       class="btn btn-sm"
                                       style="color: #17a2b8;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Agregar Receta">
                                        <i class="bi bi-capsule-pill"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='5' class='text-danger'>Error al cargar consultas: " + e.getMessage() + "</td></tr>");
                                } finally {
                                    if (rs != null) {
                                        rs.close();
                                    }
                                    if (st != null) {
                                        st.close();
                                    }
                                    if (con != null) {
                                        con.close();
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>