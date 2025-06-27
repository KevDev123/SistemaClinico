
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Especialidades</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Listado de Especialidades</h5>
                <div>
                    <a href="especialidadesCRUD.jsp?accion=nuevo" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Nueva Especialidad
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
                                <th>Nombre de Especialidad</th>
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
                                    String sql = "SELECT * FROM especialidades";

                                    if (buscarTerm != null && !buscarTerm.isEmpty()) {
                                        sql += " WHERE nombre_especialidad LIKE '%" + buscarTerm + "%'";
                                    }
                                    
                                    st = con.createStatement();
                                    rs = st.executeQuery(sql);

                                    if (!rs.isBeforeFirst() && buscarTerm != null && !buscarTerm.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="3" class="text-center text-muted py-4">
                                    No se encontraron especialidades que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="especialidades.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            } else {
                                while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id_especialidad")%></td>
                                <td><%= rs.getString("nombre_especialidad")%></td>
                                <td class="action-buttons">
                                    <a href="especialidadesCRUD.jsp?accion=editar&id=<%= rs.getInt("id_especialidad")%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Especialidad">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="especialidadesEliminar.jsp?accion=eliminar&id=<%= rs.getInt("id_especialidad")%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Especialidad" 
                                       onclick="return confirm('¿Está seguro de eliminar esta especialidad?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='3' class='text-danger'>Error al cargar especialidades: " + e.getMessage() + "</td></tr>");
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