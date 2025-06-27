
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Variables para modo edición
    boolean isEdit = false;
    int idMedico = 0;
    if (request.getParameter("id") != null) {
        isEdit = true;
        idMedico = Integer.parseInt(request.getParameter("id"));
    }

    // Procesar formulario
    if (request.getParameter("submit") != null) {
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String especialidad = request.getParameter("id_especialidad");
        String telefono = request.getParameter("telefono");

        Connection con = null;
        PreparedStatement pst = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

            if (isEdit) {
                // Consulta UPDATE para modificación
                pst = con.prepareStatement("UPDATE medicos SET nombre_medico=?, apellido_medico=?, id_especialidad=?, telefono_medico=? WHERE id_medico=?");
                pst.setString(1, nombre);
                pst.setString(2, apellido);
                pst.setString(3, especialidad);
                pst.setString(4, telefono);
                pst.setInt(5, idMedico);
            } else {
                // Consulta INSERT para nuevo registro
                pst = con.prepareStatement("INSERT INTO medicos(nombre_medico, apellido_medico, id_especialidad, telefono_medico) VALUES (?,?,?,?)");
                pst.setString(1, nombre);
                pst.setString(2, apellido);
                pst.setString(3, especialidad);
                pst.setString(4, telefono);
            }

            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
                String message = isEdit ? "Médico actualizado correctamente" : "Médico guardado correctamente";
%>
<script>
    alert("<%= message%>");
    window.location.href = "medicos.jsp";
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
    String nombreMod = "";
    String apellidoMod = "";
    String especialidadMod = "";
    String telefonoMod = "";

    if (isEdit) {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
            pst = con.prepareStatement("SELECT * FROM medicos WHERE id_medico = ?");
            pst.setInt(1, idMedico);
            rs = pst.executeQuery();

            if (rs.next()) {
                nombreMod = rs.getString("nombre_medico");
                apellidoMod = rs.getString("apellido_medico");
                especialidadMod = rs.getString("id_especialidad");
                telefonoMod = rs.getString("telefono_medico");
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
        <title><%= isEdit ? "Editar" : "Agregar"%> Médico</title>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Datos del Médico" : "Nuevo Médico"%></h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="nombre" class="form-label">Nombre del médico</label>
                                        <input type="text" class="form-control" id="nombre" name="nombre" 
                                               value="<%= nombreMod%>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="apellido" class="form-label">Apellido del médico</label>
                                        <input type="text" class="form-control" id="apellido" name="apellido" 
                                               value="<%= apellidoMod%>" required>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <%
                                        // Conexión a la base de datos para obtener especialidades
                                        Connection conEspecialidades = null;
                                        Statement stmt = null;
                                        ResultSet rsEspecialidades = null;

                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            conEspecialidades = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
                                            stmt = conEspecialidades.createStatement();
                                            rsEspecialidades = stmt.executeQuery("SELECT id_especialidad, nombre_especialidad FROM especialidades ORDER BY nombre_especialidad");
                                    %>
                                    <div class="col-md-6">
                                        <label for="id_especialidad" class="form-label">Especialidad del médico</label>
                                        <select class="form-select" id="id_especialidad" name="id_especialidad" required>
                                            <option value="" <%= especialidadMod.isEmpty() ? "selected disabled" : ""%>>Seleccione una especialidad</option>
                                            <%
                                                while (rsEspecialidades.next()) {
                                                    String selected = rsEspecialidades.getString("id_especialidad").equals(especialidadMod) ? "selected" : "";
                                                    out.println("<option value='" + rsEspecialidades.getInt("id_especialidad") + "' " + selected + ">"
                                                            + rsEspecialidades.getString("nombre_especialidad") + "</option>");
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <%
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsEspecialidades != null) {
                                                rsEspecialidades.close();
                                            }
                                            if (stmt != null) {
                                                stmt.close();
                                            }
                                            if (conEspecialidades != null) {
                                                conEspecialidades.close();
                                            }
                                        }
                                    %>

                                    <div class="col-md-6">
                                        <label for="telefono" class="form-label">Teléfono del médico</label>
                                        <input type="tel" class="form-control" id="telefono" name="telefono"
                                               value="<%= telefonoMod%>" required>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="medicos.jsp" class="btn btn-danger">Cancelar</a>
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
                // Validar el teléfono
                const telefonoInput = document.getElementById('telefono');
                if (telefonoInput) {
                    telefonoInput.addEventListener('input', function () {
                        // Eliminar cualquier caracter que no sea número
                        this.value = this.value.replace(/[^0-9]/g, '');

                        // Limitar a 9 caracteres
                        if (this.value.length > 9) {
                            this.value = this.value.slice(0, 9);
                        }
                    });
                }
            });
        </script>
    </body>
</html>
