vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
require('core.options')
require('core.mapping')
require('core.pack'):boot_strap()
