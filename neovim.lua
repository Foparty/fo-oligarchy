return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg = "#1b1a18",
        dark_bg = "#131211",
        darker_bg = "#0c0b0a",
        lighter_bg = "#2c2a26",

        fg = "#e6e2d8",
        dark_fg = "#6e6b63",
        light_fg = "#c4bfb3",
        bright_fg = "#f0ebe3",
        muted = "#5a564e",

        red = "#b8928e",
        yellow = "#c4a574",
        orange = "#b89970",
        green = "#8f9a8c",
        cyan = "#a8b5ba",
        blue = "#9aa3ad",
        magenta = "#b0a4a8",
        brown = "#7a6b55",

        bright_red = "#c9a5a1",
        bright_yellow = "#d4b888",
        bright_green = "#a3aea0",
        bright_cyan = "#b8c5ca",
        bright_blue = "#adb6c0",
        bright_magenta = "#c0b4b8",

        accent = "#c4a574",
        cursor = "#f0ebe3",
        foreground = "#e6e2d8",
        background = "#1b1a18",
        selection = "#322f2a",
        selection_foreground = "#f0ebe3",
        selection_background = "#322f2a",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
