FROM ubuntu:latest

RUN apt update -y && apt upgrade -y && \
    apt install -y \
        git \
        openssh-server \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        wget && \
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

ENV JAVA_HOME=/usr/lib/jvm/jdk-23.0.1
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN export JAVA_HOME=/usr/lib/jvm/jdk-23.0.1

WORKDIR /home

RUN rm -rf /home/CinePilot

RUN git clone https://github.com/SteveHoareau18/CinePilot

WORKDIR /home/CinePilot

RUN git pull

WORKDIR /home/CinePilot/back/spring

RUN chmod +x ./gradlew

RUN ./gradlew wrapper --gradle-version=8.10.1

ARG GIT_USER
ARG GIT_EMAIL
ARG GIT_PASSWORD

RUN git config --global user.email "$GIT_EMAIL" && \
    git config --global user.name "$GIT_USER"

RUN git config --global credential.helper 'store' && \
    echo "https://${GIT_USER}:${GIT_PASSWORD}@github.com" > ~/.git-credentials

EXPOSE 22 8000

CMD ["/usr/sbin/sshd", "-D"]
