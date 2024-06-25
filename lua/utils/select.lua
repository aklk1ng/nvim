local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local telescope_opts = {
    prompt_title = opts.prompt or '',
    previewer = false,
    sorter = conf.generic_sorter({}),
    finder = finders.new_table({
      results = items,
      entry_maker = function(item)
        local fmt = opts.format_item or vim.inspect
        local formatted = fmt(item)
        return {
          display = formatted,
          ordinal = formatted,
          value = item,
        }
      end,
    }),
    attach_mappings = function(buf)
      actions.select_default:replace(function()
        local selection = require('telescope.actions.state').get_selected_entry()
        -- to prevent calling it twice
        local cb = on_choice
        on_choice = function() end
        actions.close(buf)
        if not selection then
          cb(nil, nil)
        else
          cb(items[selection.index], selection.index)
        end
      end)
      actions.close:enhance({
        post = function()
          on_choice(nil, nil)
        end,
      })
      return true
    end,
  }
  pickers.new(require('telescope.themes').get_dropdown(), telescope_opts):find()
end
