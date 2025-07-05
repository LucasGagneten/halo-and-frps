# 多阶段构建优化镜像体积  
FROM alpine:3.18 as frpbuilder
RUN wget -O /tmp/frps.tar.gz https://github.com/fatedier/frp/releases/download/v0.63.0/frp_0.63.0_linux_amd64.tar.gz \
    && tar -zxvf /tmp/frps.tar.gz -C /tmp \
    && mv /tmp/frp_0.63.0_linux_amd64/frps /usr/local/bin/ 
FROM halohub/halo:2.10.0
COPY --from=frpbuilder /usr/local/bin/frps /usr/bin/

# 安装进程管理工具
RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

# 配置文件
COPY frps.ini /etc/frps.ini
COPY supervisord.conf /etc/supervisor/conf.d/

# 环境变量
ENV JAVA_OPTS="-Xms128m -Xmx256m"

# 端口配置
EXPOSE 80 7000 7500

# 启动命令
CMD ["supervisord", "-n"]
