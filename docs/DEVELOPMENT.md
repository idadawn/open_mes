# MES系统开发文档 / Development Guide

## 🛠 开发环境要求 / Development Requirements

### 后端 / Backend
- JDK 11+
- Maven 3.6+
- MySQL 8.0+ / MariaDB 10.8+
- Redis 6.0+
- MinIO (对象存储)

### 前端 / Frontend
- Node.js 16+
- npm 8+ / pnpm 7+
- Vue 3
- Vite

## 📁 项目结构 / Project Structure

```
src/
├── new_open_mes_server/        # 后端服务
│   ├── metaxk-server/         # 主应用
│   └── metaxk-module-*/       # 业务模块
│
├── new_open_mes_front/         # 前端应用
│   ├── src/
│   │   ├── api/              # API接口
│   │   ├── views/            # 页面组件
│   │   ├── components/       # 公共组件
│   │   └── router/           # 路由配置
│   └── package.json
│
└── metaxk-pro/                 # Pro版本
```

## 🔧 后端开发 / Backend Development

### 1. 环境配置

```bash
cd src/new_open_mes_server/metaxk-server

# 配置数据库
# 编辑 src/main/resources/application-dev.yaml
```

**application-dev.yaml 配置示例：**
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/mes-pro
    username: root
    password: your-password
  redis:
    host: localhost
    port: 6379
    password: 123456
```

### 2. 启动后端服务

```bash
# 使用Maven启动
mvn spring-boot:run

# 或使用IDE启动
# 主类: io.metaxk.server.MetaxkServerApplication
```

### 3. 访问API文档

启动后访问 Swagger文档：
- http://localhost:48080/doc.html

### 4. 新建模块

参考文档：`src/new_open_mes_server/新建模块说明.md`

**模块结构：**
```
metaxk-module-xxx/
├── metaxk-module-xxx-api/         # API接口定义
├── metaxk-module-xxx-biz/         # 业务实现
└── pom.xml
```

### 5. 代码规范

- 使用 MyBatis-Plus 进行数据库操作
- 统一使用 CommonResult 返回结果
- 异常使用 ServiceException 抛出
- 日志使用 @Slf4j 注解

## 💻 前端开发 / Frontend Development

### 1. 安装依赖

```bash
cd src/new_open_mes_front

# 使用npm
npm install

# 或使用pnpm（推荐）
pnpm install
```

### 2. 配置环境变量

```bash
# 复制环境配置文件
cp .env.development.example .env.development

# 编辑配置
vim .env.development
```

**.env.development 配置：**
```env
# API地址
VITE_API_URL_ADMIN=http://localhost:48080/admin-api
VITE_API_URL_APP=http://localhost:48080/app-api

# 应用配置
VITE_APP_TITLE=MES管理系统
```

### 3. 启动开发服务器

```bash
npm run dev
# 或
pnpm dev

# 访问: http://localhost:5173
```

### 4. 构建生产版本

```bash
npm run build
# 或
pnpm build

# 构建产物在 dist/ 目录
```

### 5. 代码规范

- 使用 Vue 3 Composition API
- 使用 TypeScript
- 组件命名采用 PascalCase
- 使用 ESLint + Prettier 格式化代码

## 🔌 API接口开发 / API Development

### 1. 后端接口示例

```java
@RestController
@RequestMapping("/admin-api/mes/example")
@Tag(name = "示例管理")
public class ExampleController {
    
    @Autowired
    private ExampleService exampleService;
    
    @PostMapping("/create")
    @Operation(summary = "创建示例")
    public CommonResult<Long> createExample(@RequestBody ExampleCreateReqVO createReqVO) {
        return success(exampleService.createExample(createReqVO));
    }
}
```

### 2. 前端API调用示例

```typescript
// src/api/mes/example.ts
import request from '@/utils/request'

export const createExampleApi = (data: any) => {
  return request.post({
    url: '/mes/example/create',
    data
  })
}

// 在组件中使用
const handleCreate = async () => {
  const result = await createExampleApi(formData)
  if (result.code === 0) {
    ElMessage.success('创建成功')
  }
}
```

## 🗄️ 数据库开发 / Database Development

### 1. 表设计规范

- 表名：小写，下划线分隔，如 `mes_work_order`
- 主键：`id` BIGINT，自增
- 必备字段：
  - `create_time` - 创建时间
  - `update_time` - 更新时间
  - `creator` - 创建人
  - `updater` - 更新人
  - `deleted` - 逻辑删除标记
  - `tenant_id` - 租户ID

### 2. SQL脚本管理

新增SQL脚本放在：
```
deployment/data/sql/
├── init.sql              # 初始化脚本（包含表结构和基础数据）
└── updates/              # 更新脚本
    ├── v1.1.0.sql
    └── v1.2.0.sql
```

### 3. MyBatis-Plus配置

```java
@TableName("mes_work_order")
public class WorkOrderDO {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String orderNo;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableLogic
    private Boolean deleted;
}
```

## 🧪 测试 / Testing

### 后端单元测试

```java
@SpringBootTest
class ExampleServiceTest {
    
    @Autowired
    private ExampleService exampleService;
    
    @Test
    void testCreate() {
        ExampleCreateReqVO reqVO = new ExampleCreateReqVO();
        reqVO.setName("测试");
        
        Long id = exampleService.createExample(reqVO);
        assertNotNull(id);
    }
}
```

### 前端测试

```bash
# 运行单元测试
npm run test

# E2E测试
npm run test:e2e
```

## 📦 打包部署 / Build & Deploy

### 1. 后端打包

```bash
cd src/new_open_mes_server/metaxk-server
mvn clean package -DskipTests

# JAR包位置
# target/metaxk-server.jar
```

### 2. 前端打包

```bash
cd src/new_open_mes_front
npm run build

# 构建产物
# dist/
```

### 3. Docker镜像构建

```bash
# 确保已打包后端和前端
cd /path/to/open_mes

# 构建镜像
docker-compose build

# 启动服务
docker-compose up -d
```

## 🔧 常见问题 / FAQ

### Q1: 后端启动报数据库连接失败
**A**: 检查 `application-dev.yaml` 中的数据库配置，确保数据库已启动。

### Q2: 前端无法调用API
**A**: 检查 `.env.development` 中的 API 地址配置，确保后端服务已启动。

### Q3: 验证码生成失败
**A**: 开发环境可以在配置中禁用验证码：
```yaml
metaxk:
  captcha:
    enable: false
```

### Q4: Redis连接失败
**A**: 确保Redis已启动，并检查密码配置。

## 📚 参考资料 / References

- [Spring Boot文档](https://spring.io/projects/spring-boot)
- [Vue 3文档](https://vuejs.org/)
- [MyBatis-Plus文档](https://baomidou.com/)
- [Element Plus文档](https://element-plus.org/)

## 🤝 贡献指南 / Contributing

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📞 技术支持 / Support

- 联系电话: 17898898894
- 技术文档: 查看 `docs/` 目录
- 操作手册: 查看 `manual/` 目录

