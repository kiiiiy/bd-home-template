#!/usr/bin/env bash
set -euo pipefail

# 1. 환경 설정
APP_NAME="bd-home"
APP_USER="bdhome"
APP_DIR="/opt/bd-home"
ENV_FILE="/etc/${APP_NAME}.env"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"

echo "[1/6] 패키지 설치 (Java 17, Curl)"
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jre-headless curl

echo "[2/6] 유저 및 디렉토리 생성"
if ! id -u "${APP_USER}" >/dev/null 2>&1; then
    sudo useradd -r -s /usr/sbin/nologin "${APP_USER}"
fi
sudo mkdir -p "${APP_DIR}/db"
sudo chown -R "${APP_USER}:${APP_USER}" "${APP_DIR}"

echo "[3/6] 환경 변수 파일 생성: ${ENV_FILE}"
: "${JWT_SECRET:?JWT_SECRET 이 설정되지 않았습니다.}"
: "${ADMIN_PASSWORD_HASH:?ADMIN_PASSWORD_HASH 가 설정되지 않았습니다.}"

sudo bash -c "cat > '${ENV_FILE}'" <<EOF
JWT_SECRET=${JWT_SECRET}
ADMIN_PASSWORD_HASH=${ADMIN_PASSWORD_HASH}
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080
EOF

sudo chmod 600 "${ENV_FILE}"
sudo chown root:root "${ENV_FILE}"

echo "[4/6] Systemd 서비스 등록: ${SERVICE_FILE}"
sudo bash -c "cat > '${SERVICE_FILE}'" <<EOF
[Unit]
Description=BD Home Spring Boot Service
After=network.target

[Service]
Type=simple
User=${APP_USER}
WorkingDirectory=${APP_DIR}
EnvironmentFile=${ENV_FILE}
# 메모리 제한을 두어 OCI 무료 티어(최대 1GB/ARM 24GB)에서 안정적으로 구동
ExecStart=/usr/bin/java -Xms128m -Xmx512m -jar ${APP_DIR}/app.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "[5/6] 서비스 활성화"
sudo systemctl daemon-reload
sudo systemctl enable "${APP_NAME}"

echo "[6/6] 모든 설정 완료"
echo "-----------------------------------------------------------"
echo "다음 단계:"
echo "1. GitHub Actions를 통해 빌드된 JAR를 ${APP_DIR}/app.jar 로 전송하세요."
echo "2. 'sudo systemctl restart ${APP_NAME}' 명령어로 서비스를 시작하세요."
echo "-----------------------------------------------------------"