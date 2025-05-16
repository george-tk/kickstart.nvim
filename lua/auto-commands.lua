-- auto-commands.lua
-- Autocommands and functions for Neovim, focused on Markdown notes.

local M = {}

-- Aliases for Neovim APIs
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local bo = vim.bo -- Buffer-local options
local wo = vim.wo -- Window-local options
local opt_local = vim.opt_local -- Local options setter
local uv = vim.uv -- libuv functions

-- Simple notification helper
local function notify(msg, level, opts)
  vim.notify(msg, level or vim.log.levels.INFO, opts or {})
end

-- Lazy-loaded module cache
local Path_module
local snacks_module

-- Get plenary.path module (lazy load)
local function get_Path()
  if Path_module then
    return Path_module
  end
  local ok, Path = pcall(require, 'plenary.path')
  if not ok or not Path or not Path.new then
    notify('plenary.nvim Path module not available.', vim.log.levels.ERROR)
    return nil
  end
  Path_module = Path
  return Path_module
end

-- Get snacks.nvim module (lazy load)
local function get_snacks()
  if snacks_module then
    return snacks_module
  end
  local ok, snacks = pcall(require, 'snacks')
  if not ok or not snacks or not snacks.picker or not snacks.picker.files then
    notify('snacks.nvim file picker not available.', vim.log.levels.ERROR)
    return nil
  end
  snacks_module = snacks
  return snacks_module
end

-- Robustly close a picker window
local function close_picker_robustly(picker)
  if picker and type(picker.close) == 'function' then
    pcall(picker.close, picker) -- Use pcall with self argument
  else
    pcall(cmd.pclose) -- Fallback
  end
end

--- Create a relative Markdown link from a file selected via snacks.nvim
function M.create_markdown_link_from_snack()
  local current_buf_nr = api.nvim_get_current_buf()
  local current_buf_path_str = api.nvim_buf_get_name(current_buf_nr)

  if not current_buf_path_str or current_buf_path_str == '' then
    notify('Current buffer has no path.', vim.log.levels.WARN)
    return
  end

  local original_win_id = api.nvim_get_current_win()
  local original_cursor_pos = api.nvim_win_get_cursor(original_win_id) -- {row, col} (1-idx, 0-idx)

  local current_buf_dir_str = fn.fnamemodify(current_buf_path_str, ':p:h')
  if not current_buf_dir_str or current_buf_dir_str == '' or current_buf_dir_str == '.' then
    current_buf_dir_str = fn.getcwd()
    notify('Using CWD for relative path: ' .. current_buf_dir_str, vim.log.levels.WARN)
  end

  local snacks = get_snacks()
  local Path = get_Path()
  if not snacks or not Path then
    return
  end

  snacks.picker.files {
    prompt = 'Select file to link: ',
    confirm = function(picker, _)
      local selected_items = picker:selected { fallback = true }
      if not selected_items or #selected_items == 0 then
        notify('No file selected.', vim.log.levels.INFO)
        close_picker_robustly(picker)
        return
      end

      local picked_file_path_str = selected_items[1].text or selected_items[1].value
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
      relative_path_str = fn.substitute(relative_path_str, ' ', '%20', 'g') -- Escape spaces

      local link_text = fn.fnamemodify(picked_file_path_str, ':t')
      link_text = link_text:gsub('%.md$', ''):gsub('%.markdown$', '') -- Remove markdown extensions

      local markdown_link = string.format('[%s](%s)', link_text, relative_path_str)

      -- Restore original window and insert text
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

-- User Command and Keymap for creating Markdown links
api.nvim_create_user_command('CreateSnackMarkdownLink', function()
  M.create_markdown_link_from_snack()
end, { desc = 'Pick file and insert relative markdown link' })

vim.keymap.set('n', '<leader>mf', '<cmd>CreateSnackMarkdownLink<CR>', { desc = '[f]ind link' })

---
-- Autocommand Groups
-------------------------------------------------------------------------------
local augroups = {
  user_highlight_yank = api.nvim_create_augroup('UserHighlightYank', { clear = true }),
  user_auto_create_dir = api.nvim_create_augroup('UserAutoCreateDir', { clear = true }),
  user_markdown_autosave = api.nvim_create_augroup('UserMarkdownAutosave', { clear = true }),
  user_markdown_folding = api.nvim_create_augroup('UserMarkdownFolding', { clear = true }),
  user_render_markdown_fixes = api.nvim_create_augroup('UserRenderMarkdownFixes', { clear = true }),
}

---
-- General Autocommands
-------------------------------------------------------------------------------
-- Highlight yanked text
api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = augroups.user_highlight_yank,
  callback = function()
    vim.highlight.on_yank() -- Use vim.highlight.on_yank
  end,
})

-- Auto create parent directories on save
api.nvim_create_autocmd('BufWritePre', {
  desc = 'Auto create parent directories',
  group = augroups.user_auto_create_dir,
  callback = function(event)
    -- Skip non-file protocols
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

---
-- Markdown Specific Autocommands & Functions
-------------------------------------------------------------------------------

-- Callback to format and save markdown files
local function autosave_and_format_markdown(args)
  local ok, conform = pcall(require, 'conform')
  if ok then
    conform.format { bufnr = args.buf }
  end
  cmd 'silent! write' -- Save the buffer
end

-- Autosave & format markdown on leaving Insert mode
api.nvim_create_autocmd('InsertLeave', {
  group = augroups.user_markdown_autosave,
  pattern = '*.md,*.markdown',
  callback = autosave_and_format_markdown,
  desc = 'Autosave & format *.md, *.markdown on InsertLeave',
})

-- Autosave & format markdown on leaving buffer
api.nvim_create_autocmd('BufLeave', {
  group = augroups.user_markdown_autosave,
  pattern = '*.md,*.markdown',
  callback = autosave_and_format_markdown,
  desc = 'Autosave & format *.md, *.markdown on BufLeave',
})

-- General BufWritePre autoformatting (for manual saves)
api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    local ok, conform = pcall(require, 'conform')
    if ok then
      conform.format { bufnr = args.buf }
    end
  end,
  desc = 'Autoformat on BufWritePre (general)',
})

-- Markdown specific foldexpr function
function M.markdown_foldexpr()
  local lnum = vim.v.lnum
  local line = fn.getline(lnum)

  -- Do not fold code blocks
  local syn_name = fn.synIDattr(fn.synID(lnum, 1, 1), 'name')
  if syn_name and (syn_name:match 'markdownCodeBlock' or syn_name:match 'markdownCode') then
    return '='
  end

  -- Fold headings
  local heading_match = line:match '^(#+)%s+'
  if heading_match then
    local level = #heading_match
    -- Handle level 1 headings and potential frontmatter boundary
    if level == 1 then
      local fm_end = vim.b.frontmatter_end -- Assumes this buffer variable is set elsewhere
      if fm_end and type(fm_end) == 'number' and (lnum == fm_end + 1) then
        return '>1' -- Start fold after frontmatter
      elseif lnum == 1 then
        return '>1' -- Start fold at beginning if no frontmatter marker
      end
      return '>1' -- Default for other level 1 headings
    elseif level >= 2 and level <= 6 then
      return '>' .. level -- Fold levels 2-6
    end
  end
  return '=' -- No folding
end

-- FileType markdown setup (folding, options)
api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  group = augroups.user_markdown_folding,
  callback = function(args)
    opt_local.foldexpr = "v:lua.require('auto-commands').markdown_foldexpr()"
    opt_local.fillchars:append { eob = ' ' } -- Ensure end-of-buffer char is space

    cmd 'normal! zM' -- Close all folds initially
    cmd 'normal! zr' -- Open one level of folds
  end,
  desc = 'Setup Markdown folding and local options',
})

-- Ensure render-markdown re-activates on buffer enter for Markdown
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
        pcall(rm.buf_enable, args.buf) -- Attempt to enable render-markdown
      end
    end)
  end,
  desc = 'Ensure render-markdown is active on BufEnter for Markdown',
})

-- Function to choose fold level via <leader>F
function M.choose_fold_level(level_to_apply)
  local current_foldmethod = wo[0].foldmethod
  if not (current_foldmethod == 'expr' or current_foldmethod == 'manual' or current_foldmethod == 'syntax') then
    notify("Current foldmethod ('" .. current_foldmethod .. "') does not support level-based folding.", vim.log.levels.WARN)
    return
  end

  if level_to_apply <= 0 then
    cmd 'normal! zM' -- Close all folds
    notify('All folds closed.', vim.log.levels.INFO, { title = 'Folding' })
  else
    cmd 'normal! zM' -- Close all first
    cmd('normal! ' .. level_to_apply .. 'zr') -- Then open to specified level
  end
end

-- Keymap for choosing fold level
vim.keymap.set('n', '<leader>F', function()
  M.choose_fold_level(vim.v.count1) -- Use count (e.g., 2<leader>F for level 2)
end, { desc = '[f]old level' })

return M
