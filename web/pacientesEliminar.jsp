
<%@page import="interfaces.IConexion"%>
<%@page import="model.ConexionBD"%>
<%@page import="dao.PacienteDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    IConexion con = new ConexionBD();
    PacienteDAO paciente = new PacienteDAO(con);
    paciente.eliminar(Integer.parseInt(id));
%>
<script>
    alert("Paciente eliminado");
    window.location.href = "pacientes.jsp";
</script>    
<!DOCTYPE html>
<html>
    <head>
        <title>Eliminar Paciente</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
    </body>
</html>
