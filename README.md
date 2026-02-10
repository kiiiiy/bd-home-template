**BD HomePage**

***전체 구조**

bd-home-template/

├─ backend/              # (자동 생성됨) Spring Boot 백엔드

├─ frontend/             # (자동 생성됨) 정적 HTML/JS 프론트

├─ scripts/              # 운영자용 bootstrap 스크립트

├─ .github/workflows/    # CI/CD (Fly.io, GitHub Pages)

└─ README.md





***사용 방법**

0️⃣ 사전 준비

GitHub 계정

Oracle Cloud (OCI) 계정 및 VM 생성 완료

GitHub Secrets에 OCI_HOST, OCI_SSH_KEY 등 등록 (상세 내용은 아래 참조)

1️⃣ 템플릿 clone

git clone https://github.com/<owner>/bd-home-template.git
cd bd-home-template

2️⃣ 서버 초기 세팅 (최초 1회)

GitHub Actions 탭 이동 → OCI Bootstrap 워크플로우 실행


3️⃣ 코드 배포

main 브랜치에 push 하면 자동으로 백엔드가 빌드되어 OCI VM으로 전송됩니다.

4️⃣ 배포 확인

백엔드(OCI): http://<OCI-공용-IP>:8080/api/health

프론트엔드(GitHub Pages): https://<github-id>.github.io/<repo-name>/

**Secrets 목록**
- `OCI_HOST` : VM 공인 IP
- `OCI_SSH_USER` : 보통 `ubuntu`
- `OCI_SSH_PRIVATE_KEY` : private key 전체(-----BEGIN ... END-----)
- `OCI_SSH_PORT` : (선택) 기본 22면 없어도 됨
- `JWT_SECRET`
- `ADMIN_PASSWORD_HASH`


***Dev Stack**

Backend: Spring Boot + OCI

Frontend: HTML / JS + GitHub Pages

CI/CD: GitHub Actions
