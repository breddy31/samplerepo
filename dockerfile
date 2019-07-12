#FROM alpine
#CMD echo "hello-world"

# This Dockerfile is used to build an image containing stuff to be used as stuff to be used as a Jenkins slave build node.
FROM ubuntu:trusty
# FROM webratio/java:7
# FROM frekele/java:jdk8


RUN apt-get update && apt-get install --yes wget curl sshpass iputils-ping xvfb zip vim unzip openssh-server git telnet
# RUN apt-get update && apt-get install -y git curl software-properties-common python-software-properties && add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk openjdk-7-jdk openjdk-6-jdk && rm -rf /var/lib/apt/lists/*


RUN locale-gen en_US.UTF-8 &&\
    apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends openssh-server &&\
    apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Installs Ant 
ENV ANT_VERSION 1.9.4 
# RUN cd && \
RUN wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
&& tar xzf apache-ant-${ANT_VERSION}-bin.tar.gz \
&& mv apache-ant-${ANT_VERSION} /opt/ant \
&& rm -f apache-ant-${ANT_VERSION}-bin.tar.gz
ENV ANT_HOME /opt/ant
ENV PATH ${PATH}:/opt/ant/bin

# RUN cd /

# #Certificates Installation
# RUN mkdir certificates
# RUN cd certificates

# #artifactory certificate
# RUN mkdir artifactorycert
# COPY ./artifactory.cer artifactorycert

# #ucd certificate
# RUN mkdir ucdcert
# COPY ./ucd.cer ucdcert

# #git certificate
# RUN mkdir gitcert
# COPY ./git.cer gitcert

# RUN cd /

# # RUN mv jiracert certificates \
# RUN mv artifactorycert certificates \
# && mv ucdcert certificates \
# && mv gitcert certificates

# #RUN cd $JAVA_HOME/jre/lib/security
# # RUN cd /
# WORKDIR /usr/lib/jvm/java-8-openjdk-amd64/lib/security
# RUN keytool -keystore cacerts -importcert -alias git1 -file /certificates/gitcert/git.cer -storepass changeit -noprompt
# # RUN keytool -keystore cacerts -importcert -alias jira1 -file /certificates/jiracert/jira.cer -storepass changeit -noprompt
# RUN keytool -keystore cacerts -importcert -alias ucd1 -file /certificates/ucdcert/ucd.cer -storepass changeit -noprompt
# RUN keytool -keystore cacerts -importcert -alias artifactory1 -file /certificates/artifactorycert/artifactory.cer -storepass changeit -noprompt


# # Get maven 3.3.9
# RUN wget --no-verbose -O /tmp/apache-maven-3.3.9-bin.tar.gz http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
# # Install maven
# RUN tar xzf /tmp/apache-maven-3.3.9-bin.tar.gz -C /opt/
# RUN ln -s /opt/apache-maven-3.3.9 /opt/maven
# RUN ln -s /opt/maven/bin/mvn /usr/local/bin
# RUN rm -f /tmp/apache-maven-3.3.9-bin.tar.gz
# ENV MAVEN_HOME /opt/maven 

# #Install Gradle
# RUN cd /usr/bin \
#  && wget https://downloads.gradle.org/distributions/gradle-3.4.1-bin.zip -o gradle-bin.zip \
#  && unzip "gradle-3.4.1-bin.zip" \
#  && ln -s "/usr/gradle-3.4.1/bin/gradle" /usr/bin/gradle \
#  && rm "gradle-bin.zip"

# #Env set up for Gradle
#  ENV GRADLE_HOME=usr/bin/gradle-3.4.1
#  #ENV PATH=$PATH:$GRADLE_HOME/bin:$PATH
#  ENV PATH=$PATH:$GRADLE_HOME/bin JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# #Install Node.js
# # RUN apt-get install --yes curl
# RUN curl --silent --location https://deb.nodesource.com/setup_4.x | sudo bash -
# RUN apt-get install --yes nodejs
# RUN apt-get install --yes build-essential

# #Env set up for nodejs
# ENV PATH="$PATH:/home/nodejs/bin"

# WORKDIR /opt

# #Install sonar-runner
# RUN wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip \
# && unzip sonar-runner-dist-2.4.zip && \
# rm sonar-runner-dist-2.4.zip
# # && mv sonar-runner-2.4 /opt/sonar-runner
# # ENV SONAR_RUNNER_HOME=sonar-runner-2.4/opt
# ENV PATH /opt/sonar-runner-2.4/bin:$PATH

# #ssh-keygen
# WORKDIR /root
# RUN ssh-keygen -t rsa -N '' -f id_rsa
# RUN  cat >> /root/authorized_keys -t /root/id_rsa.pub
# # RUN cd /root
# RUN mkdir .ssh && \
# mv id_rsa .ssh && \
# mv id_rsa.pub .ssh && \
# mv authorized_keys .ssh

RUN cd /
RUN curl -fsSL https://clis.ng.bluemix.net/install/linux | sh

# WORKDIR /

# Set user jenkins to the image
#RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
# RUN echo "root:root" | chpasswd

USER root

# Standard SSH port
EXPOSE 22 

# Default command
CMD ["/usr/sbin/sshd", "-D"]
