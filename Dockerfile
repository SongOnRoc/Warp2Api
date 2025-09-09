# 使用 Debian Bookworm 基础镜像以安装 supervisor
FROM python:3.13-bookworm

# 设置工作目录
WORKDIR /app

# 安装 supervisor 和 uv
RUN apt-get update && apt-get install -y supervisor && \
    pip install uv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 创建 supervisor 日志目录
RUN mkdir -p /var/log/supervisor

# 复制依赖文件
COPY pyproject.toml uv.lock* .python-version* ./

# 安装项目依赖
RUN uv pip sync --system --no-cache --frozen-lockfile

# 复制项目文件
COPY . .

# 复制 supervisor 配置文件
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 暴露端口
EXPOSE 8010

# 运行 supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]