############################################################
# Dockerfile to run Tactic Containers 
# Based on Centos 6 image
############################################################

FROM centos:centos6
MAINTAINER Diego Cortassa <diego@cortassa.net>

ENV REFRESHED_AT 2016-10-23

# Reinstall glibc-common to get deleted files (i.e. locales, encoding UTF8) from the centos docker image
#RUN yum -y reinstall glibc-common
RUN yum -y update glibc-common

# Setup a minimal env
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV HOME /root

# set a better shell prompt
RUN echo 'export PS1="[\u@docker] \W # "' >> /root/.bash_profile

# Install dependecies
RUN /bin/rpm -Uvh https://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-3.noarch.rpm && \
    yum -y update && \
    yum -y install httpd postgresql94-server postgresql94 postgresql94-contrib unzip git ImageMagick
    #  Install initscripts
# TODO add ffmpeg

# Install  GCC
RUN yum -y install gcc openssl-devel bzip2-devel wget && \
    wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz && \
    tar xzf Python-2.7.15.tgz && \
    cd Python-2.7.15 && \
    ./configure --prefix=/usr/local && \
    make && make altinstall

# RUN yum -y install centos-release-scl && \
#     yum -y install python27 && \
#     scl enable python27 bash

# RUN cd /opt/rh/python27/root/usr/bin/; ls

RUN python2.7 -V
# RUN yum -y install python-lxml python-imaging python-crypto python-psycopg2
# Install setuptools + pip
RUN cd /tmp && \
    wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz && \
    tar -xvf setuptools-1.4.2.tar.gz && \
    cd setuptools-1.4.2 && \
    python2.7 setup.py install && \
    curl https://bootstrap.pypa.io/get-pip.py | python2.7 - 

RUN python2.7 -m pip install lxml pillow pycrypto psycopg2-binary supervisor

# install supervisord
RUN mkdir -p /var/log/supervisor && \ 
    mkdir -p /etc/supervisor/conf.d 

ADD supervisord.conf /etc/supervisor/supervisord.conf

# Ssh server
# start and stop the server to make it generate host keys
# RUN yum -y install openssh-server && \
#     cat /usr/lib/systemd/system/sshd@.service && \
#     cat /usr/lib/systemd/system/sshd-keygen.service && \
#     all_lines=`cat $filename` && \
#     for i in $all_lines; do eval"export $i"; done && \
#     /usr/sbin/sshd-keygen

# Ssh server
# start and stop the server to make it generate host keys
RUN yum -y install openssh-server postmaster && \
    service sshd start && \
    service sshd stop

# set root passord at image launch with -e ROOT_PASSWORD=my_secure_password
ADD bootstrap.sh /usr/local/bin/bootstrap.sh

# Clean up
RUN yum clean all

# initialize postgresql data files
RUN /etc/init.d/postgresql-9.4 initdb

# Init Git
RUN git clone -b 4.8 --depth 1 https://github.com/Southpaw-TACTIC/TACTIC.git
# RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
# RUN /usr/local/bin/python2.7 get-pip.py
# RUN /usr/local/bin/python2.7 -m pip install lxml pillow crypto psycopg2 
# RUN /usr/local/bin/python2.7 -m pip install Crypto
# RUN /usr/local/bin/python2.7 -c "import Crypto"

RUN python -V

# get and install Tactic
RUN ls /var/lib/pgsql/ && \
    cp TACTIC/src/install/postgresql/pg_hba.conf /var/lib/pgsql/9.4/data/pg_hba.conf && \
    chown postgres:postgres /var/lib/pgsql/9.4/data/pg_hba.conf && \
    /etc/init.d/postgresql-9.4 start && \
    yes | python2.7 TACTIC/src/install/install.py -d && \
    /etc/init.d/postgresql-9.4 stop && \
    cp /home/apache/tactic_data/config/tactic.conf /etc/httpd/conf.d/ && \
    rm -r TACTIC

# EXPOSE 80 22

# Start Tactic stack
RUN chmod +x /usr/local/bin/bootstrap.sh
CMD ["/usr/local/bin/bootstrap.sh"]
