FROM debian:jessie

MAINTAINER Nicolas Duval <nicolas.duval@simplx.fr>

COPY compile_config /tmp/compile_config
RUN apt-get update && apt-get install -y wget make postgresql libpq-dev libc-ares-dev libcurl4-openssl-dev uuid-dev libc6-dev libwebsockets-dev gcc build-essential g++ git && \
	wget -q http://mosquitto.org/files/source/mosquitto-1.4.9.tar.gz -O /tmp/mosquitto-1.4.9.tar.gz && \
	cd /tmp/ && \
	tar zxvf mosquitto-1.4.9.tar.gz && \ 
	rm -f mosquitto-1.4.9.tar.gz && \
	cd ./mosquitto-1.4.9 && \
	mv /tmp/compile_config/mqtt_config.mk ./config.mk && \ 
	make install && \
	cd .. && \
	git clone https://github.com/jpmens/mosquitto-auth-plug.git && \
	cd mosquitto-auth-plug && \
	mv /tmp/compile_config/auth_config.mk ./config.mk && \
	make && \
	mkdir -p /mqtt/config /mqtt/data /mqtt/log && \
	cp auth-plug.so /mqtt/config/ && \
    adduser --system --disabled-password --disabled-login mosquitto && \
    groupadd mosquitto && \ 
    usermod -g mosquitto mosquitto

COPY config /mqtt/config
RUN chown -R mosquitto:mosquitto /mqtt
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

ONBUILD ADD acl.conf /mqtt/config/acl/acl.conf
ONBUILD ADD custom.conf /mqtt/config/conf.d/custom.conf

EXPOSE 1883 9001

ADD docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]
