return {
  [1] = "CRAG666/code_runner.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    -- kotlin = "cd $dir && kotlinc-native $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt.kexe"
    kotlin =
    "cd $dir && kotlinc $fileName --include-runtime -d $fileNameWithoutExt.jar && java -jar ./$fileNameWithoutExt.jar",
  },
}
