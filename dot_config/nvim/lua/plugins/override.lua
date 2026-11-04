return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "H", false }, -- Disables LazyVim's default buffer-left binding
      { "L", false }, -- Disables LazyVim's default buffer-right binding
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter", -- Keeps enter for commands, but overrides completion below
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<CR>"] = {}, -- Explicitly unbinds Enter from completion entirely
      },
    },
  },
}
