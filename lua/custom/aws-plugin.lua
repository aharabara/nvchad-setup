local M = {}

local Menu = require "nui.menu"
local Input = require "nui.input"
local Popup = require "nui.popup"
local term = require "nvchad.term"
local commands = {}
local event = require("nui.utils.autocmd").event

local ask = function(prompt, callback)
  local input = Input({
    position = "50%",
    size = {
      width = 20,
    },
    border = {
      style = "single",
      text = {
        top = "[" .. prompt .. "]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    prompt = "~> ",
    default_value = "",
    on_close = function()
      print "Input Closed!"
    end,
    on_submit = callback,
  })
  input:mount()
end

M.show_popup = function(text)
  local popup = Popup {
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "60%",
    },
    keymap = {
      -- focus_next = { "j", "<Down>", "<Tab>" },
      -- focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      -- submit = { "<CR>", "<Space>" },
    },
 
  }

  -- mount/open the component
  popup:mount()

  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  lines = {}
  for s in text:gmatch "[^\r\n]+" do
    table.insert(lines, s)
  end

  -- set content
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
end

M.execute_task = function()
  ask("Execute task", function(value)
    vim.cmd('!zsh -c "pueue add -p ' .. value .. '"')
    M.show_tasks()
  end)
end

M.show_tasks = function()
  local handle = io.popen "pueue status --json"
  local result = handle:read "*a"
  handle:close()
  local items = {}
  for i, task in pairs(vim.json.decode(result).tasks) do
    table.insert(items, Menu.item(task.original_command, { id = task.id }))
  end
  M.show_menu(items, function(item)
    local handle = io.popen("pueue log " .. item.id)
    local result = handle:read "*a"
    handle:close()

    M.show_popup(result)
  end)
end

M.show_menu = function(items, callback)
  local menu = Menu({
    position = "50%",
    size = {
      width = 25,
      height = 5,
    },
    border = {
      style = "single",
      text = {
        top = "[Choose-an-Element]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = items,
    max_width = 20,
    keymap = {
      -- focus_next = { "j", "<Down>", "<Tab>" },
      -- focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      -- submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      -- ask("stage>")
    end,
    on_submit = callback,
  })
  menu:mount()
end

return M
