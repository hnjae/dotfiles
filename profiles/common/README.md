---
date: 2026-05-09T16:32:57+0900
lastmod: 2026-05-09T16:32:57+0900
---

## NOTE

### bash 가 읽는 파일 기준

| 조합                      | 읽는 파일                                                                   |
| ------------------------- | --------------------------------------------------------------------------- |
| interactive login         | /etc/profile → `~/.bash_profile` or `~/.bash_login` or `~/.profile`         |
| non-interactive login     | /etc/profile → `~/.bash_profile` or `~/.bash_login` or `~/.profile`         |
| interactive non-login     | `~/.bashrc`                                                                 |
| non-interactive non-login | 기본적으로 아무 profile/rc도 안 읽음. 단, $BASH_ENV가 있으면 그 파일을 읽음 |
