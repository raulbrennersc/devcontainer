ARG VARIANT="trixie"
FROM debian:${VARIANT}

ARG USERNAME="dev"
ARG USER_UID="1000"
ARG USER_GID="1000"

RUN apt-get update && apt-get install -y build-essential git wget unzip sudo curl \
  locales locales-all xclip openssh-server xz-utils acl ca-certificates gnupg chromium \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME && \
  useradd -s /bin/bash --uid $USER_UID --gid $USERNAME -m $USERNAME --create-home && \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME

# Create the Nix storage directory and grant ownership to the dev user
RUN mkdir -m 0755 /nix && chown ${USERNAME}:${USERNAME} /nix

# Change ssh port configurations
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config \
    && sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config

# Set runtime environment variables
ENV DEVCONTAINER=1
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV DISPLAY=:0

# Inject Nix profiles into system-wide PATH right away
ENV PATH="/home/${USERNAME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

RUN echo "PATH=$PATH" >> /etc/environment && \
    echo "DEVCONTAINER=$DEVCONTAINER" >> /etc/environment && \
    echo "LANG=$LANG" >> /etc/environment && \
    echo "LANGUAGE=$LANGUAGE" >> /etc/environment && \
    echo "LC_ALL=$LC_ALL" >> /etc/environment

# Install Docker engine
RUN curl -fsSL https://get.docker.com | bash -s

# Switch to the container user to install Nix safely in single-user mode
USER $USERNAME
WORKDIR /home/$USERNAME

# Install the Nix package manager
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

RUN mkdir -p /home/${USERNAME}/.config/nix && \
    echo "experimental-features = nix-command flakes" > /home/${USERNAME}/.config/nix/nix.conf

#Install nvm
RUN wget --progress=dot:giga https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh -O install.sh && \
  bash install.sh --no-use && \
  rm -rf install.sh

COPY scripts/start-container.sh start-container.sh

CMD ["/bin/bash", "/home/dev/start-container.sh"]
