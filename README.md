**BD HomePage**

***전체 구조**

bd-home-template/

├─ backend/              # (자동 생성됨) Spring Boot 백엔드

├─ frontend/             # (자동 생성됨) 정적 HTML/JS 프론트

├─ scripts/              # 운영자용 bootstrap 스크립트

├─ .github/workflows/    # CI/CD (Fly.io, GitHub Pages)

└─ README.md





***사용 방법**

**Step 1: OCI 가상 컴퓨터(VM) 준비**

Oracle Cloud에 가입하고 로그인합니다

인스턴스 생성을 클릭합니다

- OS: Ubuntu 22.04 또는 24.04 (최소 사양도 가능)

- 네트워킹: '공용 IP 주소 할당'을 반드시 체크하세요.

- SSH 키: '전용 키 저장'을 눌러 .key 파일을 컴퓨터에 잘 보관하세요. (매우 중요!)

생성된 인스턴스의 공용 IP 주소를 복사해둡니다


**Step 2: 방화벽(포트) 열기**

백엔드 서버(8080 포트)에 접속할 수 있도록 문을 열어줘야 합니다

OCI 콘솔에서 가상 클라우드 네트워크(VCN) -> 보안 리스트(Security List)로 들어갑니다


수신 규칙(Ingress Rule)을 추가합니다

소스 CIDR: 0.0.0.0/0

대상 포트 범위: 8080

설명: Backend API


**Step 3: 나만의 운영 레포지토리 생성 (초기 설정)**

이제 본인의 컴퓨터 터미널(WSL, Linux, Mac 등)에서 아래 명령어를 순서대로 입력하세요

이 템플릿을 클론합니다

- git clone https://github.com/사용자이름/bd-homepage.git
- cd bd-homepage

초기화 스크립트를 실행합니다 (GitHub CLI 로그인이 필요할 수 있습니다)


- chmod +x scripts/bootstrap_owner_oci.sh
- ./scripts/bootstrap_owner_oci.sh


스크립트가 물어보는 OCI_HOST(IP), SSH 키 경로 등을 입력하면, 본인의 GitHub 계정에 새 레포지토리가 생성되고 모든 Secrets가 자동으로 세팅됩니다


**Step 4: 서버 기초 공사 (Bootstrap)**

생성된 본인의 GitHub 레포지토리 페이지로 이동합니다

상단의 [Actions] 탭을 클릭합니다

왼쪽 메뉴에서 **OCI Bootstrap (one-time setup)**을 선택합니다

오른쪽의 Run workflow 버튼을 클릭하여 실행합니다

이 과정에서 서버에 Java 17이 설치되고 백엔드 구동 환경이 완벽하게 세팅됩니다


**Step 5: 코드 푸시 및 배포 확인**

이제 코드를 수정하고 푸시하기만 하면 됩니다

본인의 레포지토리에 코드를 푸시합니다

- git add .
- git commit -m "First deploy"
- git push origin main


[Actions] 탭의 Deploy Backend to OCI VM 워크플로우가 초록색(✅)으로 변하는지 확인합니다

브라우저에서 사이트가 잘 뜨는지 확인합니다!

- API 서버: http://<내-OCI-IP>:8080/api/health

- 프론트엔드: https://<내-아이디>.github.io/<레포이름>/



💡 **접속이 안 되나요?** OCI 방화벽(8080)을 열었는지 다시 확인

💡 **배포가 실패했나요?** GitHub Secrets에 OCI_SSH_PRIVATE_KEY 내용이 올바르게 들어갔는지 확인하세요 (-----BEGIN RSA PRIVATE KEY-----부터 끝까지 모두 포함되어야 합니다)


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
