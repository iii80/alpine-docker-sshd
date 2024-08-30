# Use an official Alpine as a parent image
FROM alpine:3.20

# Add maintainer label
LABEL maintainer="Muhammad Ayub Alfathoni <alfathmas24@gmail.com>"

# Install necessary packages, including OpenSSH and sudo
RUN apk update && apk add --no-cache \
    openssh-server \
    sudo \
    vim \
    && mkdir /var/run/sshd

# Set environment variables for the username and password
ENV SSH_USERNAME=root
ENV SSH_PASSWORD=root

# Create a new user with sudo privileges if it doesn't exist
RUN if ! id -u ${SSH_USERNAME} > /dev/null 2>&1; then \
        adduser -D ${SSH_USERNAME} && adduser ${SSH_USERNAME} wheel; \
    fi

# Allow password-based authentication for SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Optional: Disable strict host checking (useful for testing)
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Expose SSH port
EXPOSE 22

# Set the password at runtime
CMD ssh-keygen -A && echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd && /usr/sbin/sshd -D
