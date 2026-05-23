vim.filetype.add({
  extension = {
    -- add quadlet files. <not supported in nvim 0.12.2; 2026-05-23>
    container = "systemd",
    network = "systemd.network",
    volume = "systemd",
  },
})
