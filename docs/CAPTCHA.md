# 验证码功能说明 / Captcha Guide

## 📋 验证码状态

当前验证码功能：**已启用** ✅

## 🔐 登录流程

### 完整的登录流程

1. **获取验证码**
```bash
curl 'http://localhost:48081/admin-api/system/captcha/get' \
  -H 'Content-Type: application/json' \
  -H 'tenant-id: 1' \
  --data-raw '{"captchaType":"blockPuzzle"}'
```

返回示例：
```json
{
  "repCode": "0000",
  "repData": {
    "originalImageBase64": "data:image/png;base64,...",
    "jigsawImageBase64": "data:image/png;base64,...",
    "token": "abc123...",
    "secretKey": "xyz789..."
  }
}
```

2. **完成拼图验证**
- 前端展示拼图
- 用户拖动滑块
- 调用验证接口

3. **提交登录请求**
```bash
curl 'http://localhost:48081/admin-api/system/auth/login' \
  -H 'Content-Type: application/json' \
  -H 'tenant-id: 1' \
  --data-raw '{
    "username": "metaxk",
    "password": "111111",
    "captchaVerification": "验证码验证token"
  }'
```

## ⚙️ 启用/禁用验证码

### 当前配置位置
文件：`deployment/start.sh`

### 禁用验证码（开发/测试环境）

修改 `deployment/start.sh`：
```bash
-Dmetaxk.captcha.enable=false  # 改为 false
```

然后重启服务：
```bash
docker-compose down mes-server-api
docker-compose build mes-server-api
docker-compose up -d mes-server-api
```

### 启用验证码（生产环境推荐）

修改 `deployment/start.sh`：
```bash
-Dmetaxk.captcha.enable=true  # 改为 true
```

然后重启服务（同上）。

## 🐛 常见问题

### Q1: 登录提示"验证码不能为空"
**原因**：验证码功能已启用，但未提供验证码。

**解决方案**：
- 前端：确保登录请求包含 `captchaVerification` 字段
- 后端测试：临时禁用验证码（见上文）

### Q2: 验证码接口返回500错误
**原因**：Docker容器缺少图形库。

**解决方案**：
- ✅ 已使用 `eclipse-temurin:11-jdk` 镜像（包含图形库）
- ✅ 如果仍有问题，检查 `deployment/Dockerfile` 第一行

### Q3: 验证码图片无法显示
**原因**：base64图片数据格式问题。

**解决方案**：
- 检查返回的 `originalImageBase64` 和 `jigsawImageBase64`
- 确保前端正确解析base64数据

### Q4: 验证码验证总是失败
**原因**：可能是滑动距离计算不准确。

**解决方案**：
- 检查前端验证组件的滑动距离计算
- 查看后端日志获取详细错误信息

## 🔧 前端集成示例

### Vue 3 示例

```vue
<template>
  <div>
    <el-form>
      <el-form-item>
        <el-input v-model="form.username" placeholder="用户名" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="form.password" type="password" placeholder="密码" />
      </el-form-item>
    </el-form>
    
    <!-- 验证码组件 -->
    <verify-slide 
      v-if="captchaEnabled"
      @success="handleCaptchaSuccess"
    />
    
    <el-button @click="handleLogin">登录</el-button>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { getCodeApi, loginApi } from '@/api'

const captchaEnabled = ref(true)
const form = ref({
  username: '',
  password: '',
  captchaVerification: ''
})

// 验证码验证成功回调
const handleCaptchaSuccess = (verification) => {
  form.value.captchaVerification = verification
}

// 登录
const handleLogin = async () => {
  if (captchaEnabled.value && !form.value.captchaVerification) {
    ElMessage.error('请完成验证码验证')
    return
  }
  
  const result = await loginApi(form.value)
  if (result.code === 0) {
    ElMessage.success('登录成功')
    // 跳转到首页
  }
}
</script>
```

## 📊 验证码配置

### application.yaml 配置
```yaml
aj:
  captcha:
    type: blockPuzzle              # 验证码类型（滑块拼图）
    cache-type: redis              # 缓存类型
    jigsaw: classpath:images/jigsaw  # 拼图图片路径
    water-mark: 万界星空科技        # 水印文字
    interference-options: 0        # 干扰项（0/1/2）
    req-frequency-limit-enable: false  # 频率限制

metaxk:
  captcha:
    enable: true                   # 启用验证码
```

## 🔗 相关文档

- [部署文档](./DEPLOYMENT.md)
- [开发文档](./DEVELOPMENT.md)
- [注意事项](./NOTES.md)

## 💡 建议

### 开发环境
- ⚠️ 可以禁用验证码，方便调试
- ⚠️ 确保在提交代码前启用验证码测试

### 生产环境
- ✅ 必须启用验证码，增强安全性
- ✅ 定期更换验证码图片库
- ✅ 监控验证码接口的性能

---

**最后更新**: 2025-10-01

