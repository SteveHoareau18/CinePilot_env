FROM ubuntu:latest

RUN apt update -y && apt upgrade -y
RUN apt install -y \
    git \
    openssh-server \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    openjdk-21-jdk

RUN ssh-keygen -A
RUN mkdir /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    sed -i '/^UsePAM/d' /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd

WORKDIR /home

RUN rm -rf CinePilot

RUN git clone https://github.com/SteveHoareau18/CinePilot

WORKDIR /home/CinePilot/back/spring

#RUN chmod +x ./mvnw

EXPOSE 22 8000

CMD /usr/sbin/sshd -D