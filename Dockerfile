FROM debian:12


ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    python3-pip \
    curl \
    gnupg \
    iproute2 \
    iputils-ping \
    nano \
    && curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd


RUN apt-get update && apt-get install -y ansible sshpass

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
