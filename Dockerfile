FROM     ubuntu:16.04
MAINTAINER Claudiu Chiticariu Constatin <chiticariu@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux \
	ANDROID_SDK_ROOT=/opt/android-sdk-linux \
    NODE_VERSION=10.16.3 \
    IONIC_VERSION=5.2.7 \
    CORDOVA_VERSION=9.0.0

# Install basics
RUN apt-get update &&  \
    apt-get install -y git wget curl unzip ruby-full build-essential rubygems && \

    curl --retry 3 -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && \
    tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.gz" && \
    npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" && \
    npm cache verify && \

    gem install sass && \

    ionic start myApp sidemenu



#ANDROID
#JAVA

# install python-software-properties (so you can do add-apt-repository)
RUN apt-get update && apt-get install -y -q software-properties-common  && \

    add-apt-repository ppa:webupd8team/java -y && \
    echo openjdk-8-jdk shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && apt-get -y install openjdk-8-jdk


#ANDROID STUFF
RUN echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y expect ant wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Android SDK
#RUN cd /opt && \
#    wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
#    tar xzf android-sdk.tgz && \
#    rm -f android-sdk.tgz && \
#    chown -R root. /opt
	
RUN cd /opt && \
	mkdir -p android-sdk-linux && \
    curl -k https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -o sdk-tools-linux-3859397.zip && \
    unzip -q sdk-tools-linux-3859397.zip -d android-sdk-linux && \
    rm sdk-tools-linux-3859397.zip

# Setup environment

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:/opt/tools

# Show current directory
RUN pwd

# Install sdk elements
COPY tools /opt/tools

# RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter platform-tools,tools,build-tools-23.0.2,android-23,extra-android-support,extra-android-m2repository,extra-google-m2repository"]
# RUN ["/opt/tools/install_android_sdk_auto_accept_licenses.sh", "platform-tools,tools,build-tools-28.0.3,android-28,extra-android-support,extra-android-m2repository,extra-google-m2repository"]

# update sdkmanager
# RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --update
# install android sdk packages
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/tools/bin/sdkmanager 'build-tools;27.0.3' 'build-tools;28.0.3' platform-tools 'platforms;android-28' 'platforms;android-27' 'platforms;android-26' 'ndk-bundle'

# RUN unzip ${ANDROID_HOME}/temp/*.zip -d ${ANDROID_HOME}

# Install gradle
RUN apt-get update && apt-get install -y -q gradle

WORKDIR myApp
# EXPOSE 8100 35729
# CMD ["ionic", "serve"]