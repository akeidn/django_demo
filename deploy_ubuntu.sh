#!/usr/bin/env bash
set -euo pipefail

APP_NAME="django_demo"
APP_DIR="/opt/${APP_NAME}"
REPO_URL="https://github.com/akeidn/django_demo.git"
DOMAIN_OR_IP="${DOMAIN_OR_IP:-47.122.124.86}"
DJANGO_SECRET_KEY="${DJANGO_SECRET_KEY:-$(openssl rand -hex 32)}"

apt update
apt install -y git curl nginx python3 python3-venv python3-pip

if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt install -y nodejs
fi

if [ ! -d "${APP_DIR}/.git" ]; then
  rm -rf "${APP_DIR}"
  git clone "${REPO_URL}" "${APP_DIR}"
else
  git -C "${APP_DIR}" pull --ff-only
fi

cd "${APP_DIR}"

python3 -m venv .venv
. .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

cd frontend
npm install
npm run build
cd ..

cat > .env.production <<EOF
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=${DOMAIN_OR_IP},127.0.0.1,localhost
DJANGO_CSRF_TRUSTED_ORIGINS=http://${DOMAIN_OR_IP},https://${DOMAIN_OR_IP}
DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
EOF

set -a
. ./.env.production
set +a

python manage.py collectstatic --noinput
python manage.py migrate

cat > /etc/systemd/system/${APP_NAME}.service <<EOF
[Unit]
Description=Wuhan Yiyao Django Vue website
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=${APP_DIR}
EnvironmentFile=${APP_DIR}/.env.production
ExecStart=${APP_DIR}/.venv/bin/gunicorn config.wsgi:application --bind 127.0.0.1:8000 --workers 2
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/nginx/sites-available/${APP_NAME} <<EOF
server {
    listen 80;
    server_name ${DOMAIN_OR_IP};

    client_max_body_size 20M;

    location /static/ {
        alias ${APP_DIR}/staticfiles/;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/${APP_NAME} /etc/nginx/sites-enabled/${APP_NAME}
rm -f /etc/nginx/sites-enabled/default

nginx -t
systemctl daemon-reload
systemctl enable ${APP_NAME}
systemctl restart ${APP_NAME}
systemctl restart nginx

echo "Deployment finished: http://${DOMAIN_OR_IP}"
