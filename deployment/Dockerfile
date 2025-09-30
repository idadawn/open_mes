FROM openjdk:11-jdk-slim

## 使用国内镜像源并安装必要的字体和库
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      fontconfig \
      libfontconfig1 \
      fonts-dejavu-core \
      && rm -rf /var/lib/apt/lists/*

## 创建字体目录并复制字体文件（从项目目录）
RUN mkdir -p /usr/share/fonts/truetype/dejavu
COPY deployment/fonts/dejavu /usr/share/fonts/truetype/dejavu/

RUN mkdir -p /metaxk-mes-server
WORKDIR /metaxk-mes-server

## 将后端项目的 Jar 文件，复制到镜像中（新版本）
COPY src/new_open_mes_server/metaxk-server/target/metaxk-server.jar app.jar

## 复制配置文件覆盖
COPY deployment/application-prod-override.yaml /metaxk-mes-server/config/application-prod.yaml

## 复制启动脚本
COPY deployment/start.sh /metaxk-mes-server/start.sh
RUN chmod +x /metaxk-mes-server/start.sh

## 设置 TZ 时区
ENV TZ=Asia/Shanghai

## 暴露后端项目的 48080 端口
EXPOSE 48080

## 启动后端项目
CMD ["/metaxk-mes-server/start.sh"]

