# Base docker image
FROM ubuntu:18.04

LABEL maintainer="Mariana de Azevedo Santos <mariana@bsi.ufla.br>"

ENV USER=java11
ENV GUID=1000

ENV LANG=pt_BR.UTF-8
ENV JAVA_HOME /usr/java/oracle-java11
ENV PATH $JAVA_HOME/bin:$PATH

RUN apt-get update && apt-get -y upgrade && apt-get -y install sudo software-properties-common && add-apt-repository ppa:linuxuprising/java
RUN echo "oracle-java11-installer shared/accepted-oracle-license-v1-2 select true" | sudo debconf-set-selections && \
    apt-get install -y oracle-java11-installer --no-install-recommends \
    oracle-java11-set-default \
    libfreetype6 \
    fontconfig \
    && echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen \
	&& locale-gen \
	&& mkdir -p /home/${USER}   
    
RUN groupadd -g ${GUID} -r ${USER} \
	&& useradd -u ${GUID} -r -g ${USER} -G audio,video ${USER} -d /home/${USER} \
	&& chown -R ${GUID}:${GUID} /home/${USER} \
    && mkdir -p /etc/sudoers.d \
    && echo 'java11 ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
	&& echo 'Defaults !requiretty' >> /etc/sudoers \
    && echo root:java11 | chpasswd

USER java11

WORKDIR /home/java11/
