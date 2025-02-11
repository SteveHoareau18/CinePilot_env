FROM node:22.11.0-alpine

FROM nginx:1.21.6-alpine

RUN apk add --no-cache openssh git
RUN echo "root:root" | chpasswd
RUN ssh-keygen -A
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

WORKDIR /home

RUN rm -rf CinePilot

RUN git clone https://github.com/SteveHoareau18/CinePilot

WORKDIR /home/CinePilot/front

RUN git pull

RUN echo "export FNM_DIR=/root/.local/share/fnm" >> /root/.bashrc
RUN echo "export PATH=/root/.local/share/fnm:/root/.local/share/fnm/node-versions/v18.20.5/installation/bin:$PATH" >> /root/.bashrc

COPY .env ./
COPY env.sh ./env.sh
RUN cat .env >> /root/.bashrc

RUN sh ./env.sh

EXPOSE 80 22 5173

CMD ["sh", "-c", "nginx -g 'daemon off;' & /usr/sbin/sshd -D"]