# Base docker image
FROM ubuntu:18.04

LABEL maintainer="Mariana de Azevedo Santos <mariana@bsi.ufla.br>"

ENV USER=java11
ENV GUID=1000

ENV LANG=pt_BR.UTF-8
ENV JAVA_HOME /usr/java/oracle-java11
ENV PATH $JAVA_HOME/bin:$PATH

RUN add-apt-repository ppa:linuxuprising/java && \
    apt-get update && apt-get install -y --no-install-recommends \ 
    oracle-java11-installer \
    oracle-java11-set-default \
    freetype \
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
