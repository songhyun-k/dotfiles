return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    -- Load before LazyVim (priority 10000) so `:colorscheme catppuccin`
    -- resolves to the plugin on Neovim 0.12+, not the builtin runtime copy.
    priority = 11000,
    opts = {
      flavour = "frappe",
      transparent_background = true,
      float = { transparent = true },
      custom_highlights = function(colors)
        local blend = require("catppuccin.utils.colors").blend

        return {
          Visual = { bg = blend(colors.surface1, colors.base, 0.55) },
          VisualNOS = { bg = blend(colors.surface1, colors.base, 0.55) },
          CursorLine = { bg = blend(colors.surface0, colors.base, 0.4) },
          CursorColumn = { bg = blend(colors.surface0, colors.base, 0.32) },
          NoiceCmdline = { fg = colors.text, bg = colors.none },
          NoiceCmdlinePopup = { bg = colors.none },
          NoiceCmdlinePopupBorder = { fg = colors.lavender, bg = colors.none },
          NoiceCmdlinePopupBorderSearch = { fg = colors.peach, bg = colors.none },
          NoiceCmdlinePopupTitle = { fg = colors.lavender, bg = colors.none },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
