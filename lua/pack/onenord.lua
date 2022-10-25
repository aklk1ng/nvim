local colors = require("onenord.colors").load()
require('onenord').setup({
  borders = true, -- Split window borders
  fade_nc = false, -- Fade non-current windows, making them more distinguishable
  styles = {
    comments = "italic",
    strings = "NONE",
    keywords = "NONE",
    functions = "NONE",
    variables = "NONE",
    diagnostics = "underline",
  },
  disable = {
    background = true, -- Disable setting the background color
    cursorline = false, -- Disable the cursorline
    eob_lines = false, -- Hide the end-of-buffer lines
  },
  -- Inverse highlight for different groups
  inverse = {
    match_paren = true,
  },
  custom_highlights = {    TSConstructor = { fg = colors.dark_blue },
  },
  custom_colors = {
    red = "#ffffff",}, -- Overwrite default highlight groups
  custom_colors = {}, -- Overwrite default colors
})
