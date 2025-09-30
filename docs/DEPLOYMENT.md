# MES系统部署文档 / Deployment Guide

## 📋 系统要求 / System Requirements

- Docker 20.10+
- Docker Compose 2.0+
- 至少 4GB 可用内存
- 至少 20GB 可用磁盘空间
- 端口要求：3306, 6379, 9000, 9001, 48080, 48081

## 🚀 快速部署 / Quick Start

### 1. 克隆项目
```bash
git clone <repository-url>
cd open_mes
```

### 2. 一键启动
```bash
docker-compose up -d
```

### 3. 等待服务启动
```bash
# 查看服务状态
docker-compose ps

# 查看启动日志
docker-compose logs -f mes-server-api
```

### 4. 访问系统
- **前端地址**: http://localhost:48081
- **默认账号**: metaxk
- **默认密码**: 111111

## 🔧 服务配置 / Service Configuration

### 数据库 / Database (MariaDB)
- **端口**: 3306
- **数据库名**: mes-pro
- **Root密码**: aa123456
- **用户**: db_user / db@123
- **初始化脚本**: `deployment/data/sql/init.sql`

### Redis 缓存
- **端口**: 6379
- **密码**: 123456

### MinIO 对象存储
- **API端口**: 9000
- **控制台端口**: 9001
- **用户名**: admin
- **密码**: admin111

### 后端服务 / Backend
- **端口**: 48080
- **镜像**: eclipse-temurin:11-jdk
- **JVM参数**: -Xms512m -Xmx512m
- **验证码**: 已启用

### 前端服务 / Frontend
- **端口**: 48081
- **静态文件**: deployment/data/front/dist

## 📁 重要目录 / Important Directories

```
deployment/
├── Dockerfile              # 后端服务镜像构建文件
├── start.sh                # 应用启动脚本
├── fonts/                  # 验证码字体文件
├── data/
│   ├── sql/               # 数据库初始化脚本
│   └── front/             # 前端静态文件和Nginx配置
└── application-prod-override.yaml  # 配置覆盖
```

## 🔄 常用命令 / Common Commands

### 启动服务
```bash
docker-compose up -d
```

### 停止服务
```bash
docker-compose down
```

### 重启特定服务
```bash
docker-compose restart mes-server-api
docker-compose restart front
```

### 查看日志
```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f mes-server-api
docker-compose logs -f front
```

### 重新构建镜像
```bash
docker-compose down mes-server-api
docker-compose build --no-cache mes-server-api
docker-compose up -d mes-server-api
```

## 🐛 故障排查 / Troubleshooting

### 1. 端口被占用
```bash
# 检查端口占用
lsof -i :48081
lsof -i :48080
lsof -i :3306

# 修改 docker-compose.yml 中的端口映射
```

### 2. 数据库连接失败
```bash
# 检查数据库服务状态
docker-compose ps db

# 查看数据库日志
docker-compose logs db

# 重启数据库
docker-compose restart db
```

### 3. 前端502错误
```bash
# 检查后端服务是否启动
docker-compose ps mes-server-api

# 重启Nginx
docker-compose restart front
```

### 4. 验证码500错误
验证码需要图形库支持，确保使用 `eclipse-temurin:11-jdk` 镜像。

如需禁用验证码：
```bash
# 修改 deployment/start.sh
# 将 -Dmetaxk.captcha.enable=true 改为 false
```

## 🔐 安全配置 / Security

### 生产环境建议修改以下密码：

1. **数据库密码** - `docker-compose.yml`:
   ```yaml
   MYSQL_ROOT_PASSWORD: <your-password>
   MYSQL_PASSWORD: <your-password>
   ```

2. **Redis密码** - `docker-compose.yml`:
   ```yaml
   command: redis-server --requirepass <your-password>
   ```

3. **MinIO密码** - `docker-compose.yml`:
   ```yaml
   MINIO_ROOT_PASSWORD: <your-password>
   ```

4. **应用管理员密码** - 登录后在系统中修改

## 📊 数据备份 / Data Backup

重要数据目录：
```
data/
├── db-vol/         # 数据库数据
├── redis/data/     # Redis数据
├── minio/data/     # MinIO对象存储
└── server/logs/    # 应用日志
```

备份命令：
```bash
# 备份数据库
docker exec mes-db mysqldump -uroot -paa123456 mes-pro > backup.sql

# 备份所有数据
tar -czf mes-backup-$(date +%Y%m%d).tar.gz data/
```

## 🔗 相关文档 / Related Documents

- [开发文档](./DEVELOPMENT.md)
- [注意事项](./NOTES.md)
- [操作手册](../manual/)

## 📞 技术支持 / Support

- 联系电话: 17898898894
- 演示地址: https://mesv2.cloudmes.io/

