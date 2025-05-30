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

# Paso 1: Descargar el código fuente de Nagios
RUN wget --user-agent="Mozilla/5.0" -O nagioscore-4.5.9.tar.gz "https://github.com/NagiosEnterprises/nagioscore/archive/refs/tags/nagios-4.5.9.tar.gz"

# Paso 2: Verificar que el archivo está descargado
RUN ls -lh /tmp

# Paso 3: Descomprimir el código fuente
RUN tar zxvf nagioscore-4.5.9.tar.gz && ls -lh /tmp

# Paso 4: Crear usuario y grupo necesarios para la instalación
RUN useradd -m -s /bin/bash nagios

# Paso 5: Compilar e instalar Nagios
RUN cd nagioscore-nagios-4.5.9 && \
    ./configure --with-httpd-conf=/etc/apache2/sites-enabled && \
    make all && \
    make install && \
    make install-init && \
    make install-commandmode && \
    make install-config && \
    make install-webconf

# Paso 6: Crear usuario de acceso web
RUN htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagiosadmin

# Paso 7: Habilitar CGI en Apache
RUN a2enmod cgi

# Exponer puerto 80
EXPOSE 80

# Comando de inicio
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

