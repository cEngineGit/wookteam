# 安装教程

**[English Documentation](en/DOCKER.md)**

- **安装教程(Docker)**
- [安装教程(服务器)](SERVER.md)
- [安装教程(宝塔面板)](BT.md)

## 安装设置（使用Docker）

> 必须安装 `Docker` 和 `Docker Compose`

### 部署项目

```bash
# 1、克隆项目到您的本地或服务器

# 使用ssh
git clone git@github.com:kuaifan/wookteam.git
# 或者你也可以使用https
git clone https://github.com/kuaifan/wookteam.git

# 2、进入目录
cd wookteam

# 3、一键构建项目
./cmd install
```

安装完毕，项目地址为：**`http://IP:PORT`**（`PORT`默认为`8000`）。

### 更换端口

```bash
./cmd php bin/wookteam --port=8000 --ssl=44300
./cmd up -d
```

### 停止服务

```bash
./cmd stop
```

> 一旦应用程序被设置，无论何时你想要启动服务器(如果它被停止)运行以下命令

```bash
./cmd start
```

### 运行命令的快捷方式

> 你可以使用以下命令来执行

```bash
./cmd artisan "your command"          // 运行 artisan 命令
./cmd php "your command"              // 运行 php 命令
./cmd composer "your command"         // 运行 composer 命令
./cmd supervisorctl "your command"    // 运行 supervisorctl 命令
./cmd test "your command"             // 运行 phpunit 命令
./cmd npm "your command"              // 运行 npm 命令
./cmd yarn "your command"             // 运行 yarn 命令
./cmd mysql "your command"            // 运行 mysql 命令
```

## 默认账号

- admin/123456
- system/123456

## 升级更新

**注意：在升级之前请备份好你的数据！**

```bash
# 进入目录，运行命令
./cmd update
```
