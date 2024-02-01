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
    selected_interpreters = {},
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
