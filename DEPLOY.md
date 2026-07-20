# 部署说明

## 当前项目部署范围

可以部署到公网的部分：

- Vue 企业官网前台
- Django 联系表单 API
- Django simple-ui 后台管理
- SQLite 本地演示数据库

不建议直接部署到公网的部分：

- `acs-bridge`
- ACS 硬件控制接口

ACS 硬件控制需要运行在连接真实 ACS 控制器的本地工控机上，并通过 VPN、Tailscale、ZeroTier 或企业内网安全访问。

## Render 免费部署

1. 把 `F:\project\codex\django_demo` 上传到 GitHub。
2. 登录 Render。
3. 新建 Blueprint，选择该 GitHub 仓库。
4. Render 会读取 `render.yaml` 自动部署。
5. 部署完成后访问 Render 分配的 `.onrender.com` 地址。

## 云服务器部署

在服务器上安装：

- Python 3.13
- Node.js 24+
- Nginx

执行：

```bash
pip install -r requirements.txt
cd frontend
npm install
npm run build
cd ..
python manage.py collectstatic --noinput
python manage.py migrate
gunicorn config.wsgi:application --bind 127.0.0.1:8000
```

然后用 Nginx 反向代理到 `127.0.0.1:8000`。

## 本地生产模式验证

```powershell
cd F:\project\codex\django_demo\frontend
npm install
npm run build
cd ..
.\.venv\Scripts\python.exe manage.py collectstatic --noinput
.\.venv\Scripts\python.exe manage.py migrate
.\.venv\Scripts\python.exe manage.py runserver 127.0.0.1:8000
```

访问：

- 前台：`http://127.0.0.1:8000/`
- 后台：`http://127.0.0.1:8000/admin/`
- 联系表单 API：`http://127.0.0.1:8000/api/contracts/`
