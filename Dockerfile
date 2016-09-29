FROM ubuntu:14.04
MAINTAINER sulele@supermap.com

ENV ICM_CONFIG_PATH /etc/icloud/config
ENV PKG_URL http://download.supermap.com.cn/SuperMapGIS/SuperMap8C/810(2017)/iCloudManager/supermap_icloudmanager_8.1.0Beta_linux64.tar.gz

RUN mkdir -p $ICM_CONFIG_PATH
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt-get update && apt-get -dy --reinstall install libc6-i386
RUN apt-get install -y lib32z1 lib32ncurses5 lib32bz2-1.0

RUN mkdir -p /etc/icloud
RUN wget -nc -nv -O /tmp/icm.tar.gz "$PKG_URL" \
        && tar -zxf "/tmp/icm.tar.gz" -C /etc/icloud \
	&& ln -s /etc/icloud/SuperMapiCloudManager* /etc/icloud/SuperMapiCloudManager

RUN tar xvf /etc/icloud/SuperMapiCloudManager/support/SuperMap_License/Support/aksusbd*.tar -C /tmp \
        && mv /tmp/aksusbd* /etc/icloud/aksusbd

ADD ./start-icloudmanager.sh  /etc/icloud
RUN chmod +x /etc/icloud/start-icloudmanager.sh
RUN chmod +x /etc/icloud/SuperMapiCloudManager/bin/*.sh
RUN chmod +x /etc/icloud/SuperMapiCloudManager/support/jre/bin/java

CMD /etc/icloud/start-icloudmanager.sh