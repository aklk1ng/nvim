local helper = {}
local home = os.getenv('HOME')
helper.is_win = package.config:sub(1, 1) == '\\' and true or false
helper.path_sep = helper.is_win and '\\' or '/'

function helper.get_config_path()
  local config = os.getenv('XDG_CONFIG_DIR')
  if not config then
    return home .. '/.config/nvim'
  end
  return config
end

function helper.get_dotfile_path()
  return home .. '/.config'
end

function helper.get_data_path()
  local data = os.getenv('XDG_DATA_DIR')
  if not data then
    return home .. '/.local/share/nvim'
  end
  return data
end

return helper
