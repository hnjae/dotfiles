---
date: 2026-04-13T17:42:17+0900
lastmod: 2026-04-13T17:42:17+0900
---

<https://artificialanalysis.ai/leaderboards/models>

2026-04-13 Update

| Model (All Reasoning)                 | Context | Intelligence | Price (Blenced) | Speed (Token/s) |
| ------------------------------------- | ------- | ------------ | --------- | ---- |
| `google/gemini-3.1-pro-preview`       |  1000 K |           57 | USD  4.50 |  127 |
| `openai/gpt-5.4` (`xhigh`)            |  1005 K |           57 | USD  5.63 |   80 |
| `anthropic/claude-opus-4.6` (`max`)   |  1000 K |           53 | USD 10.00 |   41 |
| `anthropic/claude-sonnet-4.6` (`max`) |  1000 K |           52 | USD  6.00 |   59 |
| `z-ai/glm-5.1`                        |   200 K |           51 | USD  2.15 |   53 |
| `qwen/qwen3.6-plus`                   |  1000 K |           50 | USD  1.13 |   44 |
| `openai/gpt-5.4-mini` (`xhigh`)       |   400 K |           49 | USD  1.69 |  173 |
| `moonshotai/kimi-k2.5`                |   256 K |           47 | USD  1.20 |   40 |
| `google/gemini-3-flash-preview`       |  1000 K |           46 | USD  1.33 |  150 |
| `openai/gpt-5.4-nano` (`xhigh`)       |   400 K |           44 | USD  0.46 |  182 |
| `deepseek/deepseek-v3.2`              |   128 K |           42 | USD  0.32 |   41 |
| `openai/gpt-5.4-nano`                 |   400 K |           38 | USD  0.46 |  185 |
| `openai/gpt-5.4-mini` (`medium`)      |   400 K |           38 | USD  1.69 |  169 |
| `x-ai/grok-code-fast-1`               |   256 K |           29 | USD  0.53 |  160 |

> - What: atlas를 gpt-5.4-mini → gpt-5.4로 올렸고, explore/quick/writing은 *-mini-fast 대신 공식 openai/gpt-5.4-mini로 정리했습니다.
> - Where: explore와 quick은 variant: "minimal", unspecified-low와 writing은 variant: "low"로 내려서 속도·토큰 사용을 줄였습니다.
> - Where: visual-engineering, unspecified-high, artistry는 xhigh → high로 낮췄습니다.
> - Verify: 파일 내용을 재읽어서 변경값을 확인했고, Node로 JSONC를 파싱해 jsonc-parse-ok까지 확인했습니다.
> - Open: opencode-vanilla.jsonc는 현재 활성 파일은 아니지만 여전히 예전 값이라, 원하시면 그 파일도 같은 방향으로 맞춰드릴 수 있습니다.
