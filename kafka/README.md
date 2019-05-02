# 文件清单



### 启动 

docker-compose -f "kafka/docker-compose.yml" up -d --build

### 进入容器  

docker exec -it kafka0 bash

docker exec -it zookeeper0 bash

./zkCli.sh -server 127.0.0.1:12183

### 查询日志
docker logs -f 5d71b1bc481c

### Docker 批量删除中间镜像缓存

docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker stop
docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker rm
docker images|grep none|awk '{print $3 }'|xargs docker rmi

### 查看端口
lsof -i:9092

### kafka 相关操作

```
sh bin/kafka-topics.sh --zookeeper zookeeper0:2181 --topic topic1 --create --replication-factor 3 --partitions 3
```

```
sh bin/kafka-topics.sh --zookeeper zookeeper0:2181 --topic topic1 --describe
```