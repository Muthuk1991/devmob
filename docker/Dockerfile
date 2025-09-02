# ===================================================================================
# DevMob - React Native Development Environment (https://github.com/JMVilomet/devmob)
# ===================================================================================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ARG UID=1000
ARG GID=1000
ARG KVM_GID=104
ARG RENDER_GID=105
ARG NODE_VERSION=22.14
ARG SDK_VERSION=commandlinetools-linux-11076708_latest.zip
ARG ANDROID_BUILD_VERSION=36
ARG ANDROID_TOOLS_VERSION=36.0.0
ARG NDK_VERSION=27.1.12297006
ARG WATCHMAN_VERSION=4.9.0
ARG CMAKE_VERSION=3.30.5

ENV PYTHONIOENCODING=UTF-8
ENV REPO_OS_OVERRIDE=linux

# Adds user and group node
RUN groupadd --gid ${GID} node && \
    useradd --uid ${UID} --gid ${GID} --shell /bin/bash --create-home node 

# Define timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Set the locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV EXPO_NO_GIT_STATUS=1

# Java/Android environment
ENV ADB_INSTALL_TIMEOUT=10
ENV ANDROID_HOME=/opt/android
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/$NDK_VERSION
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV CMAKE_BIN_PATH=${ANDROID_HOME}/cmake/$CMAKE_VERSION/bin
ENV PATH=${CMAKE_BIN_PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${PATH}


# Set proper GPU environment
ENV LIBGL_ALWAYS_INDIRECT=0
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV MESA_GL_VERSION_OVERRIDE=3.3
ENV MESA_GLSL_VERSION_OVERRIDE=330
ENV __GLX_VENDOR_LIBRARY_NAME=mesa

# Create render group and add user to video, render, and kvm groups for GPU/KVM access
RUN groupadd -f -g ${RENDER_GID} render && \
    groupadd -f -g ${KVM_GID} kvm && \
    usermod -a -G video,render,kvm node

# Create and fix runtime directory permissions
RUN mkdir -p /tmp/runtime-1000 && \
    chmod 755 /tmp/runtime-1000 && \
    chown 1000:1000 /tmp/runtime-1000 && \
    chmod 1777 /tmp

# Install required packages for the system
RUN apt update -qq && apt install -qq -y --no-install-recommends \
        usbutils \
        iputils-ping \
        net-tools \ 
        netcat \
        apt-transport-https \
        curl \
        file \
        gcc \
        git \
        g++ \
        gnupg2 \
        libc++1-11 \
        libgl1 \
        libtcmalloc-minimal4 \
        make \
        openjdk-17-jdk-headless \
        openssh-client \
        patch \
        python3 \
        python3-distutils \
        rsync \
        ruby \
        ruby-dev \
        sudo \
        tzdata \
        unzip \
        ninja-build \
        zip \
        ccache \
        # Dev libraries requested by Hermes
        libicu-dev \
        # Dev dependencies required by linters
        jq \
        shellcheck \
    && gem install bundler && \
    # Add sudo permissions for node user after sudo is installed
    echo "node ALL=(ALL) NOPASSWD: /bin/chown, /usr/local/bin/npm, /usr/local/bin/node" >> /etc/sudoers

# Install locales
RUN apt-get update -y && \
    apt-get install -y locales && \
    sed -i -e "s/# ${LANG} UTF-8/${LANG} UTF-8/" /etc/locale.gen && \
    locale-gen

# Install X11 libraries
RUN apt-get update && apt-get install -y \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxrandr2 \
    libxss1 \
    libgconf-2-4 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libnss3 \
    libdrm2 \
    libxkbcommon0 \
    libxkbfile1 \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    mesa-utils-extra \
    libgl1-mesa-dev \
    libglx-mesa0 \
    libglu1-mesa \
    libglu1-mesa-dev \
    xserver-xorg-video-dummy \
    x11-xserver-utils \
    libpulse0 \
    libpulse-dev \
    pulseaudio-utils \
    # Add Qt and XCB libraries for emulator GUI
    libxcb1 \
    libxcb-cursor0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-sync1 \
    libxcb-util1 \
    libxcb-xfixes0 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    qt5-gtk-platformtheme \
    libvulkan1 \
    mesa-vulkan-drivers 

# install nodejs using n
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n \
    && bash n $NODE_VERSION \
    && rm n \
    && npm install -g n 

# download and install android files
RUN curl -sS https://dl.google.com/android/repository/${SDK_VERSION} -o /tmp/sdk.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && unzip -q -d ${ANDROID_HOME}/cmdline-tools /tmp/sdk.zip \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm /tmp/sdk.zip \
    && yes | sdkmanager --licenses \
    && yes | sdkmanager "platform-tools" \
        "extras;google;instantapps" \
        "emulator" \
        "cmake;$CMAKE_VERSION" \
        "ndk;$NDK_VERSION" \
    && rm -rf ${ANDROID_HOME}/.android \
    && chmod 777 -R ${ANDROID_HOME} 

# Cleaning
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y --purge

WORKDIR /src
RUN chown -R ${UID}:${GID} /src

ADD ./docker/init_container.sh /usr/local/bin/init_container.sh
RUN chmod +x /usr/local/bin/init_container.sh

CMD ["/usr/local/bin/init_container.sh"]