vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
require('core.plugins')
require('core.pack'):boot_load()
require('core.options')
require('core.mapping')
