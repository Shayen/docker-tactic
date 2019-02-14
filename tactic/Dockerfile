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
    yum -y install initscripts httpd postgresql94-server postgresql94 postgresql94-contrib python-lxml python-imaging python-crypto python-psycopg2 unzip git ImageMagick
# TODO add ffmpeg


# install supervisord
RUN yum -y install python-setuptools && \
    easy_install supervisor && \
    mkdir -p /var/log/supervisor && \ 
    mkdir -p /etc/supervisor/conf.d/
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
RUN yum -y install openssh-server && \
    service sshd start && \
    service sshd stop

# set root passord at image launch with -e ROOT_PASSWORD=my_secure_password
ADD bootstrap.sh /usr/local/bin/bootstrap.sh

# Clean up
RUN yum clean all

# initialize postgresql data files
RUN /etc/init.d/postgresql-9.4 initdb

# Init Git
RUN git clone -b 4.6 --depth 1 https://github.com/Southpaw-TACTIC/TACTIC.git

# get and install Tactic
RUN ls /var/lib/pgsql/ && \
    cp TACTIC/src/install/postgresql/pg_hba.conf /var/lib/pgsql/9.4/data/pg_hba.conf && \
    chown postgres:postgres /var/lib/pgsql/9.4/data/pg_hba.conf && \
    /etc/init.d/postgresql-9.4 start && \
    yes | python TACTIC/src/install/install.py -d && \
    /etc/init.d/postgresql-9.4 stop && \
    cp /home/apache/tactic_data/config/tactic.conf /etc/httpd/conf.d/ && \
    rm -r TACTIC

EXPOSE 80 22

# Start Tactic stack
CMD ["/usr/local/bin/bootstrap.sh"]
