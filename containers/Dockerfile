# SDM TEST Docker
#
# VERSION	1.0

FROM	ubuntu:14.04
MAINTAINER	Illyoung Choi <iychoi@email.arizona.edu>

##############################################
# Setup an account
##############################################
ENV HOME /home/syndicate

RUN useradd syndicate && echo 'syndicate:syndicate' | chpasswd && \
    echo "syndicate ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir /home/syndicate && \
    chown -R syndicate:syndicate $HOME

ENV USER syndicate

##############################################
# Setup utility packages
##############################################
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends \
    wget curl unzip python-pip build-essential autoconf capnproto libcapnp-dev libcapnp-0.4.0 libglib2.0-dev libcurl4-gnutls-dev \
    libgsl0ldbl libgsl0-dev gsl-bin zlib1g-dev zlib1g \
    ssh fuse git apt-transport-https pkg-config libfuse-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt /var/lib/cache /var/lib/log && \
    groupadd -f fuse && \
    usermod -aG fuse $USER


##############################################
# Setup Mash
##############################################
USER $USER
WORKDIR $HOME
RUN wget -O mash.zip https://github.com/marbl/Mash/archive/master.zip && \
    unzip mash.zip && \
    rm mash.zip && \
    mv Mash-master mash

WORKDIR mash
RUN ./bootstrap.sh
RUN ./configure --prefix=/usr --with-capnp=/usr && \
    sed -i 's/\/usr\/lib\/libcapnp.a/\/usr\/lib\/x86_64-linux-gnu\/libcapnp.a/' Makefile && \
    sed -i 's/\/usr\/lib\/libkj.a/\/usr\/lib\/x86_64-linux-gnu\/libkj.a/' Makefile && \
    make

USER root
RUN make install
WORKDIR $HOME

RUN rm -rf mash


##############################################
# Setup CurlFtpFS
##############################################
USER $USER
WORKDIR $HOME
RUN wget -O curlftpfs.zip https://github.com/JackSlateur/curlftpfs/archive/master.zip && \
    unzip curlftpfs.zip && \
    rm curlftpfs.zip && \
    mv curlftpfs-master curlftpfs

WORKDIR curlftpfs
RUN ./configure -- prefix=/usr && \
    make

USER root
RUN make install
WORKDIR $HOME

RUN rm -rf curlftpfs


##############################################
# Setup lFtpFS
##############################################
USER $USER
WORKDIR $HOME

# install cpanm
RUN curl -L http://cpanmin.us | perl - --sudo App::cpanminus
    cpanm --sudo Fuse.pm IPC/Run.pm

RUN wget -O lftpfs.tar.gz https://sourceforge.net/projects/lftpfs/files/lftpfs/lftpfs-0.4.3/lftpfs-0.4.3.tar.gz/download && \
    tar zxvf lftpfs.tar.gz && \
    rm lftpfs.tar.gz && \
    mv lftpfs-0.4.3 lftpfs

WORKDIR lftpfs
RUN perl Makefile.PL && \
    make

USER root
RUN make install
WORKDIR $HOME

RUN rm -rf lftpfs




USER $USER
