# 腾讯云 EdgeOne Pages 部署指南

本指南将帮助您将 Homepage 项目部署到腾讯云 EdgeOne Pages。

## 重要说明

Homepage 原本是一个需要服务器端运行的应用程序（通过 Docker 部署），包含了许多服务器端功能：
- Docker 容器监控
- Kubernetes 集群状态
- 服务健康检查
- API 代理
- 实时数据更新

**在 EdgeOne Pages 上部署时，这些服务器端功能将不可用**，因为 EdgeOne Pages 只支持静态站点托管。

## 适用场景

EdgeOne Pages 部署适合以下场景：
- 您只需要展示静态书签和链接
- 您不需要实时的 Docker/Kubernetes 监控
- 您不需要服务健康检查和状态更新
- 您只需要一个快速、全球分发的静态首页

如果您需要完整的服务器端功能，建议继续使用 Docker 部署方式。

## 部署步骤

### 1. 准备配置文件

确保您的配置文件位于 `src/skeleton` 目录或项目根目录的 `config` 目录中：
- `settings.yaml` - 基本设置
- `bookmarks.yaml` - 书签配置
- `services.yaml` - 服务配置（仅显示，无实时状态）
- `widgets.yaml` - 小部件配置（部分功能受限）

### 2. 本地构建测试

```bash
# 安装依赖
pnpm install

# 使用 EdgeOne 配置构建
pnpm run build:edgeone

# 检查输出目录
ls -la out/
```

构建成功后，会在 `out/` 目录生成静态文件。

### 3. 腾讯云 EdgeOne Pages 部署

#### 方式一：通过 Git 仓库部署

1. 登录 [腾讯云 EdgeOne 控制台](https://console.cloud.tencent.com/edgeone)
2. 进入 Pages 服务
3. 选择 "创建项目"
4. 连接您的 Git 仓库（GitHub/GitLab/Gitee）
5. 配置构建设置：
   - **构建命令**: `pnpm install && pnpm run build:edgeone`
   - **输出目录**: `out`
   - **Node.js 版本**: 22
6. 点击 "部署"

#### 方式二：通过 CLI 部署

```bash
# 安装 EdgeOne CLI（如果有的话）
# npm install -g @tencent/edgeone-cli

# 构建项目
pnpm run build:edgeone

# 部署到 EdgeOne Pages
# edgeone deploy
```

### 4. 配置环境变量（可选）

在 EdgeOne Pages 控制台中，您可以配置以下环境变量：

- `NEXT_PUBLIC_BUILDTIME` - 构建时间（自动设置）
- `NODE_ENV` - 设置为 `production`

### 5. 自定义域名

在 EdgeOne Pages 控制台中：
1. 进入项目设置
2. 添加自定义域名
3. 配置 DNS 记录（CNAME）
4. 等待 SSL 证书自动配置

## 功能限制说明

在 EdgeOne Pages 静态部署模式下，以下功能**不可用**：

### 不可用的功能
- ❌ Docker 容器状态监控
- ❌ Kubernetes 集群状态
- ❌ 服务健康检查（ping、站点监控）
- ❌ 实时服务 API 代理
- ❌ 动态配置重载
- ❌ 服务器端 API 路由
- ❌ i18n 多语言路由（需要在构建时选择单一语言）

### 可用的功能
- ✅ 静态书签展示
- ✅ 静态服务链接
- ✅ 主题切换（本地存储）
- ✅ 搜索功能（客户端）
- ✅ 自定义 CSS/JS（需要转换为静态文件）
- ✅ 静态小部件（时间、日期等）

## 混合部署方案（推荐）

如果您需要保留服务器端功能，建议采用混合部署：

1. **前端**: 部署到 EdgeOne Pages（快速全球分发）
2. **后端 API**: 部署到服务器（Docker/云服务器）
   - 保留所有 API 路由功能
   - 提供 Docker/Kubernetes 监控
   - 处理服务代理和健康检查

3. **配置前端调用后端**:
   修改前端配置，使 API 请求指向后端服务器：
   ```javascript
   // 在 next.config.edgeone.js 中添加
   env: {
     NEXT_PUBLIC_API_URL: 'https://your-backend-server.com'
   }
   ```

## 故障排除

### 构建失败

如果构建失败，检查：
1. Node.js 版本是否为 22
2. 是否使用了 pnpm 包管理器
3. 配置文件是否存在语法错误

### 页面无法加载

1. 检查 EdgeOne Pages 控制台的部署日志
2. 确认输出目录设置为 `out`
3. 检查浏览器控制台错误

### API 请求失败

静态导出模式下，所有 `/api/*` 路由都不可用。如需 API 功能，请使用混合部署方案。

## 文件说明

- `next.config.edgeone.js` - EdgeOne Pages 专用的 Next.js 配置
- `edgeone.json` - EdgeOne Pages 部署配置
- `EDGEONE_DEPLOYMENT.md` - 本部署文档

## 更多资源

- [腾讯云 EdgeOne Pages 文档](https://cloud.tencent.com/document/product/1552)
- [Next.js 静态导出文档](https://nextjs.org/docs/app/building-your-application/deploying/static-exports)
- [Homepage 官方文档](https://gethomepage.dev/)

## 回到标准部署

如果您想回到标准的 Docker 部署方式：

```bash
# 使用标准构建命令
pnpm run build

# 或使用 Docker
docker build -t homepage .
docker run -p 3000:3000 homepage
```

标准部署方式将提供完整的功能支持。
