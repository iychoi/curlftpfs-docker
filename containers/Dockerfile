# SDM TEST Docker
#
# VERSION	1.0

FROM	ubuntu:14.04
MAINTAINER	Illyoung Choi <iychoi@email.arizona.edu>

##############################################
# Setup environment
##############################################
ENV LD_LIBRARY_PATH /usr/local/lib


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
    wget curl unzip python-pip build-essential autoconf \
    capnproto libcapnp-dev libcapnp-0.4.0 libglib2.0-dev libcurl4-gnutls-dev \
    libgsl0ldbl libgsl0-dev gsl-bin zlib1g-dev zlib1g capnproto \
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
#USER $USER
#WORKDIR $HOME

#RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
#    apt-get install -y --allow-unauthenticated --no-install-recommends \
#    lftp && \
#    apt-get clean autoclean && \
#    apt-get autoremove -y && \
#    rm -rf /var/lib/apt /var/lib/cache /var/lib/log

# install cpanm
#RUN curl -L http://cpanmin.us | perl - --sudo App::cpanminus

#RUN wget -O lftpfs.tar.gz https://sourceforge.net/projects/lftpfs/files/lftpfs/lftpfs-0.4.3/lftpfs-0.4.3.tar.gz/download && \
#    tar zxvf lftpfs.tar.gz && \
#    rm lftpfs.tar.gz && \
#    mv lftpfs-0.4.3 lftpfs

#WORKDIR lftpfs
#RUN perl Makefile.PL && \
#    make

#USER root
#RUN make install
#WORKDIR $HOME
#RUN rm -rf lftpfs

#RUN cpanm IPC/Run.pm
#RUN cpanm --notest Fuse.pm


##############################################
# iRODS-FUSE
##############################################
WORKDIR $HOME
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends \
    irods-dev irods-runtime \
    irods-externals-cmake3.5.2 irods-externals-clang3.8-0 irods-externals-cppzmq4.1-0 \
    irods-externals-libarchive3.1.2-0 irods-externals-avro1.7.7-0 irods-externals-boost1.60.0-0 \
    irods-externals-clang-runtime3.8-0 irods-externals-jansson2.7-0 irods-externals-zeromq4-14.1.3-0 \
    irods-icommands libxml2 && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt /var/lib/cache /var/lib/log

USER $USER
RUN wget -O irods_client_fuse.zip https://github.com/irods/irods_client_fuse/archive/master.zip && \
    unzip irods_client_fuse.zip && \
    rm irods_client_fuse.zip && \
    mv irods_client_fuse-master irods_client_fuse

WORKDIR irods_client_fuse
ENV LD_LIBRARY_PATH /opt/irods-externals/clang-runtime3.8-0/lib/
ENV PATH $PATH:/opt/irods-externals/cmake3.5.2-0/bin
RUN cmake . && \
    make

USER root
WORKDIR $HOME


##############################################
# fskit
##############################################
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends \
    libfuse-dev libattr1-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt /var/lib/cache /var/lib/log

USER $USER
RUN wget -O fskit.zip https://github.com/iychoi/fskit/archive/master.zip && \
    unzip fskit.zip && mv fskit-master fskit
WORKDIR "fskit"
RUN make

USER root
RUN make install && ldconfig

WORKDIR $HOME


##############################################
# syndicate
##############################################
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends \
    protobuf-compiler libprotobuf-dev libgnutls-dev libjson0-dev valgrind \
    cython python-protobuf libssl-dev libgcrypt11-dev libcurl4-gnutls-dev \
    libevent-dev python-crypto python-requests python-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt /var/lib/cache /var/lib/log && \
    pip install -v greenlet gevent==1.2.2 grequests

###### libmicrohttpd (0.9.44)
RUN wget https://butler.opencloud.cs.arizona.edu/stopgap/libmicrohttpd-dbg_0.9.44+dfsg-1ubuntu2_amd64.deb && \
    wget https://butler.opencloud.cs.arizona.edu/stopgap/libmicrohttpd-dev_0.9.44+dfsg-1ubuntu2_amd64.deb && \
    wget https://butler.opencloud.cs.arizona.edu/stopgap/libmicrohttpd10_0.9.44+dfsg-1ubuntu2_amd64.deb && \
    dpkg -i libmicrohttpd-dbg_0.9.44+dfsg-1ubuntu2_amd64.deb libmicrohttpd-dev_0.9.44+dfsg-1ubuntu2_amd64.deb libmicrohttpd10_0.9.44+dfsg-1ubuntu2_amd64.deb && \
    apt-get -f install && \
    rm libmicrohttpd-dbg_0.9.44+dfsg-1ubuntu2_amd64.deb libmicrohttpd-dev_0.9.44+dfsg-1ubuntu2_amd64.deb libmicrohttpd10_0.9.44+dfsg-1ubuntu2_amd64.deb

USER $USER
WORKDIR $HOME

###### syndicate-core
RUN wget -O syndicate-core.zip https://github.com/iychoi/syndicate-core/archive/master.zip && \
    unzip syndicate-core.zip && mv syndicate-core-master syndicate-core
WORKDIR "syndicate-core"

RUN make MS_APP_ADMIN_EMAIL="iychoi@email.arizona.edu" MS_APP_PUBLIC_HOST="localhost"

USER root
RUN make install && ldconfig

USER $USER
WORKDIR $HOME


###### syndicatefs (FUSE)
RUN wget -O syndicatefs.zip https://github.com/iychoi/syndicatefs/archive/master.zip && \
    unzip syndicatefs.zip && mv syndicatefs-master syndicatefs
WORKDIR "syndicatefs"

RUN make

USER root
RUN make install && ldconfig

USER $USER
WORKDIR $HOME


##############################################
# Syndicate Dataset Manager
##############################################
RUN wget -O syndicate-dataset-manager.zip https://github.com/syndicate-storage/syndicate-dataset-manager/archive/master.zip && \
    unzip syndicate-dataset-manager.zip && mv syndicate-dataset-manager-master syndicate-dataset-manager
WORKDIR "syndicate-dataset-manager"

USER root
# need to ignore warnings (setuptools is too old)
RUN python -W ignore setup.py install

USER $USER
WORKDIR $HOME

##### syndicate-ug-lwc-driver
RUN wget -O syndicate-ug-lwc-driver.zip https://github.com/syndicate-storage/syndicate-ug-lwc-driver/archive/master.zip && \
    unzip syndicate-ug-lwc-driver.zip && mv syndicate-ug-lwc-driver-master syndicate-ug-lwc-driver
WORKDIR "syndicate-ug-lwc-driver"

USER root
# need to ignore warnings (setuptools is too old)
RUN python -W ignore setup.py install

USER $USER
WORKDIR $HOME
