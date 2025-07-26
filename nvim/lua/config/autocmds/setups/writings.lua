local M = {}

M.setup = function()
  if vim.api.nvim_create_autocmd == nil then
    return
  end
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
      "markdown",
      "vimwiki",
      "org",
      "tex",
      "typst",
      "plaintex",
      "man",
      "asciidoc",
      "asciidoctor",
      "rst",
    },
    callback = function()
      local mapping = {
        -- OS
        bsd = "BSD",
        centos = "CentOS",
        debian = "Debian",
        fedora = "Fedora",
        freebsd = "FreeBSD",
        ios = "iOS",
        linux = "Linux",
        macos = "macOS",
        netbsd = "NetBSD",
        nixos = "NixOS",
        openbsd = "OpenBSD",
        opensuse = "openSUSE",
        posix = "POSIX",
        redhat = "Red Hat",
        trueos = "TrueOS",
        ubuntu = "Ubuntu",

        -- Acronym
        acl = "ACL",
        cpu = "CPU",
        dvd = "DVD",
        hdd = "HDD",
        ngo = "NGO",
        osi = "OSI",
        sdd = "SDD",

        -- Filesystem
        apfs = "APFS",
        btrfs = "Btrfs",
        f2fs = "F2FS",
        fat16 = "FAT16",
        fat32 = "FAT32",
        hfs = "HFS",
        jfs = "JFS",
        luks = "LUKS",
        lvm = "LVM",
        ntfs = "NTFS",
        raid = "RAID",
        refs = "ReFS",
        udf = "UDF",
        xfs = "XFS",
        zfs = "ZFS",

        -- License
        apache = "Apache",
        gnu = "GNU",
        gpl = "GPL",
        mit = "MIT",

        -- Protocol
        arp = "ARP",
        atm = "ATM",
        cslip = "CSLIP",
        dccp = "DCCP",
        ddns = "DDNS",
        dhcp = "DHCP",
        dns = "DNS",
        dsl = "DSL",
        icmp = "ICMP",
        igmp = "IGMP",
        imap = "IMAP",
        ip = "IP",
        ldap = "LDAP",
        mac = "MAC",
        nfs = "NFS",
        nntp = "NNTP",
        ntp = "NTP",
        pop3 = "POP3",
        ppp = "PPP",
        pptp = "PPTP",
        rtp = "RTP",
        sctp = "SCTP",
        sip = "SIP",
        slip = "SLIP",
        smtp = "SMTP",
        socks = "SOCKS",
        spdy = "SPDY",
        spx = "SPX",
        ssh = "SSH",
        ssl = "SSL",
        tcp = "TCP",
        udp = "UDP",
        usb = "USB",
        wifi = "Wi-Fi",
        wol = "WoL",

        -- Codec
        aac = "AAC",
        abpx = "aptX",
        av1 = "AV1",
        divx = "DivX",
        h264 = "H.264",
        h265 = "H.265",
        hevc = "HEVC",
        jpeg = "JPEG",
        ldac = "LDAC",
        mp2 = "MP2",
        sbc = "SBC",
        speex = "Speex",
        theora = "Theora",
        vorbis = "Vorbis",
        vp8 = "VP8",
        vp9 = "VP9",
        xvid = "XviD",

        -- Association
        ccitt = "CCITT",
        eia = "EIA,",
        iab = "IAB",
        ieee = "IEEE",
        ietf = "IETF",
        iso = "ISO",
        itu = "ITU",
        mpeg = "MPEG",
        riff = "RIFF",
        vceg = "VCEG",

        -- Products
        firefox = "Firefox",
        gimp = "GIMP",
        gnome = "GNOME",
        kde = "KDE",
        librechat = "LibreChat",
        mergerfs = "MergerFS",
        snapraid = "SnapRAID",
        strongswan = "strongSwan",

        -- 기업, 단체
        facebook = "Facebook",
        github = "GitHub",
        gitlab = "GitLab",
        google = "Google",
        mozilla = "Mozilla",
        openai = "OpenAI",
        openrouter = "OpenRouter",
        twitter = "Twitter",
        xiph = "Xiph",

        -- Unicode
        ["->"] = "→",
        ["<-"] = "←",
        ["<->"] = "↔",
        ["<="] = "⇐",
        ["=>"] = "⇒",
        ["<==>"] = "⟺",
        ["<=="] = "⟸",
        ["==>"] = "⟹",
      }
      for lhs, rhs in pairs(mapping) do
        vim.keymap.set("ia", lhs, rhs, { buffer = true })
      end
    end,
  })
end

return M
