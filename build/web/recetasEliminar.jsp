
<%@page import="dao.RecetaDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    IConexion con = new ConexionBD();
    RecetaDAO receta = new RecetaDAO(con);
    receta.eliminar(Integer.parseInt(id));
%>
<script>
    alert("Receta eliminada");
    window.location.href = "recetas.jsp";
</script>    
<!DOCTYPE html>
<html>
    <head>
        <title>Eliminar Receta</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
    </body>
</html>
