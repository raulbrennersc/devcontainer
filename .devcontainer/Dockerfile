FROM mcr.microsoft.com/devcontainers/base:debian

ARG ANDROID_STUDIO_USER=android

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
        build-essential git wget unzip sudo \
        libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
        libxrender1 libxtst6 libxi6 libfreetype6 libxft2 xz-utils acl\
        qemu-system qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils libnotify4 libglu1 libqt5widgets5 openjdk-17-jdk xvfb \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd -g 1001 -r $ANDROID_STUDIO_USER
RUN useradd -u 1001 -g 1001 --create-home -r $ANDROID_STUDIO_USER
RUN adduser $ANDROID_STUDIO_USER libvirt

RUN echo "$ANDROID_STUDIO_USER:$ANDROID_STUDIO_USER" | chpasswd
RUN echo "${ANDROID_STUDIO_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$ANDROID_STUDIO_USER
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-vscode
RUN usermod -aG sudo $ANDROID_STUDIO_USER
RUN usermod -aG plugdev $ANDROID_STUDIO_USER
RUN mkdir -p /androidstudio-data
VOLUME /androidstudio-data
RUN chown $ANDROID_STUDIO_USER:$ANDROID_STUDIO_USER /androidstudio-data

RUN mkdir -p /studio-data/Android/Sdk && \
    chown -R $ANDROID_STUDIO_USER:$ANDROID_STUDIO_USER /studio-data/Android

RUN mkdir -p /studio-data/profile/android && \
    chown -R $ANDROID_STUDIO_USER:$ANDROID_STUDIO_USER /studio-data/profile

COPY android-studio/start_android_studio.sh /usr/local/bin/start_android_studio.sh
RUN chmod +x /usr/local/bin/*

RUN chsh vscode -s $(which zsh)

USER vscode

WORKDIR /home/vscode

RUN mkdir -p .android
COPY android-studio/advancedFeatures.ini .android/advancedFeatures.ini

#Install google cloud cli
RUN wget https://sdk.cloud.google.com -O install.sh
RUN bash install.sh --disable-prompts
RUN rm -rf install.sh
RUN echo "source /home/vscode/google-cloud-sdk/path.zsh.inc" >> /home/vscode/.profile

#Install nvm
RUN wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh -O install.sh
RUN bash install.sh --no-use
RUN rm -rf install.sh

#Install android Studio
RUN wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.2.2.13/android-studio-2024.2.2.13-linux.tar.gz -O android-studio.tar.gz
RUN tar xzvf android-studio.tar.gz
RUN rm android-studio.tar.gz

#Set vars
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
ENV ANDROID_SDK_ROOT=/home/vscode/Android/Sdk
ENV ANDROID_HOME=/home/vscode/Android/Sdk
ENV PATH="$PATH:/home/vscode/Android/Sdk/platform-tools"
ENV DISPLAY=:0