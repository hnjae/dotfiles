---@type LazySpec[]
return {
  {
    [1] = "michaelb/sniprun",
    enabled = true,
    lazy = false,
    cond = vim.fn.executable("cargo") == 1,
    build = "sh ./install.sh 1",
    dependencies = {
      "rcarriga/nvim-notify",
    },
    opts = {
      -- selected_interpreters = { "Python3_fifo" },
      -- repl_enable = { "Python3_fifo" },
    },
  },
  {
    [1] = "CRAG666/code_runner.nvim",
    enabled = false,
    lazy = true,
    cmd = {
      "RunCode",
      "RunFile",
      "RunProject",
      "RunClose",
      "CRFiletype",
      "CRProjects",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      filetype = {
        kotlin = "cd $dir && kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar && java -jar ./$fileNameWithoutExt.jar",
      },
    },
  },
}
