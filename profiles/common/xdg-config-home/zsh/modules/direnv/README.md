<!--
SPDX-License-Identifier: AGPL-3.0-or-later
SPDX-FileCopyrightText: 2024 Eric Nielsen and contributors
-->

direnv
======

Sets up the Zsh shell integration for [direnv].

The following should be removed from your `~/.zshrc`, since this module will
already take care of it:

```zsh
eval "$(direnv hook zsh)"
```

[direnv]: https://direnv.net/
