local pairs_ = {
  -- full width char mapping
  "（:）",
  "「:」",
  "｛:｝",
  "＜:＞",
  "【:】",
  "『:』",
  "［:］",
  "《:》",
  "〔:〕",
  -- half width char mapping
  "‘:’",
  "“:”",
  "«:»",
  "‹:›",
  "｢:｣",
  "[:]",
  "<:>",
  "`:`",
}

for _, val in ipairs(pairs_) do
  vim.opt.matchpairs:append(val)
end
