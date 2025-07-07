
<%@page import="model.Receta"%>
<%@page import="dao.ConsultaDAO"%>
<%@page import="dao.UtilDAO"%>
<%@page import="model.MedicamentoSelect"%>
<%@page import="dao.RecetaDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.ArrayList, java.util.List"%>
<%
    // Obtener parámetros de la URL
    String accion = request.getParameter("accion");
    boolean isEdit = "editar".equals(accion);

    
    //Instancias de clases que se utilizan
    IConexion con = new ConexionBD();
    UtilDAO util = new UtilDAO(con);
    ConsultaDAO consulta = new ConsultaDAO(con);
    List<MedicamentoSelect> medicamentos = util.obtenerMedicamentosParaSelect();
    
    
       // Variables para datos de la consulta
    int idReceta = 0;
    int idConsulta = 0;
    //arreglo para ids
    int [] ids = null;
    int idMedicamento = 0;
    int cantidad = 0;
 

    
    
    
    // Obtener ID de consulta (siempre presente)
    if (request.getParameter("idConsulta") != null) {
        idConsulta = Integer.parseInt(request.getParameter("idConsulta"));
        
        //Obtiene los ids de paciente y medico segun el id de la consulta
        ids = consulta.obtenerIdsPacienteYMedicoPorIdConsulta(idConsulta);
    }


 
    //devuelve el nombre del paciente y medico
    String nombrePacienteParam = util.obtenerNombrePacientePorId(ids[0]);
    String nombreMedicoParam = util.obtenerNombreMedicoPorId(ids[1]);
        
       // Verificar si es edición
    if (isEdit && request.getParameter("id") != null) {
        idReceta = Integer.parseInt(request.getParameter("id"));
          RecetaDAO receta = new RecetaDAO(con);  
          Receta rec = receta.enviarDatosID(idReceta);
          idMedicamento = rec.getIdMedicamento();
          cantidad = rec.getCantidad();
    
    }

    
  
  
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= isEdit ? "Editar" : "Agregar"%> Receta Médica</title>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Receta Médica" : "Nueva Receta Médica"%></h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="RecetaServlet">

                                
                                <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= idReceta %>">
                                <% } %>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Consulta</label>
                                     
                                        <input type="hidden" name="idConsulta" value="<%= idConsulta %>">                                 
                                        <input type="text" class="form-control"  
                                               value="Consulta #<%= idConsulta %> - <%= nombrePacienteParam %> / <%= nombreMedicoParam %>" 
                                               readonly>

                                </div>                                   

                                    <div class="col-md-6">
                                        <label for="idMedicamento" class="form-label">Medicamento</label>
                                        <select class="form-select" id="idMedicamento" name="idMedicamento" required>
                                            <option value="" selected disabled>Seleccione un medicamento</option>
                                            <% for(MedicamentoSelect m : medicamentos) {%>
                                            <option value="<%= m.getId() %>" 
                                                    <%= (isEdit && idMedicamento == m.getId()) ? "selected" : ""%>>
                                                <%= m.getNombreMedicamento() %>
                                            </option>
                                            <% }%>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="cantidad" class="form-label">Cantidad</label>
                                    <input type="number" class="form-control" id="cantidad" name="cantidad" 
                                           min="1" value="<%= cantidad == 0 ? "1" : cantidad%>" required>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                   <a href="<%= isEdit ? "recetas.jsp" : "consultas.jsp?id_paciente=" + ids[0] %>" class="btn btn-danger">Cancelar</a>
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
                // Validar la cantidad (mínimo 1)
                const cantidadInput = document.getElementById('cantidad');
                if (cantidadInput) {
                    cantidadInput.addEventListener('input', function () {
                        if (this.value < 1) {
                            this.value = 1;
                        }
                    });
                }
            });
        </script>
    </body>
</html>