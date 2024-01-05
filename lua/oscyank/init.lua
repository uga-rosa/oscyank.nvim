local M = {}

M.config = {
  max_length = 0,
  trim = false,
  osc52 = "\x1b]52;c;%s\x07",
}

function M.setup(opt)
  M.config = vim.tbl_extend("force", M.config, opt)
end

function M.get(name)
  return M.config[name]
end

return M
