
<%@page import="java.util.Map"%>
<%@page import="model.Medico"%>
<%@page import="dao.MedicoDAO"%>
<%@page import="interfaces.IConexion"%>
<%@page import="model.ConexionBD"%>
<%@page import="model.ConexionBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
    
    // Cargar datos si es modificación
    String nombreMod = "";
    String apellidoMod = "";
    int idEspecialidadMod = 0;
    String especialidadMod = "";
    String telefonoMod = "";
    
    // Variables para modo edición
    boolean isEdit = false;
    int idMedico = 0;
    if (request.getParameter("id") != null) {
        isEdit = true;
        idMedico = Integer.parseInt(request.getParameter("id"));
    }

    IConexion con = new ConexionBD();
    MedicoDAO dao = new MedicoDAO(con);
    Medico me = dao.enviarDatosID(idMedico);
    
    
    //Cargar datos si es modificacion 
    nombreMod = me.getNombre();
    apellidoMod = me.getApellido();    
    telefonoMod = me.getTelefono();
    idEspecialidadMod = me.getEspecialidad();
    especialidadMod = me.getNombreEspecialidad();
    
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
                            <form method="post" action="MedicoServlet">
                                 <% if (isEdit) {%>
                                <input type="hidden" name="id" value="<%= idMedico%>">
                                <% }%>
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
                                                Map<Integer, String> resultado = dao.obtenerEspecialidades();
                                                
                                                for( Map.Entry<Integer, String> entry : resultado.entrySet()){
                                                    String selected = rsEspecialidades.getString("id_especialidad").equals(especialidadMod) ? "selected" : "";
                                                    out.println("<option value='" + entry.getKey() + "' " + selected + ">"
                                                            + entry.getValue() + "</option>");
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
