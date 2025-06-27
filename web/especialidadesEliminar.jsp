
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    Connection con;
    PreparedStatement pst;
    ResultSet rs;

    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

    pst = con.prepareStatement("delete from especialidades where id_especialidad   =?");
    pst.setString(1, id);
    pst.executeUpdate();
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
