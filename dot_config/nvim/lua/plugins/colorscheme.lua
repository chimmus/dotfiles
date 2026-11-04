return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      stlyes = {
        sidebars = "transparent",
        floats = "transparent",
      },
      style = "moon", -- Choose your base style variant
      on_colors = function(colors)
        -- Hardcode your exact terminal hex code directly into the style configuration
        -- colors.bg = "#222733"
        -- colors.bg_dark = "#222733"
        -- colors.bg_float = "#222733"
        -- colors.bg_sidebar = "#222733"
        -- colors.bg_statusline = "#222733"
        colors.bg = "#1A1B25"
        colors.bg_dark = "#1A1B25"
        colors.bg_float = "#1A1B25"
        colors.bg_sidebar = "#1A1B25"
        colors.bg_statusline = "#1A1B25"
      end,
    },
  },
}
