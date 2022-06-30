local gen_custom_opts = function(path)
  -- default: 2022-06-30
  return {
    -- ansible = {
    --   ansible = {
    --     path = "ansible"
    --   },
    --   ansibleLint = {
    --     enabled = true,
    --     path = "ansible-lint"
    --   },
    --   executionEnvironment = {
    --     enabled = false
    --   },
    --   python = {
    --     interpreterPath = "python"
    --   }
    -- }
  }
end

return gen_custom_opts
