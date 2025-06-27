
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    Connection con;
    PreparedStatement pst;
    ResultSet rs;

    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

    pst = con.prepareStatement("delete from recetas where id_receta =?");
    pst.setString(1, id);
    pst.executeUpdate();
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
