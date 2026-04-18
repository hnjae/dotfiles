_: {
  git-hooks.hooks = {
    rumdl.enable = true;
    yamlfmt.enable = true;
    biome = {
      enable = true;
      excludes = [ "lazy-lock\\.json" ];
    };
  };
}
