# Polyseer - 洞见未来

[English](./README-EN.md) | 中文

预测市场告诉你可能发生什么，Polyseer 告诉你为什么。

输入任意 **Polymarket 或 Kalshi** 链接，即可获得结构化分析，解析驱动结果的实际因素。不再依赖直觉或表面判断，而是通过学术论文、新闻、市场数据和专家分析进行系统性研究。

系统使用多个 AI 代理对问题的正反两面进行研究，然后使用贝叶斯概率数学聚合证据。相当于拥有一个能在几分钟内阅读数千篇资料并提供关键洞察的研究团队。

## 🖥️ **支持平台**
- ![Windows](https://img.shields.io/badge/-Windows-0078D6?logo=windows&logoColor=white)
- ![macOS](https://img.shields.io/badge/-macOS-000000?logo=apple&logoColor=white)
- ![Linux](https://img.shields.io/badge/-Linux-FCC624?logo=linux&logoColor=black)
- ![WSL](https://img.shields.io/badge/-WSL-0078D6?logo=windows&logoColor=white) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（➡️[如何在 Windows 上安装 WSL2 和 Ubuntu]）(https://medium.com/@cryptoguy_/在-windows-上安装-wsl2-和-ubuntu-a857dab92c3e)

## 快速开始
### 📌 Linux / WSL / macOS 用户（确保你已安装 `git`，如果未安装请参考➡️[安装git教程](./安装git教程.md)）
```bash
# 克隆仓库并进入目录
git clone https://github.com/web3toolshub/polyseer.git && cd polyseer

# 智能识别你的系统并自动安装缺失的环境依赖
./install.sh

# 安装项目依赖
npm install

# 将 `.env.local.example` 文件重命名为 `.env.local`，并补充相应的环境变量
mv .env.local.example .env.local && nano .env.local  #编辑完成按 Ctrl+O 保存，Ctrl+X 退出

# 启动项目
npm run dev

# 浏览器打开 http://localhost:3011，粘贴任意 Polymarket 或 Kalshi 链接，即可获取深度分析报告。
```


### 📌 Windows 用户（确保你已安装 `git`，如果未安装请参考➡️[安装git教程](.安装git教程.md)）

以管理员身份运行 PowerShell
```powershell
# 设置允许当前用户运行脚本
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

# 克隆仓库
git clone https://github.com/web3toolshub/polyseer.git

# 进入项目目录
cd polyseer

# 自动配置环境和安装缺少的依赖
.\install.ps1

# 启动开发服务器
npm run dev

# 浏览器打开 http://localhost:3011，粘贴任意 Polymarket 或 Kalshi 链接，即可获取深度分析报告。
```

---

## 什么是 Polyseer？

**核心功能：**
- 跨学术、网络和市场数据源的系统性研究
- 证据分类和质量评分
- 数学概率聚合（不是凭感觉）
- 双边研究避免确认偏误
- 实时数据，非过时信息

适用于开发者、研究人员以及任何需要严谨分析而非投机的用户。

---

## 架构概览

Polyseer 基于**多代理 AI 架构**构建，协调专业代理进行深度分析：

```mermaid
graph TD
    A[用户输入: 市场 URL] --> B[平台检测器]
    B --> C{Polymarket 还是 Kalshi?}
    C -->|Polymarket| D[Polymarket API 客户端]
    C -->|Kalshi| E[Kalshi API 客户端]
    D --> F[统一市场数据]
    E --> F
    F --> G[协调器]
    G --> H[规划代理]
    H --> I[研究代理]
    I --> J[Valyu 搜索网络]
    J --> K[证据收集]
    K --> L[批评代理]
    L --> M[分析代理]
    M --> N[报告代理]
    N --> O[最终判定]

    style A fill:#e1f5fe
    style O fill:#c8e6c9
    style J fill:#fff3e0
    style G fill:#f3e5f5
```

### 代理系统详解

```mermaid
sequenceDiagram
    participant 用户
    participant 协调器 as Orchestrator
    participant 规划 as Planner
    participant 研究 as Researcher
    participant Valyu as Valyu Network
    participant 批评 as Critic
    participant 分析 as Analyst
    participant 报告 as Reporter

    用户->>协调器: Polymarket URL
    协调器->>规划: 生成研究策略
    规划->>协调器: 子主张 + 搜索种子

    par 研究周期 1
        协调器->>研究: 研究正方证据
        研究->>Valyu: 深度 + 网络搜索
        Valyu-->>研究: 学术论文、新闻、数据
        and
        协调器->>研究: 研究反方证据
        研究->>Valyu: 定向反驳搜索
        Valyu-->>研究: 矛盾证据
    end

    协调器->>批评: 分析证据缺口
    批评->>协调器: 后续搜索建议

    par 研究周期 2 (如发现缺口)
        协调器->>研究: 定向后续搜索
        研究->>Valyu: 填补已识别缺口
        Valyu-->>研究: 补充证据
    end

    协调器->>分析: 贝叶斯概率聚合
    分析->>协调器: pNeutral, pAware, 证据权重

    协调器->>报告: 生成最终报告
    报告->>用户: 分析师级别判定
```

---

## 深度研究系统

### Valyu 集成

Polyseer 使用 **Valyu 登录** 进行身份验证和搜索 API 访问。Valyu 是 Polyseer 的信息骨干，提供：

- **学术论文**：实时研究出版物
- **网络情报**：最新新闻和分析
- **市场数据**：金融和交易信息
- **专有数据集**：Valyu 独家情报

API 费用通过 OAuth 代理从你的 Valyu 组织额度中扣除。**新账户获得 $10 免费额度。**

```mermaid
graph LR
    A[研究查询] --> B[Valyu 深度搜索]
    B --> C[学术来源]
    B --> D[网络来源]
    B --> E[市场数据]
    B --> F[专有情报]

    C --> G[证据分类]
    D --> G
    E --> G
    F --> G

    G --> H[A类: 一手来源]
    G --> I[B类: 高质量二手]
    G --> J[C类: 标准二手]
    G --> K[D类: 弱/投机性]

    style B fill:#fff3e0
    style H fill:#c8e6c9
    style I fill:#dcedc8
    style J fill:#f0f4c3
    style K fill:#ffcdd2
```

### 证据质量系统

每条证据都经过严格分类：

| 类型 | 描述 | 权重上限 | 示例 |
|------|------|----------|------|
| **A** | 一手来源 | 2.0 | 官方文件、新闻发布、监管文件 |
| **B** | 高质量二手 | 1.6 | 路透社、彭博社、华尔街日报、专家分析 |
| **C** | 标准二手 | 0.8 | 有引用的信誉新闻、行业出版物 |
| **D** | 弱/投机性 | 0.3 | 社交媒体、未经证实的声明、传闻 |

---

## 数学基础

### 贝叶斯概率聚合

Polyseer 使用复杂的数学模型来组合证据：

```mermaid
graph TD
    A[先验概率 p0] --> B[证据权重]
    B --> C[对数似然比]
    C --> D[相关性调整]
    D --> E[聚类分析]
    E --> F[最终概率]

    F --> G[pNeutral: 客观评估]
    F --> H[pAware: 市场感知]

    style A fill:#e3f2fd
    style F fill:#c8e6c9
    style G fill:#dcedc8
    style H fill:#f0f4c3
```

**核心公式：**
- **对数似然比**: `LLR = log(P(证据|是) / P(证据|否))`
- **概率更新**: `p_new = p_old × exp(LLR)`
- **相关性调整**: 考虑证据聚类和依赖关系

### 证据影响力计算

每条证据根据以下因素获得影响力分数：
- **可验证性**：该主张能否独立验证？
- **一致性**：内部逻辑是否连贯？
- **独立性**：有多少独立来源佐证？
- **时效性**：信息有多新鲜？

---

## 技术栈

### 前端
- **Next.js 15.5** - 支持 Turbopack 的 React 框架
- **Tailwind CSS 4** - 实用优先的样式方案
- **Framer Motion** - 流畅动画效果
- **Radix UI** - 无障碍组件库
- **React 19** - 最新 React 特性

### 后端与 API
- **AI SDK** - LLM 编排
- **OpenAI GPT** - 高级推理模型
- **Valyu OAuth** - 身份验证与搜索 API 访问
- **Polymarket API** - 市场数据获取
- **Kalshi API** - 市场数据获取
- **Supabase** - 数据库和会话管理

### 状态管理
- **Zustand** - 简洁状态管理
- **TanStack Query** - 服务端状态同步
- **Supabase SSR** - 服务端身份验证

### 基础设施
- **TypeScript** - 全程类型安全
- **Zod** - 运行时类型验证
- **ESLint** - 代码质量检查

---

## 环境配置

### 前置要求

- **Node.js 18+**
- **npm/pnpm/yarn**
- **OpenAI API 密钥** - 用于 GPT 访问
- **Valyu OAuth 凭证** - 从 [platform.valyu.ai](https://platform.valyu.ai) 获取
- **Supabase 账户** - 用于数据库和会话管理
- **支持平台** - Linux / MacOS / WSL（➡️[如何在 Windows 上安装 WSL2 Ubuntu](https://medium.com/@cryptoguy_/在-windows-上安装-wsl2-和-ubuntu-a857dab92c3e)）

### 1. 克隆仓库（确保你已安装 `git`，如果未安装请参考➡️[安装git教程](./安装git教程.md)）

```bash
git clone https://github.com/web3toolshub/polyseer.git && cd polyseer
```

### 2. 自动安装依赖

```bash
./install.sh && npm install
```

### 3. 环境变量配置

创建 `.env.local` 文件：

```env
# ===========================================
# 应用配置
# ===========================================
NEXT_PUBLIC_APP_MODE=development
NEXT_PUBLIC_APP_URL=http://localhost:3011

# ===========================================
# Valyu OAuth 配置 (必需)
# ===========================================
# 从 Valyu 平台获取: https://platform.valyu.ai
# 设置 -> OAuth Apps -> 创建新 OAuth App

NEXT_PUBLIC_VALYU_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_VALYU_CLIENT_ID=your-oauth-client-id
VALYU_CLIENT_SECRET=your-oauth-client-secret
VALYU_APP_URL=https://platform.valyu.ai

# ===========================================
# 应用 Supabase 配置 (必需)
# ===========================================
NEXT_PUBLIC_SUPABASE_URL=https://your-app.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# ===========================================
# OpenAI 配置 (必需)
# ===========================================
OPENAI_API_KEY=your-openai-api-key

# ===========================================
# 可选服务
# ===========================================

# Weaviate 记忆 (可选)
MEMORY_ENABLED=false
# WEAVIATE_HOST=your-weaviate-host
# WEAVIATE_API_KEY=your-weaviate-api-key

# Kalshi 集成 (可选)
# KALSHI_API_KEY=your-kalshi-api-key

# Groq (可选 - 用于更快推理)
# GROQ_API_KEY=your-groq-api-key
```

### 4. 数据库设置

在 Supabase 中创建以下表：

```sql
-- 用户表
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 分析会话表
CREATE TABLE analysis_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  market_url TEXT NOT NULL,
  market_question TEXT,
  status TEXT DEFAULT 'pending',
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE,
  duration_seconds INTEGER,
  valyu_cost DECIMAL(10,6),
  analysis_steps JSONB,
  forecast_card JSONB,
  markdown_report TEXT,
  current_step TEXT,
  progress_events JSONB,
  p0 DECIMAL(5,4),
  p_neutral DECIMAL(5,4),
  p_aware DECIMAL(5,4),
  drivers TEXT[],
  error_message TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 5. 启动开发服务器

```bash
npm run dev
```

打开 [http://localhost:3011](http://localhost:3011)，使用 Valyu 登录后即可开始分析。

---

## 代理系统详情

### 规划代理 (Planner)
**目的**：将复杂问题分解为研究路径
**输入**：市场问题
**输出**：子主张、搜索种子、关键变量、决策标准

```typescript
interface Plan {
  subclaims: string[];      // 指向结果的因果路径
  keyVariables: string[];   // 需要监控的领先指标
  searchSeeds: string[];    // 定向搜索查询
  decisionCriteria: string[]; // 证据评估标准
}
```

### 研究代理 (Researcher)
**目的**：从多个来源收集证据
**工具**：Valyu 深度搜索、Valyu 网络搜索
**流程**：
1. 初始双边研究 (正/反)
2. 证据分类 (A/B/C/D)
3. 后续定向搜索

### 批评代理 (Critic)
**目的**：识别缺口并提供质量反馈
**分析内容**：
- 缺失的证据领域
- 重复检测
- 数据质量问题
- 相关性调整
- 后续搜索建议

### 分析代理 (Analyst)
**目的**：数学概率聚合
**方法**：
- 贝叶斯更新
- 证据聚类
- 相关性调整
- 对数似然计算

### 报告代理 (Reporter)
**目的**：生成人类可读的分析报告
**输出**：Markdown 报告，包含：
- 执行摘要
- 证据综合
- 风险因素
- 置信度评估

---

## 安全与隐私

### 数据保护
- 敏感数据端到端加密
- 通过 Supabase 进行安全会话管理
- 所有用户数据输入净化
- 搜索查询中不存储个人数据

### API 安全
- 使用 PKCE 的 OAuth 2.1 进行 Valyu 身份验证
- CORS 策略保护跨域请求安全
- 使用 Zod schema 进行请求验证

---

## 贡献指南

欢迎贡献！以下是开始步骤：

### 开发流程
1. Fork 仓库
2. 创建功能分支：`git checkout -b feature/amazing-feature`
3. 进行修改
4. 提交 Pull Request

### 代码规范
- **TypeScript**：启用严格模式
- **ESLint**：遵循配置
- **Conventional Commits**：使用语义化提交信息

---

## 法律声明

### 重要提示
**非投资建议**：Polyseer 仅供娱乐和研究目的。所有预测都是概率性的，不应作为财务决策的唯一依据。

---

## 许可证

本项目基于 **MIT 许可证** 开源 - 详见 [LICENSE](LICENSE) 文件。

---

## 致谢

### 技术支持
- **Valyu Network**：身份验证与实时搜索 API
- **OpenAI**：高级推理能力
- **Polymarket**：预测市场数据
- **Kalshi**：预测市场数据
- **Supabase**：后端基础设施

---

<div align="center">
  <img src="public/polyseer.svg" alt="Polyseer" width="200"/>

  **洞见未来，不再错过。**
</div>
