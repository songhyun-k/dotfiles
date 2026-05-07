return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {},
    },
    init = function()
      -- Workaround: snacks.nvim doesn't reset hidden flag on buffer re-enter
      -- https://github.com/folke/snacks.nvim/issues/2634
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local ok, placement = pcall(require, "snacks.image.placement")
          if not ok then return end
          if type(placement.update) ~= "function" then return end

          local orig_update = placement.update
          placement.update = function(self, ...)
            local state = rawget(self, "_state")
            if self.hidden and state and #(state.wins or {}) == 0 and #self:wins() > 0 then
              self.hidden = false
            end
            return orig_update(self, ...)
          end
        end,
      })
    end,
  },
}
