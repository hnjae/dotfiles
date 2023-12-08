local M = {}

M.setup = function()
  if vim.api.nvim_create_autocmd == nil then
    return
  end
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "markdown", "vimwiki", "org", "tex", "plaintex", "man", "asciidoc", "asciidoctor" },
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
          iabbr <buffer> usb USB
          iabbr <buffer> dsl DSL
          iabbr <buffer> ppp PPP
          iabbr <buffer> mac MAC
          iabbr <buffer> atm ATM
          iabbr <buffer> arp ARP
          iabbr <buffer> cslip CSLIP
          iabbr <buffer> slip SLIP
          iabbr <buffer> ip IP
          iabbr <buffer> icmp ICMP
          iabbr <buffer> igmp IGMP
          iabbr <buffer> tcp TCP
          iabbr <buffer> udp UDP
          iabbr <buffer> sctp SCTP
          iabbr <buffer> dccp DCCP
          iabbr <buffer> spx SPX
          iabbr <buffer> pptp PPTP
          iabbr <buffer> rtp RTP
          iabbr <buffer> socks SOCKS
          iabbr <buffer> spdy SPDY
          " iabbr <buffer> mime MIME
          iabbr <buffer> dns DNS
          iabbr <buffer> nntp NNTP
          iabbr <buffer> sip SIP
          iabbr <buffer> dhcp DHCP
          iabbr <buffer> ntp NTP
          iabbr <buffer> nfs NFS
          " iabbr <buffer> http HTTP
          " iabbr <buffer> https HTTPS
          " iabbr <buffer> FTP FTP
          " iabbr <buffer> FTPS FTPS
          " iabbr <buffer> SFTP SFTP
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
          " iabbr <buffer> mp4 MP4
          " iabbr <buffer> ogg Ogg
          iabbr <buffer> ldac LDAC
          iabbr <buffer> sbc SBC
          iabbr <buffer> abpx aptX
          iabbr <buffer> speex Speex
          iabbr <buffer> aac AAC
          iabbr <buffer> mp2 MP2
          " iabbr <buffer> mp3 MP3
          " iabbr <buffer> opus Opus
          iabbr <buffer> vorbis Vorbis
          " iabbr <buffer> flac FLAC
          iabbr <buffer> xvid XviD
          iabbr <buffer> divx DivX
          iabbr <buffer> h264 H.264
          iabbr <buffer> h265 H.265
          iabbr <buffer> hevc HEVC
          iabbr <buffer> av1 AV1
          iabbr <buffer> vp8 VP8
          iabbr <buffer> vp9 VP9
          iabbr <buffer> theora Theora
          " iabbr <buffer> webm WebM
          " iabbr <buffer> webp WebP
          " iabbr <buffer> png PNG
          " iabbr <buffer> gif GIF
          iabbr <buffer> jpeg JPEG

          " 기업, 단체
          iabbr <buffer> mozilla Mozilla
          iabbr <buffer> xiph Xiph
          iabbr <buffer> google Google
          iabbr <buffer> facebook Facebook
          iabbr <buffer> twitter Twitter

          " 일반명사
          iabbr <buffer> osi OSI
          iabbr <buffer> dvd DVD
          iabbr <buffer> ngo NGO
          iabbr <buffer> acl ACL

          " Unicode
          iabbr <buffer> -> →
          iabbr <buffer> <- ←
        ]])
    end,
  })
end

return M
