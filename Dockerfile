FROM evarga/jenkins-slave
MAINTAINER jenskristianvilladsen@gmail.com
# remove openjdk
RUN apt remove -y openjdk*

# install git
RUN apt-get update
RUN apt-get install -y git wget
RUN apt-get install -y curl
RUN apt-get autoremove -y

ADD get_oracle_jdk_linux_x64.sh /

# Install Oracle JDK 8
RUN ./get_oracle_jdk_linux_x64.sh 8 tar.gz && \
    mkdir /opt/jdk8 && \
    tar -zxf jdk-8*.tar.gz --strip-components=1 -C /opt/jdk8 && \
    rm jdk-8*tar.gz
#    update-alternatives --install /usr/bin/java  java  /opt/jdk/jdk1.8.0_101/bin/java 100 && \
#    update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_101/bin/javac 100 && \
#    update-alternatives --install /usr/bin/jar   jar   /opt/jdk/jdk1.8.0_101/bin/jar 100
#    ln -s /opt/jdk/jdk1.8.0_101 /opt/jdk/latest

# Install Oracle JDK 9
RUN ./get_oracle_jdk_linux_x64.sh 9 tar.gz && \
    mkdir /opt/jdk9 && \
    tar -zxf jdk-9*.tar.gz --strip-components=1 -C /opt/jdk9 && \
    rm jdk-9*tar.gz

# Install maven 3.5.3
RUN wget -q http://mirrors.sonic.net/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz &&\
    tar -zxf apache-maven-3.5.3-bin.tar.gz &&\
    mv apache-maven-3.5.3 /usr/local &&\
    rm -f apache-maven-3.5.3-bin.tar.gz &&\
    ln -s /usr/local/apache-maven-3.5.3/bin/mvn /usr/bin/mvn &&\
    ln -s /usr/local/apache-maven-3.5.3 /usr/local/apache-maven

RUN echo "export JAVA_HOME=/opt/jdk8" >> ~/.bashrc
