local helper = {}
local home = os.getenv('HOME')

function helper.get_config_path()
    local config = os.getenv('XDG_CONFIG_DIR')
    if not config then
        return home .. '/.config/nvim'
    end
    return config
end

function helper.get_data_path()
    local data = os.getenv('XDG_DATA_DIR')
    if not data then
        return home .. '/.local/share/nvim'
    end
    return data
end

function helper.get_current_filetype()
    return vim.api.nvim_buf_get_option(0, "filetype")
    -- return vim.fn.expand('%:e')
end

return helper
