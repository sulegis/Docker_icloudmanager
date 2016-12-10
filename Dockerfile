FROM ubuntu:14.04
MAINTAINER sunxiaoyu@supermap.com
ENV ICM_CONFIG_PATH /etc/icloud/config
RUN mkdir -p $ICM_CONFIG_PATH
ADD sources.list /etc/apt/sources.list
RUN sudo apt-get update;
RUN sudo apt-get -dy --reinstall install libc6-i386
RUN apt-get install -y lib32z1 lib32ncurses5 lib32bz2-1.0

ADD ./supermap_icloudmanager_*.tar.gz /etc/icloud
RUN ln -s /etc/icloud/SuperMapiCloudManager* /etc/icloud/SuperMapiCloudManager

RUN cd /tmp;\
	cp /etc/icloud/SuperMapiCloudManager/support/SuperMap_License/Support/aksusbd*.tar ./aksusbd.tar; \
	tar -xvf aksusbd.tar; \
	mv ./aksusbd-* /etc/icloud/aksusbd

ADD ./start-icloudmanager.sh  /etc/icloud
RUN chmod +x /etc/icloud/start-icloudmanager.sh
RUN chmod +x /etc/icloud/SuperMapiCloudManager/bin/*.sh
RUN chmod +x /etc/icloud/SuperMapiCloudManager/support/jre/bin/java

CMD /etc/icloud/start-icloudmanager.sh

