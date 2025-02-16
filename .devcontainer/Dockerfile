ARG VARIANT="bookworm"
FROM debian:${VARIANT}

ARG USERNAME="${USERNAME:-"dev"}"
ARG USER_UID="${USERUID:-"1000"}"
ARG USER_GID="${USER_GID:-"1000"}"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
        build-essential git wget unzip sudo curl \
        libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
        libxrender1 libxtst6 libxi6 libfreetype6 libxft2 xz-utils acl\
        qemu-system qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils libnotify4 libglu1 libqt5widgets5 openjdk-17-jdk xvfb \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN groupadd --gid $USER_GID $USERNAME
RUN useradd -s /bin/bash --uid $USER_UID --gid $USERNAME -m $USERNAME --create-home
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

#Install homebrew
RUN wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -O install.sh
RUN NONINTERACTIVE=1 bash install.sh
RUN rm -rf install.sh
RUN echo "eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> /home/${USERNAME}/.bashrc

#Install ruby
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install ruby@3.3

ENV PATH="/home/linuxbrew/.linuxbrew/opt/ruby@3.3/bin:$PATH"

#Install cocoapods
RUN gem install cocoapods

#Install bundler
RUN gem install bundler -v 2.5.9

#Install google cloud cli
RUN wget https://sdk.cloud.google.com -O install.sh
RUN bash install.sh --disable-prompts
RUN rm -rf install.sh
RUN echo "source /home/${USERNAME}/google-cloud-sdk/path.bash.inc" >> /home/${USERNAME}/.bashrc

#Install nvm
RUN wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh -O install.sh
RUN bash install.sh --no-use
RUN rm -rf install.sh

#Install android cmdline tools
RUN mkdir -p Android/Sdk/cmdline-tools
RUN mkdir -p .android

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip
RUN unzip ./cmdline-tools.zip -d .
RUN mv ./cmdline-tools/ ./Android/Sdk/cmdline-tools/latest
RUN rm -rf ./cmdline-tools.zip

RUN wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip -O platform-tools.zip
RUN unzip ./platform-tools.zip -d .
RUN mv ./platform-tools/ ./Android/Sdk/platform-tools
RUN rm -rf ./platform-tools.zip

COPY android-studio/advancedFeatures.ini .android/advancedFeatures.ini

#Set vars
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
ENV ANDROID_SDK_ROOT=/home/${USERNAME}/Android/Sdk
ENV ANDROID_HOME=/home/${USERNAME}/Android/Sdk
ENV PATH="$PATH:/home/${USERNAME}/google-cloud-sdk/bin:/home/${USERNAME}/Android/Sdk/platform-tools:/home/${USERNAME}/Android/Sdk/cmdline-tools/latest/bin"
ENV DISPLAY=:0
