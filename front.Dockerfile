FROM node:22.11.0-alpine

FROM nginx:1.21.6-alpine

RUN apk add --no-cache openssh git
RUN echo "root:root" | chpasswd  # Remplacez 'password' par un mot de passe sécurisé
RUN ssh-keygen -A  # Génère les clés SSH par défaut
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

WORKDIR /home

RUN rm -rf CinePilot

RUN git clone https://github.com/SteveHoareau18/CinePilot

WORKDIR /home/CinePilot/front

EXPOSE 80 22 5173

CMD ["sh", "-c", "nginx -g 'daemon off;' & /usr/sbin/sshd -D"]