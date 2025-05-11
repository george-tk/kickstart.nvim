local M = {}

function M.create_markdown_link_from_snack()
  local current_buf_nr = vim.api.nvim_get_current_buf()
  local current_buf_path_str = vim.api.nvim_buf_get_name(current_buf_nr)

  -- Capture the original window ID and cursor position *before* showing the picker
  local original_win_id = vim.api.nvim_get_current_win()
  local original_cursor_pos = vim.api.nvim_win_get_cursor(original_win_id) -- {row, col} (row 1-idx, col 0-idx)

  if current_buf_path_str == '' then
    vim.notify('Current buffer has no path. Cannot create relative link.', vim.log.levels.WARN)
    return
  end

  local current_buf_dir_str = vim.fn.expand '%:p:h'
  if current_buf_dir_str == '' or current_buf_dir_str == '.' then
    current_buf_dir_str = vim.fn.getcwd()
    vim.notify('Could not reliably determine current buffer directory. Using CWD for relative path: ' .. current_buf_dir_str, vim.log.levels.WARN)
  end

  local snacks_ok, snacks = pcall(require, 'snacks')
  if not snacks_ok or not snacks.picker or not snacks.picker.files then
    vim.notify("snacks.nvim file picker not available. Please ensure it's installed and loaded.", vim.log.levels.ERROR)
    return
  end

  local plenary_path_ok, Path = pcall(require, 'plenary.path')
  if not plenary_path_ok or not Path or not Path.new then
    vim.notify("plenary.nvim Path module not available. Please ensure it's installed and loaded.", vim.log.levels.ERROR)
    return
  end

  snacks.picker.files {
    prompt = 'Select file to link: ',
    confirm = function(picker, _)
      local selected_items = picker:selected { fallback = true }

      local close_picker = function()
        if picker and picker.close and type(picker.close) == 'function' then
          pcall(function()
            picker:close()
          end)
        else
          pcall(vim.cmd.pclose)
        end
      end

      if not selected_items or #selected_items == 0 then
        vim.notify('No file selected from picker.', vim.log.levels.INFO)
        close_picker()
        return
      end

      local selected_item = selected_items[1]
      local picked_file_path_str = selected_item.text

      if not picked_file_path_str or picked_file_path_str == '' then
        vim.notify('Failed to get path from selected item.', vim.log.levels.ERROR)
        close_picker()
        return
      end

      local p_picked_file = Path:new(picked_file_path_str)
      local p_current_dir = Path:new(current_buf_dir_str)

      local abs_picked_file_path = p_picked_file:absolute()
      local abs_current_buf_dir = p_current_dir:absolute()

      local relative_path_str = Path:new(abs_picked_file_path):make_relative(abs_current_buf_dir)
      local link_text = vim.fn.fnamemodify(picked_file_path_str, ':t')
      local markdown_link = string.format('[%s](%s)', link_text, relative_path_str)

      -- Use the CAPTURED original cursor position for insertion
      local insert_row = original_cursor_pos[1] - 1 -- Convert 1-indexed row to 0-indexed for API
      local insert_col = original_cursor_pos[2] -- Column is already 0-indexed from nvim_win_get_cursor

      vim.api.nvim_buf_set_text(current_buf_nr, insert_row, insert_col, insert_row, insert_col, { markdown_link })

      vim.notify('Markdown link inserted: ' .. markdown_link, vim.log.levels.INFO)
      close_picker()
    end,
    cancel = function(picker)
      vim.notify('File selection cancelled.', vim.log.levels.INFO)
      if picker and picker.close and type(picker.close) == 'function' then
        pcall(function()
          picker:close()
        end)
      else
        pcall(vim.cmd.pclose)
      end
    end,
  }
end

-- Ensure the command is created (this part remains the same)
local command_exists = false
for _, cmd in ipairs(vim.api.nvim_get_commands {}) do
  if cmd.name == 'CreateSnackMarkdownLink' then
    command_exists = true
    break
  end
end

if not command_exists then
  vim.api.nvim_create_user_command('CreateSnackMarkdownLink', function()
    M.create_markdown_link_from_snack()
  end, {
    desc = 'Pick a file with snack.nvim and insert a relative markdown link.',
  })
end
--
vim.keymap.set('n', '<leader>mf', '<cmd>CreateSnackMarkdownLink<CR>', { desc = '[f]ind link' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  desc = 'Auto Create Directories',
  group = vim.api.nvim_create_augroup('kickstart-autocreate', { clear = true }),
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Autosave markdown files when leaving buffer
vim.api.nvim_create_autocmd('BufLeave', {
  pattern = '*.md',
  command = 'silent! wall',
})
function _G.markdown_foldexpr()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)
  local heading = line:match '^(#+)%s'
  if heading then
    local level = #heading
    if level == 1 then
      -- Special handling for H1
      if lnum == 1 then
        return '>1'
      else
        local frontmatter_end = vim.b.frontmatter_end
        if frontmatter_end and (lnum == frontmatter_end + 1) then
          return '>1'
        end
      end
    elseif level >= 2 and level <= 6 then
      -- Regular handling for H2-H6
      return '>' .. level
    end
  end
  return '='
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.foldexpr = 'v:lua.markdown_foldexpr()'
    vim.cmd 'normal! zM'
    vim.cmd 'normal! zr'
  end,
})

-- Ensure you have an augroup for your plugin-specific autocommands
local renderMarkdownGroup = vim.api.nvim_create_augroup('UserRenderMarkdownFixes', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = renderMarkdownGroup,
  pattern = { '*.md', '*.markdown' }, -- Add any other markdown patterns you use
  callback = function(args)
    -- Check if the plugin and its functions are available
    local success, rm = pcall(require, 'render-markdown')
    if success and rm and rm.buf_enable then
      -- Attempt to enable rendering for the current buffer (0 means current buffer)
      -- Adding a small delay can sometimes help if there's a race condition
      -- with other BufEnter events or the buffer isn't fully "ready" immediately.
      vim.defer_fn(function()
        -- Check if the buffer is still valid and modifiable,
        -- and if the filetype is still markdown (paranoid check)
        if
          vim.api.nvim_buf_is_valid(args.buf)
          and vim.bo[args.buf].modifiable
          and (vim.bo[args.buf].filetype == 'markdown' or vim.bo[args.buf].filetype == '')
        then -- Allow empty ft if it's set later
          -- Using args.buf directly might be more robust here
          rm.buf_enable(args.buf)
          -- You could also try rm.toggle_buf_render(args.buf, true) if buf_enable isn't enough,
          -- though buf_enable is usually the intended way.
        end
      end, 10) -- 10ms delay, adjust if needed or remove if it works without.
    end
  end,
  desc = 'Ensure render-markdown re-activates on buffer enter for reopened files',
})

function choosefoldlevel(level_to_apply)
  local base_cmd = 'zM'
  local open_cmds = string.rep('zr', level_to_apply)
  vim.cmd('normal! ' .. base_cmd .. open_cmds)
end

vim.keymap.set('n', '<leader>F', function()
  choosefoldlevel(vim.v.count1)
end, { desc = '[F]old level' })
