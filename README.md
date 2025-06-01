Este entorno corresponde a la evaluación 2 de Tecnologias de Virtualización.

Profesor: Rodrigo Horacio Aguilar Gonzalez

Autor: Daniel Contreras Ulloa

Repositorio GitHub: https://github.com/dcontrerasuduoc/nagios-dcontreras

###############################################################################################################################################################################################

El entorno ya está desplegado completamente en mi cuenta de AWS.

Componentes implementados:

- Imagen personalizada de Nagios (Dockerfile incluido en el repositorio)
- Imagen subida al repositorio ECR: repo-nagios-dcontreras:latest
- Cluster ECS creado: nagios-dcontreras-cluster
- Service en ECS: nagios-dcontreras-service
- Application Load Balancer configurado para exponer el servicio
- Security Groups configurados (puerto 80 abierto)
- Tareas ECS desplegadas y en ejecución

###############################################################################################################################################################################################

Para probar el entorno:

Acceso a la raíz del ALB:

http://nagios-dcontreras-alb-1455426009.us-east-1.elb.amazonaws.com/

Acceso a Nagios:

http://nagios-dcontreras-alb-1455426009.us-east-1.elb.amazonaws.com/nagios/

Credenciales de acceso:

Usuario: nagiosadmin
Contraseña: nagiosadmin

###############################################################################################################################################################################################

Implementación:

Toda la infraestructura se encuentra completamente operativa: la imagen ha sido creada correctamente, subida a ECR, desplegada en ECS con ALB, y el ALB responde correctamente en su URL.

Se tiene acceso a la URL principal de Apache mediante el ALB, A Nagios da error 403 si se entra mediante el ALB, pero si se despliega el contenedor de manera local funciona el servicio sin problemas.

Para volver a desplegar la imagen en el ECR realice lo siguiente:

1. Clonar el repositorio:
git clone https://github.com/dcontrerasuduoc/nagios-dcontreras.git
cd nagios-dcontreras

2. Iniciar sesión en ECR:
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 356560291663.dkr.ecr.us-east-1.amazonaws.com

3. Construir la imagen:
docker build -t nagios-test:latest .

4. Taggear la imagen:
docker tag nagios-test:latest 356560291663.dkr.ecr.us-east-1.amazonaws.com/repo-nagios-dcontreras:latest

5. Subir la imagen:
docker push 356560291663.dkr.ecr.us-east-1.amazonaws.com/repo-nagios-dcontreras:latest

6. Finalmente, en la consola de AWS, en ECS → Service nagios-dcontreras-service → realizar un "Force new deployment" para que ECS tome la nueva imagen.
