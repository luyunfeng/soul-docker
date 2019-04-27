FROM centos

RUN yum -y install vim lsof wget tar bzip2 unzip vim-enhanced passwd sudo yum-utils hostname net-tools rsync man git make automake cmake patch logrotate python-devel libpng-devel libjpeg-devel pwgen python-pip

ENV ZOOKEEPER_VERSION "3.4.14"

RUN mkdir /opt/java &&\
    wget https://lucode-for-all-1251927515.cos.ap-chengdu.myqcloud.com/soft/jdk-12_linux-x64_bin.tar.gz -P /opt/java

RUN tar zxvf /opt/java/jdk-12_linux-x64_bin.tar.gz -C /opt/java &&\
	JAVA_HOME=/opt/java/jdk-12 &&\
	sed -i "/^PATH/i export JAVA_HOME=$JAVA_HOME" /root/.bash_profile &&\
	sed -i "s%^PATH.*$%&:$JAVA_HOME/bin%g" /root/.bash_profile &&\
	source /root/.bash_profile

RUN mkdir /opt/zookeeper &&\
    wget https://lucode-for-all-1251927515.cos.ap-chengdu.myqcloud.com/soft/zookeeper-3.4.14.tar.gz -P /opt/zookeeper

RUN tar zxvf /opt/zookeeper/zookeeper*.tar.gz -C /opt/zookeeper

RUN echo "source /root/.bash_profile" > /opt/zookeeper/start.sh &&\
	echo "cp /opt/zookeeper/zookeeper-"$ZOOKEEPER_VERSION"/conf/zoo_sample.cfg /opt/zookeeper/zookeeper-"$ZOOKEEPER_VERSION"/conf/zoo.cfg" >> /opt/zookeeper/start.sh &&\
	echo "[ ! -z $""ZOOKEEPER_PORT"" ] && sed -i 's%.*clientPort=.*$%clientPort='$""ZOOKEEPER_PORT'""%g'  /opt/zookeeper/zookeeper-"$ZOOKEEPER_VERSION"/conf/zoo.cfg" >> /opt/zookeeper/start.sh &&\
	echo "[ ! -z $""ZOOKEEPER_ID"" ] && mkdir -p /tmp/zookeeper && echo $""ZOOKEEPER_ID > /tmp/zookeeper/myid" >> /opt/zookeeper/start.sh &&\
	echo "[[ ! -z $""ZOOKEEPER_SERVERS"" ]] && for server in $""ZOOKEEPER_SERVERS""; do echo $""server"" >> /opt/zookeeper/zookeeper-"$ZOOKEEPER_VERSION"/conf/zoo.cfg; done" >> /opt/zookeeper/start.sh &&\
	echo "/opt/zookeeper/zookeeper-$"ZOOKEEPER_VERSION"/bin/zkServer.sh start-foreground" >> /opt/zookeeper/start.sh

EXPOSE 2181

WORKDIR /opt/zookeeper/zookeeper-$ZOOKEEPER_VERSION

ENTRYPOINT ["sh", "/opt/zookeeper/start.sh"]










