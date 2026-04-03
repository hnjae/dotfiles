--[[

NOTE:

- 2026-01-21, NixOS 25.11, 6.18, AMD 5600X (ZEN3 6C12T) 에서 32000 줄의 yaml 를 format 하는데

```
% hyperfine --shell=none 'yamlfix artists.yaml' 'yamlfmt artist.yaml'
Benchmark 1: yamlfix artists.yaml
  Time (mean ± σ):      5.571 s ±  0.092 s    [User: 5.384 s, System: 0.078 s]
  Range (min … max):    5.468 s …  5.751 s    10 runs

Benchmark 2: yamlfmt artist.yaml
  Time (mean ± σ):       2.3 ms ±   0.2 ms    [User: 0.8 ms, System: 1.6 ms]
  Range (min … max):     2.0 ms …   3.8 ms    880 runs

  Warning: Statistical outliers were detected. Consider re-running this benchmark on a quiet system without any interferences from other programs. It might help to use the '--warmup' or '--prepare' options.

Summary
  yamlfmt artist.yaml ran
 2452.29 ± 191.17 times faster than yamlfix artists.yaml
```

]]
---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      yaml = { "yamlfmt" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "yamlfmt" } },
    },
  },
}
