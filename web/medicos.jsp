
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Medicos</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Listado de Médicos</h5>
                <div>
                    <a href="medicosCRUD.jsp?accion=nuevo" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Nuevo Médico
                    </a>
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
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Especialidad</th>
                                <th>Teléfono</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection con = null;
                                Statement st = null;
                                ResultSet rs = null;
                                String buscarTerm = request.getParameter("buscar");

                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
                                    st = con.createStatement();
                                    String sql = "SELECT m.id_medico, m.nombre_medico, m.apellido_medico, "
                                            + "e.nombre_especialidad AS especialidad, m.telefono_medico "
                                            + "FROM medicos AS m "
                                            + "INNER JOIN especialidades AS e ON m.id_especialidad = e.id_especialidad";

                                    if (buscarTerm != null && !buscarTerm.isEmpty()) {
                                        sql += " WHERE (m.nombre_medico LIKE '%" + buscarTerm + "%' "
                                                + "OR m.apellido_medico LIKE '%" + buscarTerm + "%' "
                                                + "OR e.nombre_especialidad LIKE '%" + buscarTerm + "%' "
                                                + "OR m.telefono_medico LIKE '%" + buscarTerm + "%')";
                                    }
                                    
                                    st = con.createStatement();
                                    rs = st.executeQuery(sql);

                                    if (!rs.isBeforeFirst() && buscarTerm != null && !buscarTerm.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">
                                    No se encontraron médicos que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="medicos.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            } else {
                                while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id_medico")%></td>
                                <td><%= rs.getString("nombre_medico")%></td>
                                <td><%= rs.getString("apellido_medico")%></td>
                                <td><%= rs.getString("especialidad")%></td>
                                <td><%= rs.getString("telefono_medico") != null ? rs.getString("telefono_medico") : "-"%></td>
                                <td class="action-buttons">
                                    <a href="medicosCRUD.jsp?accion=editar&id=<%= rs.getInt("m.id_medico")%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Médico">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="medicosEliminar.jsp?accion=eliminar&id=<%= rs.getInt("m.id_medico")%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Médico" 
                                       onclick="return confirm('¿Está seguro de eliminar este médico?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='7' class='text-danger'>Error al cargar medicos: " + e.getMessage() + "</td></tr>");
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
