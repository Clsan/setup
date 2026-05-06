# Mac Setup

새 Mac에 개인/업무 환경을 단 한 번에 셋업.
대부분 비대면으로 진행되고, 사람 손길이 필요한 단계는 마지막에 한 번에 모아둠.

## Personal Setup

```bash
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/common.sh -o common.sh && \
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/system_setup.sh -o system_setup.sh && \
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/interactive_setup.sh -o interactive_setup.sh && \
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/setup.sh -o setup.sh && \
bash setup.sh
```

## Work Setup

```bash
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/common.sh -o common.sh && \
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/system_setup.sh -o system_setup.sh && \
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/interactive_setup.sh -o interactive_setup.sh && \
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/setup.sh -o setup.sh && \
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/work_setup.sh -o work_setup.sh && \
bash work_setup.sh
```

## 스크립트 구성

| 파일 | 역할 |
|---|---|
| `common.sh` | sudo 캐시, caffeinate, Xcode CLT, Homebrew |
| `setup.sh` | 개인용: CLI/GUI 앱, mise + 런타임, Python, Colima, Rectangle, SSH key |
| `system_setup.sh` | macOS 시스템 설정 (단축키, 키보드/마우스 속도, Dock, sleep, 기본 브라우저) |
| `interactive_setup.sh` | 사람 손길 필요한 마지막 단계 (Rectangle accessibility, GitHub OTP 로그인) |
| `work_setup.sh` | `setup.sh` + Claude Code, Okta Verify |

## 진행 흐름

1. 비대면 단계: Homebrew, 모든 brew 설치, mise 런타임, 시스템 설정 등 자동 진행
2. **알림 + 벨이 울리면** 돌아와서 마지막 인터랙티브 단계 처리:
   - Rectangle accessibility 토글 (시스템 설정에서 클릭)
   - GitHub 브라우저 OTP 로그인 (한 번)
3. 끝

## 주요 시스템 설정

- 키 반복 속도: 슬라이더 양 끝 (`KeyRepeat=2`, `InitialKeyRepeat=15`) — **로그아웃 후 적용**
- 마우스/트랙패드 속도: `2.0` (slider 끝에서 ~3칸)
- Cmd+Space → 입력 소스 변경 / Ctrl+Space → Spotlight
- AC 슬립 비활성화 (`pmset -c sleep 0`) — 백그라운드 작업 유지
- Dock: Calendar 만 남김, 자동 숨김
