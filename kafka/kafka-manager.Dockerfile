FROM centos

RUN yum -y install nc vim lsof wget tar tree bzip2 unzip vim-enhanced passwd sudo yum-utils hostname net-tools rsync man git make automake cmake patch logrotate python-devel libpng-devel libjpeg-devel pwgen python-pip openssl openssl-devel
ENV KAFKA_MANAGER_VERSION "2.0.0.2"

RUN mkdir /opt/java &&\
    wget https://lucode-for-all-1251927515.cos.ap-chengdu.myqcloud.com/soft/jdk-12_linux-x64_bin.tar.gz -P /opt/java

RUN tar zxvf /opt/java/jdk-12_linux-x64_bin.tar.gz -C /opt/java &&\
	JAVA_HOME=/opt/java/jdk-12 &&\
	sed -i "/^PATH/i export JAVA_HOME=$JAVA_HOME" /root/.bash_profile &&\
	sed -i "s%^PATH.*$%&:$JAVA_HOME/bin%g" /root/.bash_profile &&\
	source /root/.bash_profile

RUN wget https://lucode-for-all-1251927515.cos.ap-chengdu.myqcloud.com/soft/kafka-manager-2.0.0.2.zip -P /opt

RUN unzip /opt/kafka-manager-${KAFKA_MANAGER_VERSION}.zip -d /opt &&\
    mv /opt/kafka-manager-${KAFKA_MANAGER_VERSION} /opt/kafka-manager

WORKDIR /opt/kafka-manager

ENV JAVA_HOME "/opt/java/jdk-12"

ENTRYPOINT ["bin/kafka-manager", "-Dhttp.port=38080"]

