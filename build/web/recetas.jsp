
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Recetas</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Listado de Recetas</h5>
                <div>
                    <a href="inicio.jsp" class="btn">
                        <i class="bi bi-arrow-left"></i> Regresar
                    </a>
                </div>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-end">
                    <form method="GET" action="" class="input-group" style="width: 33%;">
                        <input type="text" class="form-control" id="buscar" name="buscar" 
                               placeholder="Buscar..." value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
                        <button type="submit" class="btn btn-dark">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID Receta</th>
                                <th>ID Consulta</th>
                                <th>Paciente</th>
                                <th>Médico</th>
                                <th>Medicamento</th>
                                <th>Cantidad</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection con = null;
                                Statement st = null;
                                ResultSet rs = null;
                                String buscarTerm = request.getParameter("buscar");
                                String buscarPaciente = request.getParameter("idPaciente");

                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
                                    st = con.createStatement();
                                    String sql = "SELECT r.id_receta, r.id_consulta, "
                                            + "CONCAT(p.nombre_paciente, ' ', p.apellido_paciente) AS nombre_completo_paciente, "
                                            + "CONCAT(m.nombre_medico, ' ', m.apellido_medico) AS nombre_completo_medico, "
                                            + "med.nombre_medicamento, r.cantidad "
                                            + "FROM recetas r "
                                            + "INNER JOIN consultas c ON r.id_consulta = c.id_consulta "
                                            + "INNER JOIN pacientes p ON c.id_paciente = p.id_paciente "
                                            + "INNER JOIN medicos m ON c.id_medico = m.id_medico "
                                            + "INNER JOIN medicamentos med ON r.id_medicamento = med.id_medicamento";

                                    if (buscarTerm != null && !buscarTerm.isEmpty()) {
                                        sql += " WHERE (r.id_receta LIKE '%" + buscarTerm + "%' "
                                                + "OR r.id_consulta LIKE '%" + buscarTerm + "%' "
                                                + "OR p.nombre_paciente LIKE '%" + buscarTerm + "%' "
                                                + "OR p.apellido_paciente LIKE '%" + buscarTerm + "%' "
                                                + "OR m.nombre_medico LIKE '%" + buscarTerm + "%' "
                                                + "OR m.apellido_medico LIKE '%" + buscarTerm + "%' "
                                                + "OR med.nombre_medicamento LIKE '%" + buscarTerm + "%' "
                                                + "OR r.cantidad LIKE '%" + buscarTerm + "%')";
                                    } else if (buscarPaciente != null) {
                                        sql += " WHERE c.id_paciente = " + buscarPaciente;
                                    }

                                    rs = st.executeQuery(sql);

                                    if (!rs.isBeforeFirst() && buscarTerm != null && !buscarTerm.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">
                                    No se encontraron recetas que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="recetas.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            } else {
                                while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id_receta")%></td>
                                <td><%= rs.getInt("id_consulta")%></td>
                                <td><%= rs.getString("nombre_completo_paciente")%></td>
                                <td><%= rs.getString("nombre_completo_medico")%></td>
                                <td><%= rs.getString("nombre_medicamento")%></td>
                                <td><%= rs.getInt("cantidad")%></td>
                                <td class="action-buttons">
                                    <a href="recetasCRUD.jsp?accion=editar&id=<%= rs.getInt("id_receta")%>&idConsulta=<%= rs.getInt("id_consulta")%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Receta">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="recetasEliminar.jsp?accion=eliminar&id=<%= rs.getInt("id_receta")%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Receta" 
                                       onclick="return confirm('¿Está seguro de eliminar esta receta?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='7' class='text-danger'>Error al cargar recetas: " + e.getMessage() + "</td></tr>");
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