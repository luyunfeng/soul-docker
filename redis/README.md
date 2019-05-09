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

