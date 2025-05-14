-- auto-commands.lua
-- Purpose: Autocommands and related functions for Neovim,
-- focusing on Markdown note-taking enhancements.

local M = {}

-- Lua module aliases for brevity and direct access
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local bo = vim.bo -- Buffer-local options: vim.bo[bufnr]
local wo = vim.wo -- Window-local options: vim.wo[winnr]
local opt_local = vim.opt_local -- For setting buffer/window local options directly
local uv = vim.uv -- Access to libuv functions

--- Helper for consistent notifications
-- @param msg string: The message to display
-- @param level (optional) vim.log.levels: Severity level (e.g., INFO, WARN, ERROR)
-- @param opts (optional) table: Additional options for vim.notify
local function notify(msg, level, opts)
  vim.notify(msg, level or vim.log.levels.INFO, opts or {})
end

-- Lazy-loaded module cache
local Path_module
local snacks_module

--- Lazily loads and returns the plenary.path module.
-- @return table|nil: The Path module or nil if loading failed.
local function get_Path()
  if Path_module then
    return Path_module
  end
  local ok, Path = pcall(require, 'plenary.path')
  if not ok or not Path or not Path.new then
    notify("plenary.nvim Path module not available. Please ensure it's installed and loaded.", vim.log.levels.ERROR)
    return nil
  end
  Path_module = Path
  return Path_module
end

--- Lazily loads and returns the snacks.nvim module.
-- @return table|nil: The snacks module or nil if loading failed.
local function get_snacks()
  if snacks_module then
    return snacks_module
  end
  local ok, snacks = pcall(require, 'snacks')
  if not ok or not snacks or not snacks.picker or not snacks.picker.files then
    notify("snacks.nvim file picker not available. Please ensure it's installed and loaded.", vim.log.levels.ERROR)
    return nil
  end
  snacks_module = snacks
  return snacks_module
end

--- Function to robustly close a picker window.
-- @param picker table: The picker object, expected to have a `close` method.
local function close_picker_robustly(picker)
  if picker and picker.close and type(picker.close) == 'function' then
    local close_ok, close_err = pcall(function()
      picker:close()
    end)
    if not close_ok then
      notify('Error closing picker with its method: ' .. tostring(close_err), vim.log.levels.WARN)
      pcall(cmd.pclose) -- Fallback: Close preview window if picker's close fails
    end
  else
    pcall(cmd.pclose) -- Fallback: Close preview window if picker.close is not available
  end
end

--- Creates a relative Markdown link from a file selected using snacks.nvim.
function M.create_markdown_link_from_snack()
  local current_buf_nr = api.nvim_get_current_buf()
  local current_buf_path_str = api.nvim_buf_get_name(current_buf_nr)

  if not current_buf_path_str or current_buf_path_str == '' then
    notify('Current buffer has no path. Cannot create relative link.', vim.log.levels.WARN)
    return
  end

  local original_win_id = api.nvim_get_current_win()
  local original_cursor_pos = api.nvim_win_get_cursor(original_win_id) -- {row, col} (1-idx, 0-idx)

  local current_buf_dir_str = fn.fnamemodify(current_buf_path_str, ':p:h')
  if not current_buf_dir_str or current_buf_dir_str == '' or current_buf_dir_str == '.' then
    current_buf_dir_str = fn.getcwd()
    notify('Could not reliably determine current buffer directory. Using CWD (' .. current_buf_dir_str .. ') for relative path.', vim.log.levels.WARN)
  end

  local snacks = get_snacks()
  if not snacks then
    return
  end

  local Path = get_Path()
  if not Path then
    return
  end

  snacks.picker.files {
    prompt = 'Select file to link: ',
    confirm = function(picker, _)
      local selected_items = picker:selected { fallback = true }

      if not selected_items or #selected_items == 0 then
        notify('No file selected from picker.', vim.log.levels.INFO)
        close_picker_robustly(picker)
        return
      end

      local selected_item = selected_items[1]
      local picked_file_path_str = selected_item.text or selected_item.value

      if not picked_file_path_str or picked_file_path_str == '' then
        notify('Failed to get path from selected item.', vim.log.levels.ERROR)
        close_picker_robustly(picker)
        return
      end

      local p_picked_file = Path:new(picked_file_path_str)
      local p_current_dir = Path:new(current_buf_dir_str)

      local abs_picked_file_path = p_picked_file:absolute()
      local abs_current_buf_dir = p_current_dir:absolute()

      local relative_path_str = Path:new(abs_picked_file_path):make_relative(abs_current_buf_dir)
      relative_path_str = fn.substitute(relative_path_str, ' ', '%20', 'g')

      local link_text = fn.fnamemodify(picked_file_path_str, ':t')
      link_text = link_text:gsub('%.md$', ''):gsub('%.markdown$', '')

      local markdown_link = string.format('[%s](%s)', link_text, relative_path_str)

      if api.nvim_get_current_win() ~= original_win_id then
        api.nvim_set_current_win(original_win_id)
      end

      local insert_row = original_cursor_pos[1] - 1
      local insert_col = original_cursor_pos[2]

      api.nvim_buf_set_text(current_buf_nr, insert_row, insert_col, insert_row, insert_col, { markdown_link })
      api.nvim_win_set_cursor(original_win_id, { original_cursor_pos[1], original_cursor_pos[2] + #markdown_link })

      notify('Markdown link inserted: ' .. markdown_link)
      close_picker_robustly(picker)
    end,
    cancel = function(picker)
      notify('File selection cancelled.', vim.log.levels.INFO)
      close_picker_robustly(picker)
    end,
  }
end

api.nvim_create_user_command('CreateSnackMarkdownLink', function()
  M.create_markdown_link_from_snack()
end, {
  desc = 'Pick a file with snacks.nvim and insert a relative markdown link.',
})

vim.keymap.set('n', '<leader>mf', '<cmd>CreateSnackMarkdownLink<CR>', { desc = '[f]ind link' })

local augroups = {
  user_highlight_yank = api.nvim_create_augroup('UserHighlightYank', { clear = true }),
  user_auto_create_dir = api.nvim_create_augroup('UserAutoCreateDir', { clear = true }),
  user_markdown_autosave = api.nvim_create_augroup('UserMarkdownAutosave', { clear = true }),
  user_markdown_folding = api.nvim_create_augroup('UserMarkdownFolding', { clear = true }),
  user_render_markdown_fixes = api.nvim_create_augroup('UserRenderMarkdownFixes', { clear = true }),
}

api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text briefly',
  group = augroups.user_highlight_yank,
  callback = function()
    vim.hl.on_yank()
  end,
})

api.nvim_create_autocmd('BufWritePre', {
  desc = 'Auto create parent directories on save',
  group = augroups.user_auto_create_dir,
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

api.nvim_create_autocmd('InsertLeave', {
  group = augroups.user_markdown_autosave,
  pattern = '*.md,*.markdown',
  command = 'silent! write',
  desc = 'Autosave *.md, *.markdown on leaving Insert mode',
})

api.nvim_create_autocmd('BufLeave', {
  group = augroups.user_markdown_autosave,
  pattern = '*.md,*.markdown',
  command = 'silent! write',
  desc = 'Autosave *.md, *.markdown on leaving buffer',
})

function M.markdown_foldexpr()
  local lnum = vim.v.lnum
  local line = fn.getline(lnum)

  local syn_name = fn.synIDattr(fn.synID(lnum, 1, 1), 'name')
  if syn_name and (syn_name:match 'markdownCodeBlock' or syn_name:match 'markdownCode') then
    return '='
  end

  local heading_match = line:match '^(#+)%s+'
  if heading_match then
    local level = #heading_match
    if level == 1 then
      if lnum == 1 then
        return '>1'
      else
        -- Access frontmatter_end as a custom buffer variable via vim.b
        -- This variable needs to be set by your other configurations or plugins.
        local fm_end = vim.b.frontmatter_end -- CORRECTED
        if fm_end and type(fm_end) == 'number' and (lnum == fm_end + 1) then
          return '>1'
        end
        return '>1'
      end
    elseif level >= 2 and level <= 6 then
      return '>' .. level
    end
  end
  return '='
end

api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  group = augroups.user_markdown_folding,
  callback = function(args)
    opt_local.foldmethod = 'expr'
    -- IMPORTANT: Adjust 'user.auto-commands' if your require path is different.
    opt_local.foldexpr = "v:lua.require('custom.auto-commands').markdown_foldexpr()"
    opt_local.fillchars:append { eob = ' ' }

    cmd 'normal! zM'
    cmd 'normal! zr'
  end,
  desc = 'Setup Markdown folding and other local options',
})

api.nvim_create_autocmd('BufEnter', {
  group = augroups.user_render_markdown_fixes,
  pattern = { '*.md', '*.markdown' },
  callback = function(args)
    vim.schedule(function()
      local success_rm, rm = pcall(require, 'render-markdown')
      if not success_rm or not rm or not rm.buf_enable then
        return
      end

      if not api.nvim_buf_is_valid(args.buf) or not bo[args.buf].modifiable then
        return
      end

      local ft = bo[args.buf].filetype
      if ft == 'markdown' or ft == '' then
        local enable_ok, enable_err = pcall(rm.buf_enable, args.buf)
        if not enable_ok then
          notify('Failed to enable render-markdown for buffer ' .. args.buf .. ': ' .. tostring(enable_err), vim.log.levels.WARN)
        end
      end
    end)
  end,
  desc = 'Ensure render-markdown re-activates on buffer enter for Markdown files',
})

function M.choose_fold_level(level_to_apply)
  local current_foldmethod = wo[0].foldmethod
  if not (current_foldmethod == 'expr' or current_foldmethod == 'manual' or current_foldmethod == 'syntax') then
    notify("Current foldmethod ('" .. current_foldmethod .. "') does not support level-based folding with zr/zM.", vim.log.levels.WARN)
    return
  end

  if level_to_apply <= 0 then
    cmd 'normal! zM'
    notify('All folds closed.', vim.log.levels.INFO, { title = 'Folding' })
  else
    cmd 'normal! zM'
    cmd('normal! ' .. level_to_apply .. 'zr')
  end
end

vim.keymap.set('n', '<leader>F', function()
  M.choose_fold_level(vim.v.count1)
end, { desc = '[f]old level' })

return M
