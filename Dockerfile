# 多阶段构建压缩镜像体积
FROM alpine:3.18 as frp_builder
RUN wget -O /tmp/frps.tar.gz https://github.com/fatedier/frp/releases/download/v0.63.0/frp_v0.63.0_linux_amd64.tar.gz \
    && tar -zxvf /tmp/frps.tar.gz -C /tmp \
    && mv /tmp/frp_${FRPS_VERSION}_linux_amd64/frps /usr/local/bin/ \
    && upx --best --lzma /usr/local/bin/frps  # UPX压缩二进制文件

FROM eclipse-temurin:17-jre-alpine
COPY --from=frp_builder /usr/local/bin/frps /usr/bin/

# 最小化安装依赖
RUN apk add --no-cache supervisor bash

# 配置文件和内存限制
COPY frps-minimal.ini /etc/frps.ini
COPY supervisord.conf /etc/supervisor/conf.d/
ENV JAVA_OPTS="-Xms128m -Xmx256m -XX:MaxRAM=384m"

# 持久化数据卷
VOLUME /root/.halo
EXPOSE 8090 7000 7500

ENTRYPOINT ["supervisord", "-n"]
