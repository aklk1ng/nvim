local M = {}

function M.setup()
    require('leap').setup({
        highlight_unlabeled_phase_one_targets = true
    })
    require('leap').add_default_mappings()
end

return M
