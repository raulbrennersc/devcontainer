ARG VARIANT="trixie"
FROM debian:${VARIANT}

ARG USERNAME="dev"
ARG USER_UID="1000"
ARG USER_GID="1000"

RUN apt-get update && apt-get install -y build-essential git wget unzip sudo curl \
  locales locales-all xclip openssh-server vim xz-utils acl ca-certificates gnupg\
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN groupadd --gid $USER_GID $USERNAME && \
  useradd -s /bin/bash --uid $USER_UID --gid $USERNAME -m $USERNAME --create-home && \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME

# Change ssh port
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config \
    && sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config

#Set vars
ENV DEVCONTAINER=1
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV PATH="$PATH:/home/${USERNAME}/google-cloud-sdk/bin"
ENV DISPLAY=:0

RUN echo "PATH=$PATH" >> /etc/environment && \
    echo "DEVCONTAINER=$DEVCONTAINER" >> /etc/environment && \
    echo "LANG=$LANG" >> /etc/environment && \
    echo "LANGUAGE=$LANGUAGE" >> /etc/environment && \
    echo "LC_ALL=$LC_ALL" >> /etc/environment

# Install docker
RUN curl -fsSL https://get.docker.com | bash -s

# Install google cloud cli
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-cli -y

USER $USERNAME
WORKDIR /home/$USERNAME

# Install Homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# RUN wget --progress=dot:giga https://sdk.cloud.google.com -O install.sh
# RUN bash install.sh --disable-prompts
# RUN rm -rf install.sh
# RUN echo "source /home/${USERNAME}/google-cloud-sdk/path.bash.inc" >> /home/${USERNAME}/.bashrc

#Install nvm
RUN wget --progress=dot:giga https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh -O install.sh && \
  bash install.sh --no-use && \
  rm -rf install.sh

COPY scripts/start-container.sh start-container.sh

RUN echo "source /etc/environment" >> .bash_profile && \
    echo "source ~/.bashrc" >> .bash_profile && \
    echo "sudo chown ${USERNAME}:${USERNAME} /var/run/docker.sock 2>/dev/null || true" >> .bash_profile

CMD ["/bin/bash", "/home/dev/start-container.sh"]
