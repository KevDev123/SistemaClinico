
<%@page import="interfaces.IGenericoDAO"%>
<%@page import="model.Medicamento"%>
<%@page import="dao.MedicamentoDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
       // Cargar datos si es modificación
    String nombreMod = "";
    String viaTransmisionMod = "";
    String fechaVencimientoMod = "";
    String cantidadDisponibleMod = "";
    
    
    // Variables para modo edición
    boolean isEdit = false;
    int idMedicamento = 0;
    
    if (request.getParameter("id") != null) {
        isEdit = true;
        idMedicamento = Integer.parseInt(request.getParameter("id"));
    }
    
    if(isEdit){
        IConexion c = new ConexionBD();
        IGenericoDAO<Medicamento> dao = new MedicamentoDAO(c);
        Medicamento medicamento = dao.enviarDatosID(idMedicamento);
        
        nombreMod = medicamento.getNombre();
        viaTransmisionMod = medicamento.getViaTransmision();
        fechaVencimientoMod = medicamento.getFecha();
        cantidadDisponibleMod = String.valueOf(medicamento.getCantidad());
        
    }
    

    // Obtener fecha actual en formato YYYY-MM-DD
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaActual = sdf.format(new Date());
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
                            <form method="post" action="MedicamentoServlet">
                                 <% if (isEdit){%>
                                <input type="hidden" name="id" value="<%= idMedicamento%>">
                                <% }%>
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