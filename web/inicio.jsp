
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio</title><style>
            .img-container {
                margin-bottom: 20px;
                text-align: center;
            }
            .img-container img {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }
            .img-container img:hover {
                transform: scale(1.05);
            }
            .img-caption {
                margin-top: 15px;
                font-size: 1.1rem;
                color: #333;
            }
            .main-container {
                padding: 30px 0;
                background-color: #f8f9fa;
                border-radius: 10px;
                margin-top: 30px;
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp" %>    
        <div class="container main-container">
            <div class="row">
                <h2 class="text-center mb-4">Sobre nosotros</h2>

                <div class="col-md-4 img-container">
                    <img src="img/Mision.png" class="img-fluid">
                    <div class="img-caption">
                        <h4>Misión</h4>
                        <p>Brindar atención médica integral de excelencia, con calidez humana y tecnología de vanguardia, 
                            para mejorar la calidad de vida de nuestros pacientes. Nos comprometemos a ofrecer un servicio 
                            personalizado, basado en valores éticos y profesionales, con un equipo médico altamente 
                            calificado que prioriza la prevención, diagnóstico preciso y tratamiento oportuno.</p>
                    </div>
                </div>

                <div class="col-md-4 img-container">
                    <img src="img/Vision.png" class="img-fluid">
                    <div class="img-caption">
                        <h4>Visión</h4>
                        <p>Ser reconocidos como la clínica líder en nuestro sector, destacando por nuestra innovación médica, 
                            estándares de calidad y enfoque centrado en el paciente. Aspiramos a crecer como una institución 
                            que combina la medicina humanizada con los avances tecnológicos, siendo referentes en investigación 
                            y formación continua para ofrecer siempre lo mejor a nuestra comunidad.</p>
                    </div>
                </div>

                <div class="col-md-4 img-container">
                    <img src="img/Nosotros.png" class="img-fluid">
                    <div class="img-caption">
                        <h4>¿Quiénes somos?</h4>
                        <p>Somos una clínica especializada con más de 25 años de experiencia, dedicada al cuidado de la salud 
                            con un enfoque multidisciplinario. Nuestro equipo está conformado por médicos certificados, 
                            enfermeras comprometidas y personal administrativo capacitado, todos unidos por la misma pasión: 
                            su bienestar.</p>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
