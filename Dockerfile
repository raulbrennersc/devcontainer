ARG VARIANT="bookworm"
FROM debian:${VARIANT}

ARG USERNAME="${USERNAME:-"dev"}"
ARG USER_UID="${USERUID:-"1000"}"
ARG USER_GID="${USER_GID:-"1000"}"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
  build-essential git wget unzip sudo curl locales locales-all xclip openssh-server vim\
  libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
  libxrender1 libxtst6 libxi6 libfreetype6 libxft2 xz-utils acl\
  qemu-system qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils libnotify4 libglu1 libqt5widgets5 openjdk-17-jdk xvfb \
  && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN groupadd --gid $USER_GID $USERNAME && \
  useradd -s /bin/bash --uid $USER_UID --gid $USERNAME -m $USERNAME --create-home && \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME

RUN adduser $USERNAME libvirt && adduser $USERNAME plugdev && adduser $USERNAME kvm

#Change ssh port
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
RUN sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config

#Set vars
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
ENV ANDROID_SDK_ROOT=/home/${USERNAME}/Android/Sdk
ENV ANDROID_SDK_HOME=/home/${USERNAME}/Android/Sdk
ENV ANDROID_HOME=/home/${USERNAME}/Android/Sdk
ENV PATH="$PATH:/home/${USERNAME}/google-cloud-sdk/bin:/home/${USERNAME}/Android/Sdk/platform-tools:/home/${USERNAME}/Android/Sdk/cmdline-tools/latest/bin:/home/${USERNAME}/Android/Sdk/emulator"
ENV DISPLAY=:0
ENV DEVCONTAINER=1
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN echo "ANDROID_EMULATOR_USE_SYSTEM_LIBS=$ANDROID_EMULATOR_USE_SYSTEM_LIBS" >> /etc/environment
RUN echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> /etc/environment
RUN echo "ANDROID_SDK_HOME=$ANDROID_SDK_HOME" >> /etc/environment
RUN echo "ANDROID_HOME=$ANDROID_HOME" >> /etc/environment
RUN echo "PATH=$PATH" >> /etc/environment
RUN echo "DISPLAY=$DISPLAY" >> /etc/environment
RUN echo "DEVCONTAINER=$DEVCONTAINER" >> /etc/environment
RUN echo "LANG=$LANG" >> /etc/environment
RUN echo "LANGUAGE=$LANGUAGE" >> /etc/environment
RUN echo "LC_ALL=$LC_ALL" >> /etc/environment

#Install docker
ENV DOCKERVERSION=28.0.1
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
  -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

#RUN curl -fsSL https://get.docker.com | bash -s && \
#  usermod -aG docker $USERNAME && \
#  newgrp docker

USER $USERNAME
WORKDIR /home/$USERNAME

RUN  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Install google cloud cli
RUN wget --progress=dot:giga https://sdk.cloud.google.com -O install.sh && \
  bash install.sh --disable-prompts && \
  rm -rf install.sh && \
  echo "source /home/${USERNAME}/google-cloud-sdk/path.bash.inc" >> /home/${USERNAME}/.bashrc

#Install nvm
RUN wget --progress=dot:giga https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh -O install.sh && \
  bash install.sh --no-use && \
  rm -rf install.sh

#Install android cmdline tools
RUN mkdir -p Android/Sdk/cmdline-tools .android .gradle .java

RUN wget --progress=dot:giga https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip && \
  unzip ./cmdline-tools.zip -d . && \
  mv cmdline-tools ./Android/Sdk/cmdline-tools/latest && \
  rm -rf ./cmdline-tools.zip

RUN wget --progress=dot:giga https://dl.google.com/android/repository/platform-tools-latest-linux.zip -O platform-tools.zip && \
  unzip ./platform-tools.zip -d ./Android/Sdk && \
  rm -rf ./platform-tools.zip

COPY android-studio/advancedFeatures.ini .android/advancedFeatures.ini
COPY scripts/start-container.sh start-container.sh

CMD ~/start-container.sh
