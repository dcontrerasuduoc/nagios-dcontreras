# Imagen base
FROM ubuntu:20.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    gcc \
    libc6 \
    make \
    wget \
    unzip \
    apache2 \
    php \
    libapache2-mod-php \
    libgd-dev \
    libssl-dev \
    bc \
    gawk \
    dc \
    build-essential \
    snmp \
    libnet-snmp-perl \
    gettext-base && \
    apt-get clean

# Establecer directorio de trabajo
WORKDIR /tmp

# Descargar el código fuente de Nagios
RUN wget --user-agent="Mozilla/5.0" -O nagioscore-4.5.9.tar.gz "https://github.com/NagiosEnterprises/nagioscore/archive/refs/tags/nagios-4.5.9.tar.gz"

# Verificar que el archivo está descargado
RUN ls -lh /tmp

# Descomprimir el código fuente
RUN tar zxvf nagioscore-4.5.9.tar.gz && ls -lh /tmp

# Crear usuario y grupo necesarios para la instalación
RUN useradd -m -s /bin/bash nagios

# Compilar e instalar Nagios
RUN cd nagioscore-nagios-4.5.9 && \
    ./configure --with-httpd-conf=/etc/apache2/sites-enabled && \
    make all && \
    make install && \
    make install-init && \
    make install-commandmode && \
    make install-config && \
    make install-webconf

# Deshabilitar el sitio default de Apache
RUN a2dissite 000-default.conf

# Asegurar que el site de Nagios quede habilitado
RUN a2ensite nagios.conf

# Ajustar permisos para Nagios
RUN chown -R www-data:www-data /usr/local/nagios/share /usr/local/nagios/sbin
RUN chmod -R 755 /usr/local/nagios/share /usr/local/nagios/sbin

# Ajustar configuración de Apache para permitir acceso con user/pass (sin 403)
RUN sed -i 's/Require all denied/Require valid-user/g' /etc/apache2/sites-enabled/nagios.conf

# Crear usuario de acceso web (usuario: nagiosadmin / contraseña: nagiosadmin)
RUN htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagiosadmin

# Habilitar CGI en Apache
RUN a2enmod cgi

# Verificar contenido de Nagios
RUN ls -l /usr/local/nagios/share

# Exponer puerto 80
EXPOSE 80

# Comando de inicio
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

