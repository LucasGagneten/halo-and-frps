# 多阶段构建优化镜像体积  二进制压缩减30%体积
FROM alpine:3.18 as frpbuilder
# 第一步：下载FRPS压缩包
RUN wget -O /tmp/frps.tar.gz https://github.com/fatedier/frp/releases/download/v0.63.0/frp0.63.0linuxamd64.tar.gz
# 第二步：解压压缩包
RUN tar -zxvf /tmp/frps.tar.gz -C /tmp
# 第三步：移动FRPS二进制文件
RUN mv /tmp/frp0.63.0linux_amd64/frps /usr/local/bin/
# 第四步：压缩二进制文件（可选）
RUN upx --best --lzma /usr/local/bin/frps

FROM halohub/halo:2.10.0
COPY --from=frp_builder /usr/local/bin/frps /usr/bin/

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
