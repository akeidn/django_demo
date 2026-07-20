# AGENT.md

## 项目概览

这是一个 Django + Vue 项目。

- 后端框架：Django 6.0.7
- 后台界面：django-simpleui
- 前端框架：Vue 3 + Vite
- 数据库：SQLite
- Python 虚拟环境：`.venv`

## 项目结构

- `manage.py`：Django 管理命令入口。
- `config/`：Django 项目配置和路由。
- `app/`：主 Django 应用。
- `frontend/`：使用 Vite 创建的 Vue 3 前端项目。
- `db.sqlite3`：本地 SQLite 数据库。
- `.venv/`：本地 Python 虚拟环境。

## 开发命令

启动 Django 后端：

```powershell
cd F:\project\codex\django_demo
.\.venv\Scripts\Activate.ps1
python manage.py runserver 127.0.0.1:8000
```

启动 Vue 前端：

```powershell
cd F:\project\codex\django_demo\frontend
npm run dev -- --host 127.0.0.1 --port 5173
```

构建 Vue 前端：

```powershell
cd F:\project\codex\django_demo\frontend
npm run build
```

检查 Django 配置：

```powershell
cd F:\project\codex\django_demo
.\.venv\Scripts\python.exe manage.py check
```

## 访问地址

- Vue 前台：`http://127.0.0.1:5173/`
- Django 后端根路径：`http://127.0.0.1:8000/`
- Django 后台：`http://127.0.0.1:8000/admin/`

开发阶段，Django 根路径会跳转到 Vue 前台。

## 后台账号

- 用户名：`akeidn`
- 邮箱：`1164796490@qq.com`
- 昵称：保存在 Django 默认用户模型的 `first_name` 字段中，值为 `akeidn`

不要把真实生产环境账号或密码写入版本库。这里的账号仅用于本地开发。

## 后端说明

- `simpleui` 必须放在 `INSTALLED_APPS` 中的 `django.contrib.admin` 之前。
- 默认语言为简体中文：`LANGUAGE_CODE = 'zh-hans'`。
- 默认时区为中国上海：`TIME_ZONE = 'Asia/Shanghai'`。
- `/admin/` 路径由 Django 后端提供。
- 除非明确调整部署方式，否则前台页面由 Vue/Vite 提供。

## 前端说明

- Vue 源码位于 `frontend/src/`。
- 前端开发服务器固定使用 `5173` 端口。
- Vue 页面中跳转到 Django 后端时，应使用后端完整地址，例如 `http://127.0.0.1:8000/admin/`。

## 验证清单

完成后端修改后，运行：

```powershell
.\.venv\Scripts\python.exe manage.py check
```

完成前端修改后，运行：

```powershell
npm run build
```

如果一次修改同时涉及前端和后端，需要同时运行以上两个检查。
