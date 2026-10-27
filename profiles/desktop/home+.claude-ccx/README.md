# ccx

`ccx`는 opencode-go의 모델로 Claude Code를 실행하는 래퍼다. 설정 디렉터리(`~/.claude-ccx`)와 환경변수(1Password dotenv)를 평소 쓰는 `claude`와 분리한다.

builtin `WebSearch`는 Anthropic 서버가 실행하는 server-side tool이라 opencode-go 엔드포인트에서 동작하지 않는다. 대신 MCP 서버(Exa, Kagi 등)로 검색한다.

## 구성

이 디렉터리는 dotfiles의 `profiles/desktop/home+.claude-ccx/`이고, 자식 파일이 glob으로 `~/.claude-ccx/`에 심볼릭 링크된다.

| 파일            | 역할                                     |
| --------------- | ---------------------------------------- |
| `README.md`     | 이 문서                                  |
| `CLAUDE.md`     | 전역 지침                                |
| `settings.json` | 모델별 `autoCompactWindow` 등 설정       |
| `mcp.json`      | MCP 서버 정의 (exa, context7, mdn, kagi) |
| `rules/`        | 전역 규칙 (웹 최신성 정책)               |
| `skills/`       | 스킬                                     |

런처는 `profiles/desktop/xdg-bin-home/ccx`이고 `~/.local/bin/ccx`로 링크된다. 런처가 하는 일은 다음과 같다.

- `~/.local/share/dotenv/ccx.env`를 읽어 환경변수로 export한다.
- `CLAUDE_CONFIG_DIR`를 `~/.claude-ccx`로 지정한다.
- `ANTHROPIC_API_KEY`에 `OPENCODE_API_KEY`를 넣고, 모델 이름을 opencode-go 모델로 지정한다.
- `--mcp-config=~/.claude-ccx/mcp.json`을 붙여 `claude`를 실행한다.

`~/.claude-ccx/.claude.json`은 Claude Code가 계속 다시 쓰는 런타임 state(실행 횟수, feature flag 캐시, 승인한 key의 끝 20자 등)라서 dotfiles에 올리지 않는다.

## Bootstrap

새 머신에서 처음 설정하는 순서다.

1. dotfiles를 설치한다. `./install.sh`가 호스트에 맞는 프로필을 적용해 `~/.claude-ccx/`와 `~/.local/bin/ccx`를 링크한다.
2. Claude Code(native 설치)를 설치하고 `claude`가 `PATH`에 있는지 확인한다.
3. 1Password Environment `ccx`를 `~/.local/share/dotenv/ccx.env`에 마운트한다. 1Password는 이 파일을 named pipe로 만들어 읽는 순간에만 내용을 내주므로, 디렉터리는 `700`으로 만든다. 필요한 변수는 세 개다.
   - `OPENCODE_API_KEY`: opencode-go 인증
   - `EXA_API_KEY`: `mcp.json`의 Exa 헤더가 `${EXA_API_KEY}`로 참조한다.
   - `ANTHROPIC_BASE_URL`: opencode-go 엔드포인트
4. `kagi` CLI를 `PATH`에 설치한다. 현재는 bun global bin(`~/.local/share/bun/bin/kagi`)에 있다. 인증은 아래 [Kagi](#kagi)를 따른다.
5. `ccx`를 실행하고 `/mcp`로 네 서버가 `connected`인지 확인한다.

## MCP 서버

서버 정의는 `mcp.json`에 있고, 비밀은 파일에 넣지 않는다. 값이 필요하면 `${VAR}`로 참조하고 `ccx.env`에서 공급한다.

| 서버       | 종류               | 인증                       |
| ---------- | ------------------ | -------------------------- |
| `exa`      | http               | `EXA_API_KEY` 헤더 (자동)  |
| `context7` | http               | 없이도 동작, 로그인은 선택 |
| `mdn`      | http               | 없음                       |
| `kagi`     | stdio (`kagi mcp`) | `kagi auth`                |

### Kagi

`kagi`는 로컬 CLI가 MCP 서버로 실행되며, 자격 증명은 CLI의 설정 파일에서 읽는다.

1. `kagi auth set`으로 API/세션 자격 증명을 저장한다.
2. `kagi auth status`로 어떤 자격 증명이 어디서 설정됐는지 확인한다.
3. `kagi auth check`로 자격 증명이 유효한지 검증한다. 값은 출력되지 않는다.

### Kagi Assistant

`kagi assistant`는 Kagi 계정의 Assistant를 CLI에서 호출한다. 커스텀 어시스턴트 `home`은 한국어 답변, `(추론)`/`(미확인)` 표기, 출처 언어별 검색, 각주 인용을 지시해 둔 프로필이다. 모델은 DeepSeek V4.1 Flash이고 웹 접근이 켜져 있다.

1. 사용 가능한 어시스턴트를 확인한다: `kagi assistant custom list`. `home` 외에 내장 `Code`, `Study`, `News`가 나온다.
2. 이름으로 호출한다: `kagi assistant --assistant home "질문" --format markdown`.
3. 스레드를 이어가려면 `--thread-id`를 넘긴다. `kagi assistant thread list`로 ID를 찾고, `kagi assistant thread get <ID>`로 내용을 읽는다.
4. 파일을 첨부하려면 `--attach <경로>`를 반복해서 준다.

Assistant 명령은 세션 토큰(`kagi auth`)이 필요하다. MCP 서버 `kagi`는 프롬프트 전송 도구를 노출하지 않으므로 질의는 CLI로 보내고, 세션 안에서는 `thread_list`/`thread_get`으로 결과를 다시 읽는다. 호출은 AI 사용량에 반영되며 `kagi usage`로 확인한다.

### Context7 로그인

Context7은 로그인 없이도 연결되며, 로그인은 더 높은 사용량 한도를 쓰기 위한 선택 사항이다. OAuth를 지원하므로 `ccx` 세션 안에서 로그인한다.

1. `ccx`를 실행하고 `/mcp`를 입력한다.
2. `context7`을 선택하고 Authenticate를 고른다.
3. 열린 브라우저에서 Context7 계정으로 로그인하고 승인한다.
4. `/mcp`에서 `context7`이 `connected`인지 확인한다.

토큰은 `mcp.json`이 아니라 Claude Code의 credentials 저장소(`~/.claude-ccx` 아래)에 저장되므로 dotfiles에 올라가지 않는다. 머신마다 한 번씩 로그인해야 한다.

`--mcp-config`로 넘긴 서버가 `/mcp`에서 인증되는지는 검증하지 않았다. 인증되지 않으면 Context7의 API key를 `ccx.env`에 추가하고 `mcp.json`의 `context7` 항목에 `"headers": {"Context7-API-Key": "${CONTEXT7_API_KEY}"}`를 넣는다.

### 서버 추가

- OAuth가 필요한 서버는 `mcp.json`에 `type`과 `url`만 적고, 위 Context7처럼 `/mcp`에서 인증한다.
- key가 필요한 서버는 `${VAR}`로 참조하고 `ccx.env`에 변수를 추가한다.
- `claude mcp add --scope user`는 쓰지 않는다. 정의가 `.claude.json`에 들어가 dotfiles 밖에서 관리된다.

## 알아둘 점

- 런처는 `--mcp-config=<경로>`처럼 등호로 쓴다. 공백으로 구분하면 이 옵션이 뒤의 인자를 모두 흡수해 `ccx mcp list` 같은 서브커맨드가 깨진다.
- `ccx mcp list`에는 `mcp.json`의 서버가 나오지 않는다. `--mcp-config`로 넘긴 서버는 세션에만 적용되기 때문이며, 세션 안의 `/mcp`로 확인한다.
- 이 디렉터리에 파일을 추가하면 `./install.sh`를 다시 실행해야 `~/.claude-ccx/`에 링크된다.
