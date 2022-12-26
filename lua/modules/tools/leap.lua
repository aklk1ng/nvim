local M = {}

function M.setup()
    require('leap').setup({
        highlight_unlabeled_phase_one_targets = true
    })
end

return M
