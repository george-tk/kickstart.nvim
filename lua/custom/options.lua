-- options.lua

-- Essential: Enable true colors
vim.opt.termguicolors = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true -- Consider if this is always needed; can be toggled

-- Mouse Mode
vim.opt.mouse = 'a' -- Useful, but 'nv' could be slightly more performant if 'a' is not fully needed

-- UI Elements
vim.opt.showmode = false -- Good, statusline usually handles this
vim.opt.cmdheight = 0 -- Experimental `cmdheight = 0` can sometimes have issues. `1` is stable.
vim.o.pumheight = 10 -- Pop-up menu height

-- Clipboard (WSL specific)
-- This setup is crucial for WSL1 or WSL2 without native clipboard integration (WSLg).
-- However, external process calls (`powershell.exe`) are inherently slower than native integration.
-- If you are on a modern WSL2 with WSLg, you MIGHT be able to remove `vim.g.clipboard`
-- and rely solely on `vim.opt.clipboard = 'unnamedplus'` for better performance. Test this!
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard
end)

vim.g.clipboard = {
  name = 'WslClipboard',
  copy = {
    ['+'] = 'clip.exe',
    ['*'] = 'clip.exe',
  },
  paste = {
    -- Consider -NoProfile for potentially faster powershell startup:
    ['+'] = 'powershell.exe -NoProfile -Command "[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))"',
    -- ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    -- ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0, -- Reliable, but means every paste/copy calls the external command.
}

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Number of visual spaces per TAB
vim.opt.shiftwidth = 2 -- Number of spaces for (auto)indent
vim.opt.softtabstop = 2 -- Number of spaces for TAB key presses (align with shiftwidth)
-- Setting to 2 (instead of -1) makes it explicit.
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.smartindent = false -- OFF by default. Relies on filetype indent scripts which are often better.
-- If you find indentation missing for some filetypes, ensure `filetype plugin indent on`
-- is in your main init.lua. `smartindent` can sometimes be slow or quirky.

-- Editing Enhancements
vim.opt.breakindent = true -- Maintain indent for wrapped lines
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true -- Override ignorecase if search term has uppercase
vim.opt.inccommand = 'split' -- Preview substitutions live
vim.opt.cursorline = true -- Highlight current line (minor performance cost, usually acceptable)
vim.opt.confirm = true -- Confirm when closing unsaved files

-- Performance & Responsiveness
vim.opt.updatetime = 750 -- Increased from 250. Time in ms for CursorHold event.
-- Lower values (like 250) fire more often, potentially impacting performance
-- if many plugins use CursorHold. Default is 4000. 750 is a reasonable compromise.
vim.opt.timeoutlen = 500 -- Increased from 300. Time in ms to wait for mapped sequence.
-- 300 is very short and can cause issues if you type chords slowly.
-- Default is 1000. 500 is a common faster setting.
vim.opt.redrawtime = 2000 -- Max ms to spend on :redraw screen updates (default 2000)
-- Consider reducing if you notice redraw lag, but often not the bottleneck.
vim.opt.synmaxcol = 2000 -- Max column to look for syntax highlighting (default 3000)
-- Reduce for very long lines if syntax highlighting is slow.

-- Files & History
vim.opt.undofile = true -- Save undo history
vim.opt.swapfile = false -- No swap files.This means no recovery if Neovim crashes with unsaved work.
-- If data integrity is paramount, set this to true.
-- Disabling it avoids disk I/O for swap files but sacrifices recovery.

-- Visuals & Layout
vim.opt.signcolumn = 'yes' -- Always show signcolumn to prevent layout shifts
vim.opt.splitright = true -- New vertical splits to the right
vim.opt.splitbelow = true -- New horizontal splits below
vim.opt.scrolloff = 8 -- Reduced from 20. Keeps 8 lines above/below cursor.
-- Very high scrolloff can feel 'jumpy'. 8 is a common preference.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Spelling
vim.opt.spell = true
vim.opt.spelllang = { 'en_gb' }

-- Folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99 -- Folds open by default
vim.opt.foldenable = true -- Enable folding
vim.opt.foldtext = ''
vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = ' ',
  eob = ' ',
}

-- Nerd Font Global Flag (useful for plugins)
vim.g.have_nerd_font = true

-- Disable some built-in providers if not used (minor optimization, for advanced users)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
