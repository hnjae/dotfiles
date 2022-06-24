-- defaulit: 0
if _IS_PLUGIN('auto-pairs') then
-- if packer_plugins and packer_plugins['auto-pairs'] and packer_plugins['auto-pairs'].loaded then
    vim.g.AutoPairsFlyMode = 0
end

-- let g:AutoPairs = {
--   \ '(':')', '[':']', '{':'}',
--   \ "'":"'",'"':'"',
--   \ "`":"`", '```':'```',
--   \ '"""':'"""', "'''":"'''",
--   \ }
-- \ '<':'>'
--
--
-- 아래 항목이 들어가면 ㅎㅎㅎ 입력할때 에러 생김.
-- \ '『':' 』', '「':' 」',
-- \ '《':'》', '〈':'〉'
