FROM centos

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

ENV KAFKA_VERSION "2.1.1"

RUN yum -y install vim lsof wget tar bzip2 unzip vim-enhanced passwd sudo yum-utils hostname net-tools rsync man git make automake cmake patch logrotate python-devel libpng-devel libjpeg-devel pwgen python-pip tree openssl openssl-devel

RUN mkdir /opt/java &&\
	wget https://lucode-for-all-1251927515.cos.ap-chengdu.myqcloud.com/soft/jdk-12_linux-x64_bin.tar.gz -P /opt/java

RUN tar zxvf /opt/java/jdk-12_linux-x64_bin.tar.gz -C /opt/java &&\
	JAVA_HOME=/opt/java/jdk-12 &&\
	sed -i "/^PATH/i export JAVA_HOME=$JAVA_HOME" /root/.bash_profile &&\
	sed -i "s%^PATH.*$%&:$JAVA_HOME/bin%g" /root/.bash_profile &&\
	source /root/.bash_profile

RUN mkdir /opt/kafka &&\
	wget https://lucode-for-all-1251927515.cos.ap-chengdu.myqcloud.com/soft/kafka_2.12-2.1.1.tgz -P /opt/kafka


RUN tar zxvf /opt/kafka/kafka*.tgz -C /opt/kafka &&\
	sed -i 's/num.partitions.*$/num.partitions=3/g' /opt/kafka/kafka_2.12-$KAFKA_VERSION/config/server.properties

RUN sed -i '0,/^if/s%^if%export JAVA_HOME='$JAVA_HOME'\nexport PATH=$PATH:$JAVA_HOME/bin\nif%' /opt/kafka/kafka_2.12-$KAFKA_VERSION/bin/kafka-run-class.sh

COPY kafka-start.sh /opt/kafka/start.sh 

RUN  chmod a+x /opt/kafka/start.sh

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

EXPOSE 9092

WORKDIR /opt/kafka/kafka_2.12-$KAFKA_VERSION

ENTRYPOINT ["sh", "/opt/kafka/start.sh"]

# kafka 动态参数配置在外部文件中配置
# RUN echo "source /root/.bash_profile" > /opt/kafka/start.sh &&\
# 	echo "cd /opt/kafka/kafka_2.12-"$KAFKA_VERSION >> /opt/kafka/start.sh &&\
# 	#echo "sed -i 's%zookeeper.connect=.*$%zookeeper.connect=zookeeper:2181%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	echo "[ ! -z $""ZOOKEEPER_CONNECT"" ] && sed -i 's%.*zookeeper.connect=.*$%zookeeper.connect='$""ZOOKEEPER_CONNECT'""%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	echo "[ ! -z $""BROKER_ID"" ] && sed -i 's%broker.id=.*$%broker.id='$""BROKER_ID'""%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	echo "[ ! -z $""BROKER_PORT"" ] && sed -i 's%port=.*$%port='$""BROKER_PORT'""%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	#echo "sed -i 's%#advertised.host.name=.*$%advertised.host.name='$""(hostname -i)'""%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	#echo "[ ! -z $""ADVERTISED_HOST_NAME"" ] && sed -i 's%.*advertised.host.name=.*$%advertised.host.name='$""ADVERTISED_HOST_NAME'""%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	#echo "[ ! -z $""ADVERTISED_HOST_NAME"" ] && sed -i '\$a advertised.host.name=$""ADVERTISED_HOST_NAME""'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	#echo "sed -i 's%#host.name=.*$%host.name='$""(hostname -i)'""%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	#echo "[ ! -z $""HOST_NAME"" ] && sed -i 's%.*host.name=.*$%host.name='$""HOST_NAME'""%g'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	#echo "[ ! -z $""HOST_NAME"" ] && sed -i '\$a host.name=$""HOST_NAME""'  /opt/kafka/kafka_2.12-"$KAFKA_VERSION"/config/server.properties" >> /opt/kafka/start.sh &&\
# 	#echo "delete.topic.enable=true" >> /opt/kafka/kafka_2.12-$KAFKA_VERSION/config/server.properties &&\
# 	#echo "sed -i 's%#listeners=.*$%listeners=PLAINTEXT://'$(hostname -i)':9092%g' config/server.properties &&\
#                 #[ ! -z $LISTENERS ] && sed -i 's%listeners=.*$%listeners='$LISTENERS'%g' config/server.properties &&\
# 	echo "bin/kafka-server-start.sh config/server.properties" >> /opt/kafka/start.sh &&\
#	chmod a+x /opt/kafka/start.sh


