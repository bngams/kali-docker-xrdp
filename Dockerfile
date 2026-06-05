FROM kalilinux/kali-rolling

RUN apt-get update
RUN apt-get full-upgrade -y

RUN apt-get install -y kali-desktop-xfce xorg xrdp

RUN sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini

EXPOSE 3390

RUN apt-get install -y supervisor

COPY xrdp.conf /etc/supervisor/conf.d/xrdp.conf

# Create user script that will use environment variables
COPY create-user.sh /usr/local/bin/create-user.sh
RUN chmod +x /usr/local/bin/create-user.sh

# Add kali user to sudoers
RUN usermod -aG sudo kali && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

CMD ["/bin/bash", "-c", "/usr/local/bin/create-user.sh && supervisord -n -c /etc/supervisor/supervisord.conf"]

