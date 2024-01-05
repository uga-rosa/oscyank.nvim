local config = require("oscyank").get
local b64 = require("oscyank.base64")

local M = {}

local commands = {
  operator = {
    block = vim.keycode("`[<C-v>`]y"),
    char = "`[v`]y",
    line = "`[V`]y",
  },
  visual = {
    [""] = "gvy",
    V = "gvy",
    v = "gvy",
    [""] = "gvy",
  },
}

---@param mode "operator"|"visual"
---@param type "block"|"char"|"line"|""|"V"|"v"|""
---@return string
local function get_text(mode, type)
  local clipboard = vim.api.nvim_get_option_value("clipboard", {})
  local selection = vim.api.nvim_get_option_value("selection", {})
  local register = vim.fn.getreg('"')
  local visual_marks = { vim.fn.getpos("'<"), vim.fn.getpos("'>") }

  -- Retrieve text
  vim.api.nvim_set_option_value("clipboard", "", {})
  vim.api.nvim_set_option_value("selection", "inclusive", {})
  vim.cmd.normal({ args = { commands[mode][type] }, bang = true, mods = { keepjumps = true } })
  local text = vim.fn.getreg('"') --[[@as string]]

  -- Restore user settings
  vim.api.nvim_set_option_value("clipboard", clipboard, {})
  vim.api.nvim_set_option_value("selection", selection, {})
  vim.fn.setreg('"', register)
  vim.fn.setpos("'<", visual_marks[1])
  vim.fn.setpos("'>", visual_marks[2])

  return text
end

---@param text string
---@return string
local function trim_indent(text)
  local indent = text:match("^%s+")
  if indent then
    local pattern = "\n" .. ("%s"):rep(#indent)
    text = text:gsub(pattern, "\n")
  end
  return vim.trim(text)
end

---@param osc52 string
---@return boolean success
local function write(osc52)
  return vim.fn.chansend(vim.v.stderr, osc52) > 0
end

---@param text string
function M.yank(text)
  if config("trim") then
    text = trim_indent(text)
  end
  local max_length = config("max_length") --[[@as number]]
  if max_length > 0 and #text > max_length then
    vim.notify(
      ("Selection is too big: length is %d, limit is %d"):format(#text, max_length),
      vim.log.levels.WARN
    )
    return
  end
  local osc52 = config("osc52") --[[@as string]]
  osc52 = osc52:format(b64.encode(text))
  local success = write(osc52)
  if not success then
    vim.notify("Failed to copy selection", vim.log.levels.ERROR)
  end
end

---@param mode "operator"|"visual"
---@param type "block"|"char"|"line"|""|"V"|"v"|""
function M.yank_by(mode, type)
  local text = get_text(mode, type)
  M.yank(text)
end

return M
