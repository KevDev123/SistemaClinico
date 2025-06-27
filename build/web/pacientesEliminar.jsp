
<%@page import="dao.PacienteDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    PacienteDAO paciente = new PacienteDAO();
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
