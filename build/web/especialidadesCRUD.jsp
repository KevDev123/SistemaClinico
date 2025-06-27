
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    // Variables para modo edición
    boolean isEdit = false;
    int idEspecialidad = 0;
    if (request.getParameter("id") != null) {
        isEdit = true;
        idEspecialidad = Integer.parseInt(request.getParameter("id"));
    }

    // Procesar formulario
    if (request.getParameter("submit") != null) {
        String nombreEspecialidad = request.getParameter("nombreEspecialidad");

        Connection con = null;
        PreparedStatement pst = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

            if (isEdit) {
                // Consulta UPDATE para modificación
                pst = con.prepareStatement("UPDATE especialidades SET nombre_especialidad=? WHERE id_especialidad=?");
                pst.setString(1, nombreEspecialidad);
                pst.setInt(2, idEspecialidad);
            } else {
                // Consulta INSERT para nuevo registro
                pst = con.prepareStatement("INSERT INTO especialidades(nombre_especialidad) VALUES (?)");
                pst.setString(1, nombreEspecialidad);
            }

            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
                String message = isEdit ? "Especialidad actualizada correctamente" : "Especialidad guardada correctamente";
%>
<script>
    alert("<%= message%>");
    window.location.href = "especialidades.jsp";
</script>
<%
    }
} catch (Exception e) {
%>
<script>
    alert("Error: <%= e.getMessage()%>");
</script>
<%
        } finally {
            if (pst != null) {
                pst.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }

    // Cargar datos si es modificación
    String nombreEspecialidadMod = "";

    if (isEdit) {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
            pst = con.prepareStatement("SELECT * FROM especialidades WHERE id_especialidad = ?");
            pst.setInt(1, idEspecialidad);
            rs = pst.executeQuery();

            if (rs.next()) {
                nombreEspecialidadMod = rs.getString("nombre_especialidad");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= isEdit ? "Editar" : "Agregar"%> Especialidad</title>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Especialidad Médica" : "Nueva Especialidad Médica"%></h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="">
                                <% if (isEdit) {%>
                                <input type="hidden" name="id" value="<%= idEspecialidad%>">
                                <% }%>

                                <div class="mb-3">
                                    <label for="nombreEspecialidad" class="form-label">Nombre de la Especialidad</label>
                                    <input type="text" class="form-control" id="nombreEspecialidad" name="nombreEspecialidad" 
                                           value="<%= nombreEspecialidadMod%>" required
                                           placeholder="Ej: Cardiología, Pediatría, etc.">
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="especialidades.jsp" class="btn btn-danger">Cancelar</a>
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
    </body>
</html>