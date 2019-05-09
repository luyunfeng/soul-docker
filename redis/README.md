# docker-redis-cluster

集群版 redis 5.0 默认 三主三从 

可选 redis 版本

	*  build-3.0
	*  build-3.2
	*  build-4.0
	*  build-5.0

> 注意低版本 5.0 以下版本集群需要依赖 ruby 环境并且需要用哨兵模式开始主从复制功能


# docker-compost.yml
```
SENTINEL: ${REDIS_USE_SENTINEL}
STANDALONE: ${REDIS_USE_STANDALONE}
```
${REDIS_USE_SENTINEL} 设置为 true 里面可以开启哨兵
${REDIS_USE_STANDALONE} 设置为 true 就是单级模式

# 基本命令

## 创建镜像
```
make build
```
or
```
	docker-compose build
```
## 启动容器
```
 make up
```
or
``` 
docker-compose up
```

## 关闭集群
```
make down
```
or
```
docker-compose stop
```

## 重新打包
```
make rebuild
```
or
```
docker-compose build --no-cache
```


## 进入机器
```
make bash
```
or 
```
docker-compose exec redis-cluster /bin/bash
```

## 建立连接默认是 7000 这台
```
make cli
```
or 
```
docker-compose exec redis-cluster /redis/src/redis-cli -p 7000
```
## 集群模式下进入指定节点
```
docker-compose exec redis-cluster /redis/src/redis-cli -p 7005 -c
```

## 进入 redis 之后

查看 集群节点
```
cluster nodes
```

查看集群信息
```
cluster info
```
