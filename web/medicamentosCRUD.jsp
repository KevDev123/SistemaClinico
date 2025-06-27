
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Variables para modo edición
    boolean isEdit = false;
    int idMedicamento = 0;
    if (request.getParameter("id") != null) {
        isEdit = true;
        idMedicamento = Integer.parseInt(request.getParameter("id"));
    }

    // Obtener fecha actual en formato YYYY-MM-DD
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaActual = sdf.format(new Date());

    // Procesar formulario
    if (request.getParameter("submit") != null) {
        String nombre = request.getParameter("nombre");
        String viaTransmision = request.getParameter("viaTransmision");
        String fechaVencimiento = request.getParameter("fechaVencimiento");
        String cantidadDisponible = request.getParameter("cantidadDisponible");

        Connection con = null;
        PreparedStatement pst = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

            if (isEdit) {
                // Consulta UPDATE para modificación
                pst = con.prepareStatement("UPDATE medicamentos SET nombre_medicamento=?, via_transmision=?, fecha_vencimiento=?, cantidad_disponible=? WHERE id_medicamento=?");
                pst.setString(1, nombre);
                pst.setString(2, viaTransmision);
                pst.setString(3, fechaVencimiento);
                pst.setInt(4, Integer.parseInt(cantidadDisponible));
                pst.setInt(5, idMedicamento);
            } else {
                // Consulta INSERT para nuevo registro
                pst = con.prepareStatement("INSERT INTO medicamentos(nombre_medicamento, via_transmision, fecha_vencimiento, cantidad_disponible) VALUES (?,?,?,?)");
                pst.setString(1, nombre);
                pst.setString(2, viaTransmision);
                pst.setString(3, fechaVencimiento);
                pst.setInt(4, Integer.parseInt(cantidadDisponible));
            }

            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
                String message = isEdit ? "Medicamento actualizado correctamente" : "Medicamento guardado correctamente";
%>
<script>
    alert("<%= message%>");
    window.location.href = "medicamentos.jsp";
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
    String viaTransmisionMod = "";
    String fechaVencimientoMod = "";
    String cantidadDisponibleMod = "";

    if (isEdit) {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");
            pst = con.prepareStatement("SELECT * FROM medicamentos WHERE id_medicamento = ?");
            pst.setInt(1, idMedicamento);
            rs = pst.executeQuery();

            if (rs.next()) {
                nombreMod = rs.getString("nombre_medicamento");
                viaTransmisionMod = rs.getString("via_transmision");
                fechaVencimientoMod = rs.getString("fecha_vencimiento");
                cantidadDisponibleMod = rs.getString("cantidad_disponible");
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
        <title><%= isEdit ? "Editar" : "Agregar"%> Medicamento</title>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Datos del Medicamento" : "Nuevo Medicamento"%></h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="">
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre del Medicamento</label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                           value="<%= nombreMod%>" required>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="viaTransmision" class="form-label">Vía de Administración</label>
                                        <select class="form-select" id="viaTransmision" name="viaTransmision" required>
                                            <option value="" <%= viaTransmisionMod.isEmpty() ? "selected disabled" : ""%>>Seleccionar...</option>
                                            <option value="Oral" <%= "Oral".equals(viaTransmisionMod) ? "selected" : ""%>>Oral</option>
                                            <option value="Intravenosa" <%= "Intravenosa".equals(viaTransmisionMod) ? "selected" : ""%>>Intravenosa</option>
                                            <option value="Intramuscular" <%= "Intramuscular".equals(viaTransmisionMod) ? "selected" : ""%>>Intramuscular</option>
                                            <option value="Subcutánea" <%= "Subcutánea".equals(viaTransmisionMod) ? "selected" : ""%>>Subcutánea</option>
                                            <option value="Tópica" <%= "Tópica".equals(viaTransmisionMod) ? "selected" : ""%>>Tópica</option>
                                            <option value="Inhalatoria" <%= "Inhalatoria".equals(viaTransmisionMod) ? "selected" : ""%>>Inhalatoria</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="fechaVencimiento" class="form-label">Fecha de Vencimiento</label>
                                        <input type="date" class="form-control" id="fechaVencimiento" name="fechaVencimiento" 
                                               min="<%= fechaActual%>"
                                               value="<%= fechaVencimientoMod%>" required="">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="cantidadDisponible" class="form-label">Cantidad Disponible</label>
                                    <input type="number" class="form-control" id="cantidadDisponible" name="cantidadDisponible" 
                                           min="0" step="1"
                                           value="<%= cantidadDisponibleMod.isEmpty() ? "0" : cantidadDisponibleMod%>">
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="medicamentos.jsp" class="btn btn-danger">Cancelar</a>
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
                // Valida que la cantidad disponible sean solo números positivos
                const cantidadInput = document.getElementById('cantidadDisponible');
                if (cantidadInput) {
                    cantidadInput.addEventListener('input', function () {
                        if (this.value < 0) {
                            this.value = 0;
                        }
                    });
                }
            });
        </script>
    </body>
</html>