# Use an official Alpine as a parent image
FROM alpine:3.20

# Add maintainer label
LABEL maintainer="Muhammad Ayub Alfathoni <alfathmas24@gmail.com>"

# Install necessary packages, including OpenSSH server and client, sudo, and vim
RUN apk update && apk add --no-cache \
    openssh-server \
    openssh-client \
    sudo \
    vim \
    && mkdir /var/run/sshd

# Set the root password
RUN echo "root:root" | chpasswd

# Allow password-based authentication for SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Optional: Disable strict host checking (useful for testing)
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Expose SSH port
EXPOSE 22

# Set the password at runtime and start SSHD
CMD ssh-keygen -A && /usr/sbin/sshd -D