# Start from CentOS 7 with the latest updates
FROM centos:7
RUN yum -y -q update


# Install basic compiler tools
RUN yum -y install gcc make file automake autoconf libtool


# Create a temporary build directory
RUN mkdir /root/build
WORKDIR /root/build


# Install Python
RUN yum -y install zlib zlib-devel libffi libffi-devel
COPY Python-3.7.3.tgz .
RUN tar xfz Python-3.7.3.tgz
WORKDIR Python-3.7.3
RUN ./configure --prefix=/usr/local
RUN make -j 4
RUN make install
WORKDIR /root/build
RUN rm -fr Python-3.7.3


# Remove temporary build directory
WORKDIR /
RUN rm -fr /root/build


# Install developer tools for interactive use
RUN yum -y -q install git vim telnet net-tools


# Create pydev user and populate home directory
RUN useradd -M pydev
RUN mkdir /home/pydev
RUN chown pydev:pydev /home/pydev
RUN chmod 700 /home/pydev
WORKDIR /home/pydev
COPY bashrc .bashrc
RUN chown pydev:pydev .bashrc
RUN chmod 600 .bashrc
COPY bash_profile .bash_profile
RUN chown pydev:pydev .bash_profile
RUN chmod 600 .bash_profile
COPY vimrc .vimrc
RUN chown pydev:pydev .vimrc
RUN chmod 600 .vimrc
RUN mkdir .ssh
RUN chown pydev:pydev .ssh
RUN chmod 700 .ssh
COPY id_rsa .ssh/id_rsa
RUN chown pydev:pydev .ssh/id_rsa
RUN chmod 600 .ssh/id_rsa
COPY id_rsa.pub .ssh/id_rsa.pub
RUN chown pydev:pydev .ssh/id_rsa.pub
RUN chmod 600 .ssh/id_rsa.pub
WORKDIR /


# Install fancy prompt script
COPY abbreviate_cwd /usr/local/bin
RUN chmod 755 /usr/local/bin/abbreviate_cwd


# Container starts with bash login shell for pydev user
USER pydev
WORKDIR /home/pydev
CMD bash --login
