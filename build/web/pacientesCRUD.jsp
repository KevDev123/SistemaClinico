

<%@page import="model.Paciente"%>
<%@page import="dao.PacienteDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <%
        
           String nombreMod = "";
           String apellidoMod = "";
           String fechaNacMod ="";
           String generoMod = "";
           String direccionMod = "";
           String telefonoMod = "";
           String detallesMod = "";
           
           
        // Variables para modo edición
        boolean isEdit = false;
        int idPaciente = 0;
        
        if (request.getParameter("id") != null) {
            isEdit = true;
            idPaciente = Integer.parseInt(request.getParameter("id"));
            
            PacienteDAO p = new PacienteDAO();
            Paciente pa = p.enviarDatosID(idPaciente);
                      
            
           // Cargar datos si es modificación
            nombreMod = pa.getNombre();
            apellidoMod = pa.getApellido();
            fechaNacMod = pa.getFechaNacimiento();
            generoMod = pa.getGenero();
            direccionMod = pa.getDireccion();
            telefonoMod = pa.getTelefono();
            detallesMod = pa.getDetalles();
        
        }
        
        // Obtener fecha actual en formato YYYY-MM-DD
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fechaMaxima = sdf.format(new Date());
        String message = isEdit ? "Paciente actualizado correctamente" : "Paciente guardado correctamente";
        
%>
    <head>
        <title><%= isEdit ? "Editar" : "Agregar"%> Paciente</title>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Datos del Paciente" : "Nuevo Paciente"%></h4>
                        </div>
                        <div class="card-body">
                        
                        <form method="post" action="PacienteServlet">
                                <% if (isEdit) {%>
                                <input type="hidden" name="id" value="<%= idPaciente%>">
                                <% }%>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="nombre" class="form-label">Nombre del paciente</label>
                                        <input type="text" class="form-control" id="nombre" name="nombre" 
                                               value="<%= nombreMod%>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="apellido" class="form-label">Apellido del paciente</label>
                                        <input type="text" class="form-control" id="apellido" name="apellido" 
                                               value="<%= apellidoMod%>" required>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
                                        <input type="date" class="form-control" id="fechaNacimiento" name="fechaNacimiento" 
                                               max="<%= fechaMaxima%>"
                                               value="<%= fechaNacMod%>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="genero" class="form-label">Género del paciente</label>
                                        <select class="form-select" id="genero" name="genero" required>
                                            <option value="" <%= generoMod.isEmpty() ? "selected disabled" : ""%>>Seleccionar...</option>
                                            <option value="Masculino" <%= "Masculino".equals(generoMod) ? "selected" : ""%>>Masculino</option>
                                            <option value="Femenino" <%= "Femenino".equals(generoMod) ? "selected" : ""%>>Femenino</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="direccion" class="form-label">Dirección</label>
                                    <textarea class="form-control" id="direccion" name="direccion" rows="2"><%= direccionMod%></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="telefono" class="form-label">Teléfono del paciente</label>
                                    <input type="tel" class="form-control" id="telefono" name="telefono" 
                                           value="<%= telefonoMod%>">
                                </div>

                                <div class="mb-3">
                                    <label for="detalles" class="form-label">Detalles</label>
                                    <textarea class="form-control" id="detalles" name="detalles" rows="2"><%= detallesMod%></textarea>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="pacientes.jsp" class="btn btn-danger">Cancelar</a>
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
                // Validar el telefono
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