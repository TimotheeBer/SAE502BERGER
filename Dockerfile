# Utilisation de l'image officielle Debian 12
FROM debian:12

# Éviter les interactions lors des installations
ENV DEBIAN_FRONTEND=noninteractive

# 1. Installation des paquets de base, SSH, Python et Client Docker
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
    # Installation du client Docker (nécessaire pour le nœud env_builder)
    && curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Configuration SSH
RUN mkdir /var/run/sshd
# Autoriser l'accès root (dans un contexte de lab uniquement !)
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# Fix pour éviter la déconnexion immédiate
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# 3. Installation d'Ansible (Uniquement utile pour le control_node, mais simplifie l'image unique)
RUN apt-get update && apt-get install -y ansible sshpass

# 4. Exposition du port SSH
EXPOSE 22

# 5. Démarrage du service SSH au lancement du conteneur
CMD ["/usr/sbin/sshd", "-D"]
