FROM ubuntu:latest

RUN apt update -y && apt upgrade -y && \
    apt install -y \
        git \
        openssh-server \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        wget \
        zip && \
    ssh-keygen -A && \
    mkdir /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    sed -i '/^UsePAM/d' /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd

RUN wget https://download.java.net/java/GA/jdk23.0.1/c28985cbf10d4e648e4004050f8781aa/11/GPL/openjdk-23.0.1_linux-x64_bin.tar.gz && \
    tar -xvzf openjdk-23.0.1_linux-x64_bin.tar.gz && \
    mkdir -p /usr/lib/jvm && \
    mv jdk-23.0.1 /usr/lib/jvm/ && \
    rm openjdk-23.0.1_linux-x64_bin.tar.gz

USER root

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

RUN apt-get install -y nodejs

WORKDIR /home

RUN rm -rf /home/CinePilot

RUN git clone https://github.com/SteveHoareau18/CinePilot

WORKDIR /home/CinePilot

WORKDIR /home/CinePilot/back/spring

RUN chmod +x ./gradlew

RUN echo "export JAVA_HOME=/usr/lib/jvm/jdk-23.0.1" >> /root/.bashrc
RUN echo "export PATH=/usr/lib/jvm/jdk-23.0.1/bin:$PATH" >> /root/.bashrc

RUN git pull

COPY .env ./
COPY env.sh ./env.sh
COPY app-token.sh ./app-token.sh
RUN cat .env >> /root/.bashrc

RUN sh ./env.sh
RUN sh ./app-token.sh

EXPOSE 22 8000

CMD ["/usr/sbin/sshd", "-D"]
