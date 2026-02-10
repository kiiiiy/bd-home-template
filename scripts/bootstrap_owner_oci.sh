#!/usr/bin/env bash
set -euo pipefail

need(){ command -v "$1" >/dev/null 2>&1; }
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "=========================================="
echo "   OCI Backend Bootstrap & Repo Setup     "
echo "=========================================="


if ! need gh; then 
    echo "==> Installing GitHub CLI..."
    sudo apt update -y && sudo apt install -y gh
fi

gh auth status >/dev/null 2>&1 || { echo "!! 먼저 실행하세요: gh auth login"; exit 1; }

OWNER="$(gh api user -q .login)"
OPS_REPO="${OPS_REPO:-bd-home-${OWNER}}"

echo "==> Owner: $OWNER"
echo "==> Target Repo: ${OWNER}/${OPS_REPO}"

echo "------------------------------------------"
echo " OCI VM 정보를 입력해주세요 (GitHub Secrets용)"
echo "------------------------------------------"
read -p "1) OCI VM 공용 IP (OCI_HOST): " OCI_HOST
read -p "2) VM 접속 계정 (OCI_SSH_USER, 보통 ubuntu): " OCI_SSH_USER
read -p "3) SSH Private Key 파일 경로 (예: ~/my_key.key): " KEY_PATH
read -p "4) 사용할 JWT Secret (임의입력): " JWT_SECRET
read -p "5) 관리자 비번 해시 (임의입력): " ADMIN_HASH

if [ -f "$KEY_PATH" ]; then
    SSH_KEY_CONTENT=$(cat "$KEY_PATH")
else
    echo "!! 키 파일을 찾을 수 없습니다: $KEY_PATH"; exit 1
fi


if ! gh repo view "${OWNER}/${OPS_REPO}" >/dev/null 2>&1; then
    echo "==> Creating new repository: ${OWNER}/${OPS_REPO}"
    gh repo create "${OWNER}/${OPS_REPO}" --public --confirm
else
    echo "==> Repository already exists."
fi

echo "==> Setting GitHub Secrets..."
gh secret set OCI_HOST -b"${OCI_HOST}" -R "${OWNER}/${OPS_REPO}"
gh secret set OCI_SSH_USER -b"${OCI_SSH_USER}" -R "${OWNER}/${OPS_REPO}"
gh secret set OCI_SSH_PRIVATE_KEY -b"${SSH_KEY_CONTENT}" -R "${OWNER}/${OPS_REPO}"
gh secret set JWT_SECRET -b"${JWT_SECRET}" -R "${OWNER}/${OPS_REPO}"
gh secret set ADMIN_PASSWORD_HASH -b"${ADMIN_HASH}" -R "${OWNER}/${OPS_REPO}"

echo "------------------------------------------"
echo " ✅ OCI 배포 준비 완료!"
echo " 이제 아래 명령어로 코드를 푸시하면 배포가 시작됩니다."
echo " git remote add ops https://github.com/${OWNER}/${OPS_REPO}.git"
echo " git push ops main"
echo "------------------------------------------"