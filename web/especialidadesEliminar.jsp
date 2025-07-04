
<%@page import="dao.EspecialidadDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    
   IConexion con = new ConexionBD();
   EspecialidadDAO dao = new EspecialidadDAO(con);
   dao.eliminar(Integer.parseInt(id));
%>
<script>
    alert("Especialidad eliminada");
    window.location.href = "especialidades.jsp";
</script>    
<!DOCTYPE html>
<html>
    <head>
        <title>Eliminar Especialidad</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
    </body>
</html>
