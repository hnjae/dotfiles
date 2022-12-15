-- filetype
vim.cmd([[
filetype on
filetype plugin on
filetype plugin indent on
]])
-- map
--------------------------------------------------------------------------------
vim.g.mapleader = " "
-- ,: reverse t/T/f/F
vim.g.maplocalleader = ','

-- vim.api.nvim_set_keymap("n", "", "s", {})

-- vim.api.nvim_set_keymap("n", "<Leader>a", "s", {})

-------------------------------------------------------------------
-- vim.api.nvim_set_keymap("n", "<Leader>a", "za", {})
vim.api.nvim_set_keymap("n", "<Leader><Leader>", "za", {})

vim.api.nvim_set_keymap("n", "ZA", "<cmd>wa<CR>", {})

-- vim.api.nvim_set_keymap("", "gb", "<cmd>bnext<CR>", {})
-- vim.api.nvim_set_keymap("", "gB", "<cmd>bprevious<CR>", {})

-- nnoremap <space> za
-- nnoremap <F2> gt
-- nnoremap <s-F2> gT
-- nnoremap <F4> :TagbarToggle<CR>
-- imap <F7> <C-o>0
-- imap <C-a> <C-o>0
-- imap <F8> <C-o>$
-- imap <C-e> <C-o>$
-- nnoremap <F7> 0
-- nnoremap <C-a> 0
-- nnoremap <F8> $
-- nnoremap <C-e> $

-- let g:vimspector_enable_mappings='HUMAN'
-- try
--   nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
--   nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
--   nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
--   nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
-- endtry

-- VS Code Matching: https://code.visualstudio.com/shortcuts/keyboard-shortcuts-Linux.pdf
-- F1: VS Code 에서는 커맨드 검색인듯
-- F5: Start Debugging
-- General
----------------------------------------------------------
-- Basic Editing
----------------------------------------------------------
-- Rich Languages Editing
----------------------------------------------------------
-- F12: Go to Definition
-- Multi-cursor and selection
----------------------------------------------------------
-- Display
----------------------------------------------------------
-- C-B Toggle Sidebar visibility
-- F11: Toggle full screen
-- nnoremap <F3> :NERDTreeToggle<CR>

-- Search and replace
----------------------------------------------------------
-- F3 / Shift-F3: Find next/previous

-- Navigation
----------------------------------------------------------
-- Editor management
----------------------------------------------------------
-- File Management
----------------------------------------------------------
-- Debug
----------------------------------------------------------
-- F9: Toggle breakpoint
-- F5: Start / continue
-- nnoremap <F5> :QuickRun<CR>
-- nnoremap <Leader>mcc :QuickRun<CR>
-- nnoremap <Leader>mcc :AsyncRun -raw python %<CR>
-- nnoremap <Leader>rr :AsyncRun -mode=term %:p<CR>
-- nnoremap <F6> :CocCommand python.execSelectionInTerminal
-- Shift-F5 Stop
-- F11 / S-F11 Step into/out
-- F10: Step over
-- C-K C-I Show hover

-- Integrated terminal
----------------------------------------------------------
-- C-grave: Show integrated terminal
-- Create New terminal
-- C-S-Up/Down: Scroll up/down
-- imap <C-l> <Plug>(coc-snippets-expand)
--

--------------------------------------------------------------------------------
-- abbr
--------------------------------------------------------------------------------
vim.cmd([[
iabbr <expr> __time strftime("%Y-%m-%d %H:%M:%S")
iabbr <expr> __date strftime("%Y-%m-%d")
iabbr <expr> __file expand('%:p')
iabbr <expr> __name expand('%')
iabbr <expr> __pwd expand('%:p:h')
iabbr <expr> __branch system("git rev-parse --abbrev-ref HEAD")
iabbr <expr> __uuid system("uuidgen")
]])

if vim.api.nvim_create_autocmd ~= nil then
  vim.api.nvim_create_autocmd(
    {"FileType"}, {
      pattern = {"text", "markdown", "vimwiki", "org", "tex", "plaintex", "man"},
      callback  = function ()
        vim.cmd([[
          " OS
          iabbr <buffer> linux Linux
          iabbr <buffer> macos macOS
          iabbr <buffer> ubuntu Ubuntu
          iabbr <buffer> debian Debian
          iabbr <buffer> fedora Fedora
          iabbr <buffer> centos CentOS
          iabbr <buffer> redhat Red Hat
          iabbr <buffer> opensuse openSUSE
          iabbr <buffer> ios iOS
          iabbr <buffer> posix POSIX
          iabbr <buffer> bsd BSD
          iabbr <buffer> freebsd FreeBSD
          iabbr <buffer> openbsd OpenBSD
          iabbr <buffer> netbsd NetBSD
          iabbr <buffer> trueos TrueOS

          " Programs
          iabbr <buffer> kde KDE
          iabbr <buffer> gnome GNOME
          iabbr <buffer> gimp GIMP
          iabbr <buffer> firefox Firefox
          iabbr <buffer> mergerfs MergerFS
          iabbr <buffer> snapraid SnapRAID

          " Computer
          iabbr <buffer> hdd HDD
          iabbr <buffer> sdd SDD
          iabbr <buffer> cpu CPU

          " Filesystem
          iabbr <buffer> raid  RAID
          iabbr <buffer> lvm   LVM
          iabbr <buffer> luks  LUKS
          iabbr <buffer> udf   UDF
          iabbr <buffer> jfs   JFS
          iabbr <buffer> zfs   ZFS
          iabbr <buffer> btrfs Btrfs
          iabbr <buffer> xfs   XFS
          iabbr <buffer> f2fs  F2FS
          iabbr <buffer> hfs   HFS
          iabbr <buffer> apfs  APFS
          iabbr <buffer> ntfs  NTFS
          iabbr <buffer> refs  ReFS
          iabbr <buffer> fat16 FAT16
          iabbr <buffer> fat32 FAT32


          " License
          iabbr <buffer> gnu GNU
          iabbr <buffer> gpl GPL
          iabbr <buffer> mit MIT
          iabbr <buffer> apache Apache

          " Association
          iabbr <buffer> mpeg MPEG
          iabbr <buffer> iso ISO
          iabbr <buffer> itu ITU
          iabbr <buffer> vceg VCEG
          iabbr <buffer> eia EIA
          iabbr <buffer> ieee IEEE
          iabbr <buffer> riff RIFF
          iabbr <buffer> ietf IETF
          iabbr <buffer> ccitt CCITT
          iabbr <buffer> iab IAB

          " Protocol
          " OSI 1
          iabbr <buffer> usb USB
          iabbr <buffer> dsl DSL
          " OSI 2
          iabbr <buffer> ppp PPP
          iabbr <buffer> mac MAC
          iabbr <buffer> atm ATM
          iabbr <buffer> arp ARP
          iabbr <buffer> cslip CSLIP
          iabbr <buffer> slip SLIP
          " OSI 3
          iabbr <buffer> ip IP
          iabbr <buffer> icmp ICMP
          iabbr <buffer> igmp IGMP
          " OSI 4
          iabbr <buffer> tcp TCP
          iabbr <buffer> udp UDP
          iabbr <buffer> sctp SCTP
          iabbr <buffer> dccp DCCP
          iabbr <buffer> spx SPX
          " OSI 5
          iabbr <buffer> pptp PPTP
          iabbr <buffer> rtp RTP
          iabbr <buffer> socks SOCKS
          iabbr <buffer> spdy SPDY
          " OSI 6
          iabbr <buffer> mime MIME
          " OSI 7
          iabbr <buffer> dns DNS
          iabbr <buffer> nntp NNTP
          iabbr <buffer> sip SIP
          iabbr <buffer> dhcp DHCP
          iabbr <buffer> ntp NTP
          iabbr <buffer> nfs NFS
          iabbr <buffer> http HTTP
          iabbr <buffer> https HTTPS
          iabbr <buffer> FTP FTP
          iabbr <buffer> FTPS FTPS
          iabbr <buffer> SFTP SFTP
          iabbr <buffer> pop3 POP3
          iabbr <buffer> imap IMAP
          iabbr <buffer> smtp SMTP
          "
          iabbr <buffer> wol WoL
          iabbr <buffer> ddns DDNS
          iabbr <buffer> ssh SSH
          iabbr <buffer> ssl SSL
          iabbr <buffer> ldap LDAP

          " Codec
          iabbr <buffer> mp4 MP4
          iabbr <buffer> ogg Ogg
          iabbr <buffer> ldac LDAC
          iabbr <buffer> sbc SBC
          iabbr <buffer> abpx aptX
          iabbr <buffer> speex Speex
          iabbr <buffer> aac AAC
          iabbr <buffer> mp2 MP2
          iabbr <buffer> mp3 MP3
          iabbr <buffer> opus Opus
          iabbr <buffer> vorbis Vorbis
          iabbr <buffer> flac FLAC
          iabbr <buffer> xvid XviD
          iabbr <buffer> divx DivX
          iabbr <buffer> h264 H.264
          iabbr <buffer> h265 H.265
          iabbr <buffer> hevc HEVC
          iabbr <buffer> av1 AV1
          iabbr <buffer> vp8 VP8
          iabbr <buffer> vp9 VP9
          iabbr <buffer> theora Theora
          iabbr <buffer> webm WebM
          iabbr <buffer> webp WebP
          iabbr <buffer> png PNG
          iabbr <buffer> gif GIF
          iabbr <buffer> jpeg JPEG

          " 기업, 단체
          iabbr <buffer> mozilla Mozilla
          iabbr <buffer> xiph Xiph
          iabbr <buffer> google Google
          iabbr <buffer> facebook Facebook

          " 일반명사
          iabbr <buffer> osi OSI
          iabbr <buffer> dvd DVD
          iabbr <buffer> ngo NGO
          iabbr <buffer> acl ACL
          iabbr <buffer> twitter Twitter

          " language
          iabbr <buffer> kotlin Kotlin
          iabbr <buffer> perl Perl
          iabbr <buffer> lisp Lisp
          iabbr <buffer> luajit LuaJIT
          iabbr <buffer> luavela LuaVela
          iabbr <buffer> cobol COBOL
          iabbr <buffer> swift Swift
          iabbr <buffer> fortran Fortran
          iabbr <buffer> pascal Pascal
          iabbr <buffer> javascript JavaScript
          iabbr <buffer> typescript TypeScript
          iabbr <buffer> livescript LiveScript
          iabbr <buffer> purescript PureScript
          iabbr <buffer> haskell Haskell
          iabbr <buffer> c# C#
          iabbr <buffer> c# C#
          iabbr <buffer> c++ C++
          iabbr <buffer> cpp C++
          iabbr <buffer> perl Perl
          iabbr <buffer> php PHP
          iabbr <buffer> css CSS
          iabbr <buffer> html HTML
          iabbr <buffer> xml XML
          iabbr <buffer> yaml YAML
          iabbr <buffer> sgml SGML
          iabbr <buffer> viml VimL
          iabbr <buffer> vala Vala
          iabbr <buffer> verilog Verilog
          iabbr <buffer> clojure Clojure
          iabbr <buffer> julia Julia
          iabbr <buffer> r R

          " Unicode
          iabbr <buffer> -> →
          iabbr <buffer> <- ←
        ]])
      end
    }
  )
end
-- options-appearance

-- VIM Mode 에 따라 커서 Shape 바뀌는 옵션 해제
vim.opt.guicursor=""

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
-- options-encoding
vim.opt.fileencodings = "utf-8,cp949,iso-2022-jp,euc-jp,shift-jis,cp949,latin1"
vim.opt.fileformats = "unix,dos,mac"
vim.opt.encoding = "utf-8"
-- options-indent
--------------------------------------------------------------------------------
-- List of Tab Options
-- set tabstop=4	 -- width of tabs
-- 	tabstop 이랑 shiftwidth 이랑 다르면 tab 한번에 두개의 /t 이 들아가는
-- 	일도 생김
-- softtabstop=int :
-- 	default value for tabstop | or set same value as shiftwidth
-- expandtab :
-- 	탭을 누르면 softtabstop 만큼의 스페이스로 입력한다.
-- set shiftwidth=8
--	int / affects what happens when you press >> << ==
vim.opt.smarttab = true

-- List of Indent Options
vim.opt.smartindent = true
    -- automatically inserts one extra level of indentation in some case.

-- set cindent		-- is more customizable, but also more strict when it comes to syntax.
-- set autoindent -- does nothing more than copy the indentation from the previous line
-- options
-- VIM UI
--------------------------------------------------------------------------------
-- set laststatus=2 -- 상태라인
                    -- vim-airline 에서 대신함.
vim.opt.showmode = false  -- no showmode under status line. e.g.) INSERT, REPLACE
                          -- vim-airline 에서 대신함.
vim.opt.cursorline = true -- cursorline = color cursorline
vim.opt.showcmd    = true -- showcmd under status line. e.g.) 32j
vim.opt.cmdheight  = 2

vim.opt.ruler = true          -- display ruler on the right side of the *status line*
vim.opt.number = true         -- display number of lines left
                              -- relativenumber랑 사용하면 현재 줄 만 표기됨
vim.opt.relativenumber = true --  display number of lines w/ relativenumber
vim.opt.hlsearch = true       --  highlight all search matches
vim.opt.ignorecase = true     -- Search Option: ignore case
vim.opt.smartcase  = true     -- 대문자가 검색어 문자열에 포함될 때에는 noignorecase

-- vim.opt.incsearch  = true     -- 검색 키워드 입력시 한 글자 입력할 때마다 점진 검색
vim.opt.showmatch = true      --  show parenthesis that match

--  VIM Options : Basic Options
--------------------------------------------------------------------------------
-- set autowrite
-- set autoread

vim.opt.errorbells = false
vim.opt.visualbell = true -- use visual bell

vim.opt.history = 1000

vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 6

-- vim.opt.shell = "zsh"

--  VIM Options : Files
--------------------------------------------------------------------------------
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false

--------------------------------------------------------------------------------
--[[
 DISABLE Comment When insert new line (:help fo-table)
 set formatoptions-=r   " Enter
 set formatoptions-=o   " New line created by O
 set formatoptions-=c   " wrap comment using textwidth
-- autocmd FileType * setlocal formatoptions-=r formatoptions-=o
 그냥 set 으로 설정하면 안먹힘. (2022-04-14)
    - 아마도 override 하는 플러그인이 있을터
--]]

vim.api.nvim_create_autocmd(
  {"BufRead", "BufNewFile", "BufNew"}, {
    pattern = {"*"},
    callback = function()
      vim.opt_local.formatoptions:remove("r")
      vim.opt_local.formatoptions:remove("o")
    end
  }
)
-- formatoptions 는 쉽게 override 된다.
-- vim.opt.formatoptions:remove("r")
-- vim.opt.formatoptions:remove("o")
-- defaults: tcqj (2022-05-15)
-- jcroql -- override by something?
-- vim.opt.formatoptions = "tcqjpn"
-- t: auto-wrap text using textwidth
-- c: auto-wrap comments using textwidth, inserting the current comment leader automatically
-- q: allow formatting of comments with gq
-- j: remove a comment leader when joining lines.
--
-- p: Don't break lines at single spaces that follow periods.
-- r: auto-insert the current comment leader after hitting <Enter>
-- n: when formatting text, recognize numbered lists. it wraps after "1."
--
-- o: automatically insert the current comment leader after hitting 'o'


-------------------------------------------------------------------------------
-- DISABLE AUTO Word Break
-------------------------------------------------------------------------------
-- https://vim.fandom.com/wiki/Word_wrap_without_line_breaks
vim.opt.wrap = true
vim.opt.textwidth=0

-------------------------------------------------------------------------------
-- complete: set the matches for insert mode completion
-- default: .wbut ?
vim.opt.complete = ".,w,b,u,t,i"

----------
vim.opt.title = true
-- options-matchpairs
-- full width char mapping
vim.opt.matchpairs:append "（:）"
vim.opt.matchpairs:append "「:」"
vim.opt.matchpairs:append "｛:｝"
vim.opt.matchpairs:append "＜:＞"
vim.opt.matchpairs:append "【:】"
vim.opt.matchpairs:append "『:』"
vim.opt.matchpairs:append "［:］"
vim.opt.matchpairs:append "《:》"
vim.opt.matchpairs:append "〔:〕"

-- half width char mapping
vim.opt.matchpairs:append "‘:’"
vim.opt.matchpairs:append "“:”"
vim.opt.matchpairs:append "«:»"
vim.opt.matchpairs:append "‹:›"
vim.opt.matchpairs:append "｢:｣"
vim.opt.matchpairs:append "[:]"
vim.opt.matchpairs:append "<:>"
vim.opt.matchpairs:append "`:`"
-- options-spell
-- help: https://soooprmx.com/vim의-autocmd-이벤트들/
vim.opt.spell = false
vim.opt.spelllang = "en,en_us,cjk"
vim.opt.spellcapcheck = ""
-- pi_netrw
-- NETRW settings
--------------------------------------------------------------------------------
vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nornu number relativenumber'
-- disable all provider
vim.g.loaded_python3_provider = 0 -- disable python3
vim.g.loaded_ruby_provider = 0 -- disable ruby
vim.g.loaded_python_provider = 0 -- disable python2
vim.g.loaded_perl_provider = 0 -- disable perl
vim.g.loaded_node_provider = 0
-- signs
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
  { name = "DiagnosticSignHint", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(
    sign.name, { texthl = sign.name, text = sign.text, numhl = "" }
  )
end
-- syntax
vim.cmd('syntax enable')
vim.opt.guifont = { "MesloLGS NF", "h14" }
-- if vim.fn.exists("g:neovide")
-- if false and vim.fn.has('nvim-0.7') == 1 then
-- vim.opt.neovide_refresh_rate= 30
-- end
