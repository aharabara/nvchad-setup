local M = {}

local Menu = require("nui.menu");
local Input = require("nui.input");
local term = require("nvchad.term");
local commands = {};

local ask = function (prompt)
    local input = Input({
      position = "50%",
      size = {
        width = 20,
      },
      border = {
        style = "single",
        text = {
          top = "["..prompt.."]",
          top_align = "center",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
      },
    }, {
      prompt = "> ",
      default_value = "",
      on_close = function()
        print("Input Closed!")
      end,
      on_submit = function(value)
        if commands.value == true then
          term.toggle({pos="sp", id = value})

          return;
        end 
        commands[value] = true;
        term.runner {id = value, pos="sp", cmd = "pnpm sst deploy --stage"..value}
        print("Input Submitted: " .. value)
      end,
    });
    input:mount();
end;



M.show_menu = function()
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
        lines = {
            Menu.item("Deploy stack?"),
            Menu.item("Remove stack?"),
            Menu.separator("Noble-Gases", {
                char = "-",
                text_align = "right",
            }),
        },
        max_width = 20,
        keymap = {
            -- focus_next = { "j", "<Down>", "<Tab>" },
            -- focus_prev = { "k", "<Up>", "<S-Tab>" },
            -- close = { "<Esc>", "<C-c>" },
            -- submit = { "<CR>", "<Space>" },
        },
        on_close = function()
            ask("stage>")
        end,
        on_submit = function(item)
            ask("stage>")
        end,
    });
    menu:mount();
end

return M;
