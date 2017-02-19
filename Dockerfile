FROM lsiobase/xenial
# (Fokred to Private GiT Repo for adding NFS directory)
MAINTAINER sparklyballs 

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

# add sonarr repository
RUN \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > \
	/etc/apt/sources.list.d/sonarr.list && \

# install packages
 apt-get update && \
 apt-get install -y \
	libcurl3 \
	nzbdrone && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# create shared directory
RUN \
 mkdir /shared-media
 echo "//192.168.2.10/shared-media /shared-media cifs daefaults,uid=1000,gid=1000,rw,username=datastore,password=T0nkaTrucks,context=system_u:object_r:svirt_sandbox_file_t:s0" > /etc/fstab
 mount -a
 
# ports and volumes
EXPOSE 8989
VOLUME /config /downloads /tv
