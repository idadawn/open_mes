# MES系统本地部署指南

## 系统要求
- Docker 20.10+
- Docker Compose 2.0+
- 至少4GB可用内存
- 至少10GB可用磁盘空间

## 部署步骤

### 1. 安装Docker和Docker Compose

#### Windows
```bash
# 下载并安装 Docker Desktop
# 访问: https://docs.docker.com/desktop/install/windows-install/
```

#### Linux (Ubuntu)
```bash
# 安装Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-get install -y software-properties-common
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get install docker-ce -y

# 安装Docker Compose
sudo curl -L https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. 准备部署文件

确保项目目录包含以下文件：
- `docker-compose.yml` - 主部署文件
- `部署和文档/Dockerfile` - 后端服务Dockerfile
- `部署和文档/data/sql/init.sql` - 数据库初始化脚本
- `部署和文档/data/front/conf/nginx.conf` - Nginx配置
- `部署和文档/data/front/dist/` - 前端构建文件

### 3. 启动服务

```bash
# 在项目根目录执行
docker-compose up -d
```

### 4. 检查服务状态

```bash
# 查看所有容器状态
docker-compose ps

# 查看服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs mes-server-api
docker-compose logs front
```

### 5. 访问系统

- **前端界面**: http://localhost:48081
- **后端API**: http://localhost:48080
- **MinIO控制台**: http://localhost:9001
- **数据库**: localhost:3306
- **Redis**: localhost:6379

### 默认登录信息

- **用户名**: metaxk
- **密码**: 111111

### MinIO登录信息

- **用户名**: admin
- **密码**: admin111

## 服务说明

### 1. 数据库 (MariaDB)
- 端口: 3306
- 数据库: mes-pro
- 用户名: db_user
- 密码: db@123
- 数据持久化: ./data/db-vol

### 2. Redis
- 端口: 6379
- 密码: 123456
- 数据持久化: ./data/redis/data

### 3. MinIO
- API端口: 9000
- 控制台端口: 9001
- 用户名: admin
- 密码: admin111
- 数据持久化: ./data/minio/data

### 4. MES后端服务
- 端口: 48080
- 健康检查: http://localhost:48080/actuator/health

### 5. 前端服务
- 端口: 48081
- 基于Nginx
- 静态文件目录: ./部署和文档/data/front/dist

## 管理命令

```bash
# 停止所有服务
docker-compose down

# 停止并删除所有数据
docker-compose down -v

# 重启特定服务
docker-compose restart mes-server-api

# 重新构建并启动
docker-compose up -d --build

# 查看服务资源使用情况
docker-compose top
```

## 故障排除

### 1. 端口冲突
如果端口被占用，可以修改 `docker-compose.yml` 中的端口映射。

### 2. 内存不足
如果容器启动失败，检查系统内存是否充足。

### 3. 数据库连接失败
确保数据库容器完全启动后再启动后端服务。

### 4. 前端无法访问
检查前端dist目录是否包含构建文件。

## 数据备份

```bash
# 备份数据库
docker exec mes-db mysqldump -u db_user -pdb@123 mes-pro > backup.sql

# 备份Redis数据
cp -r ./data/redis/data ./backup/redis/

# 备份MinIO数据
cp -r ./data/minio/data ./backup/minio/
```

## 注意事项

1. 首次启动可能需要较长时间初始化数据库
2. 确保所有服务健康检查通过后再访问系统
3. 生产环境建议修改默认密码
4. 定期备份重要数据