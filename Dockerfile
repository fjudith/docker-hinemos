FROM centos:latest

ENV HINEMOS_VERSION 6.0.1

RUN yum install -y \
	epel-release \
	selinux-policy \
	java-1.8.0-openjdk \
	curl \
	unzip \
	rsyslog \
	vim-common

RUN yum install -y supervisor

RUN cd /tmp &&\
    curl -L -O https://github.com/hinemos/hinemos/releases/download/v${HINEMOS_VERSION}/hinemos-6.0-manager-${HINEMOS_VERSION}-1.el7.x86_64.rpm && \
    rpm -Uvh hinemos-6.0-manager-${HINEMOS_VERSION}-1.el7.x86_64.rpm

RUN cd /tmp &&\
    curl -L -O https://github.com/hinemos/hinemos/releases/download/v${HINEMOS_VERSION}/hinemos-6.0-web-${HINEMOS_VERSION}-1.el7.x86_64.rpm && \
    rpm -Uvh hinemos-6.0-web-${HINEMOS_VERSION}-1.el7.x86_64.rpm

ADD supervisord.d/hinemos-manager.ini /etc/supervisord.d/hinemos-manager.ini
ADD supervisord.d/hinemos-pg.ini /etc/supervisord.d/hinemos-pg.ini
ADD supervisord.d/hinemos-web.ini /etc/supervisord.d/hinemos-web.ini
RUN sed -i s/nodaemon=false/nodaemon=true/ /etc/supervisord.conf

EXPOSE 80
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

CMD ["/usr/bin/supervisord"]
