FROM ubuntu:16.04

# 建立 yapi 用户
RUN groupadd --gid 1000 yapi && \
    useradd --uid 1000 --gid yapi --shell /bin/bash --create-home yapi

# 是定工作目錄到/home/yapi
WORKDIR /home/yapi

# 更新安裝包,安裝基本套件
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    python \
    wget \
    git \
    apt-transport-https \
    ca-certificates

# 安裝 nodejs
RUN wget http://cdn.npm.taobao.org/dist/node/v8.9.0/node-v8.9.0-linux-x64.tar.gz && \
    tar -xzvf node-v8.9.0-linux-x64.tar.gz && \
    ln -s /home/yapi/node-v8.9.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /home/yapi/node-v8.9.0-linux-x64/bin/npm /usr/local/bin/npm

# 建立yapi/log資料夾
RUN mkdir -p /home/yapi/log

# 開啟寫入權限
RUN chown -R yapi:yapi /home/yapi/log

#寫入LOG在實體主機上
VOLUME ["/home/yapi/log"]

#  使用yapi身份下載安裝 yapi 原始專案
USER yapi

RUN mkdir yapi && \
    wget https://github.com/YMFE/yapi/archive/v1.3.23.tar.gz && \
    tar -xzvf v1.3.22.tar.gz -C yapi --strip-components 1

# 切換到yapi專案下執行npm install
WORKDIR /home/yapi/yapi

RUN npm install
