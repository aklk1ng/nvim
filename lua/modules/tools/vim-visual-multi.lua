local M = {}

function M.config()
    vim.g.VM_theme = 'ocean'
    vim.g.VM_highlight_matches = 'underline'
    vim.g.VM_maps = {
        ['Find Under'] = '<C-n>',
        ['Find Subword Under'] = '<C-n>',
        -- ['Select All'] = '<C-d>',
        ['Select h'] = '<C-h>',
        ['Select l'] = '<C-l>',
        ['Add Cursor Up'] = '<C-k>',
        ['Add Cursor Down'] = '<C-j>',
        -- ['Add Cursor At Pos'] = '<C-x>',
        -- ['Add Cursor At Word'] = '<C-w>',
        ['Move Left'] = '<C-S-Left>',
        ['Move Right'] = '<C-S-Right>',
        ['Remove Region'] = 'q',
        ['Increase'] = '+',
        ['Decrease'] = '_',
        ["Undo"] = 'u',
        ["Redo"] = '<C-r>',
    }
end

return M
