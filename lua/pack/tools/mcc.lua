require('mcc').setup({
    c = { '-', '->', '-' },
    -- also like this
    -- c = { '-', '->', '-', '-----', '-------' },
    go = { ';', ':=', ';' },
    rust = { ';', '::', ';' },
    -- not signal char anything you want change
    -- rust = { '88', '::', '88' },
    -- also support mulitple rules
    -- go = {
    --     { ';', ':=', ';' },
    --     { '/', ':=', ';' },
    -- }
})
