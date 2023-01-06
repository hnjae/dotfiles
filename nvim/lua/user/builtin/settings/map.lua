--------------------------------------------------------------------------------
vim.g.mapleader = " "
-- NOTE: , : repeat t/T/f/F backwards
vim.g.maplocalleader = ','

-- vim.api.nvim_set_keymap("n", "", "s", {})
-- vim.api.nvim_set_keymap("n", "<Leader>a", "s", {})

-------------------------------------------------------------------
-- vim.api.nvim_set_keymap("n", "<Leader>a", "za", {})
vim.keymap.set("n", "<Leader><Leader>", "za", { desc = "toggle-fold" })
vim.keymap.set("n", "ZA", "<cmd>wa<CR>", { desc = "save" })
vim.keymap.set(
  "n",
  "Zl",
  function()
    for _, buf_client in pairs(vim.lsp.get_active_clients({bufnr = 0})) do
      buf_client.stop()
    end
  end,
  { desc='stop-lsp' }
)

vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")
vim.keymap.set("n", "<S-left>", "<C-w>H")
vim.keymap.set("n", "<S-down>", "<C-w>J")
vim.keymap.set("n", "<S-up>", "<C-w>K")
vim.keymap.set("n", "<S-right>", "<C-w>L")

vim.keymap.set({ "n", "v" }, "<F12>", '"+y', { desc = "copy-to-clipboard" })
vim.keymap.set({ "n", "v" }, "<S-F12>", '"+p', { desc = "paste-from-clipboard" })
vim.keymap.set({ "n", "v" }, "<F24>", '"+p', { desc = "paste-from-clipboard" })


vim.keymap.set("n", "[w", vim.diagnostic.goto_prev, { desc = "warning" })
vim.keymap.set("n", "]w", vim.diagnostic.goto_next, { desc = "warning" })
vim.keymap.set(
  "n",
  "[g",
  function()
    vim.diagnostic.goto_prev({
      severity = { min = vim.diagnostic.severity.ERROR }
    })
  end,
  { desc = "error" }
)
vim.keymap.set(
  "n",
  "]g",
  function()
    vim.diagnostic.goto_next({
      severity = { min = vim.diagnostic.severity.ERROR }
    })
  end,
  { desc = "error" }
)

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "lsp-declaration" })
vim.keymap.set("n", "==", vim.lsp.buf.formatting, { desc = "lsp-formatting" })
vim.keymap.set(
  "v", "==", vim.lsp.buf.range_formatting, { desc = "lsp-formatting" }
)

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc='lsp-definition' })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc='lsp-declaration' })
vim.keymap.set("n", "gli", vim.lsp.buf.implementation, { desc='lsp-implementation' })
vim.keymap.set("n", "glr", vim.lsp.buf.references, { desc='lsp-references' })
vim.keymap.set("n", "gly", vim.lsp.buf.type_definition, { desc='lsp-type-definition' })
vim.keymap.set("n", "glr", vim.lsp.buf.signature_help, { desc='lsp-signature-help' })


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

-- VS Code Mapping:
-- https://code.visualstudio.com/shortcuts/keyboard-shortcuts-Linux.pdf
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
    { "FileType" }, {
    pattern  = { "text", "markdown", "vimwiki", "org", "tex", "plaintex", "man" },
    callback = function()
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
