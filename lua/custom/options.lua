-- options.lua

-- Aliases for Neovim options
local o = vim.opt
local g = vim.g

---
-- General UI & Editor Basics
-------------------------------------------------------------------------------
o.termguicolors = true -- True colors
o.number = true -- Line numbers
o.relativenumber = true -- Relative line numbers
o.mouse = 'a' -- Mouse support
o.showmode = false -- Hide mode messages
o.cmdheight = 0 -- Command line height
o.pumheight = 10 -- Completion menu height

---
-- Indentation
-------------------------------------------------------------------------------
o.expandtab = true -- Spaces for tabs
o.tabstop = 2 -- Tab width
o.shiftwidth = 2 -- Indent width
o.softtabstop = 2 -- Tab key behavior
o.autoindent = true -- Auto-indent

---
-- Editing Enhancements
-------------------------------------------------------------------------------
o.breakindent = true -- Wrapped line indent
o.ignorecase = true -- Case-insensitive search
o.smartcase = true -- Smart case search
o.inccommand = 'split' -- Live substitution preview
o.cursorline = true -- Highlight current line
o.confirm = true -- Confirm unsaved close

---
-- Performance & Responsiveness
-------------------------------------------------------------------------------
o.updatetime = 750 -- CursorHold frequency
o.timeoutlen = 500 -- Key sequence timeout
o.redrawtime = 2000 -- Max redraw time
o.synmaxcol = 2000 -- Syntax highlight max column

---
-- File Handling & History
-------------------------------------------------------------------------------
o.undofile = true -- Save undo history
o.swapfile = false -- Disable swap files (no crash recovery)

---
-- Visual Layout
-------------------------------------------------------------------------------
o.signcolumn = 'yes' -- Always show signcolumn
o.splitright = true -- Vertical splits right
o.splitbelow = true -- Horizontal splits below
o.scrolloff = 8 -- Scroll context lines
o.list = true -- Show invisible chars
o.listchars = { -- Invisible char display
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

---
-- Spelling
-------------------------------------------------------------------------------
o.spell = true -- Enable spell check
o.spelllang = { 'en_gb' } -- British English

---
-- Folding (Tree-sitter based)
-------------------------------------------------------------------------------
o.foldmethod = 'expr' -- Expression folding
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Treesitter folding
o.foldlevel = 99 -- All folds open
o.foldenable = true -- Enable folding
o.foldtext = '' -- Empty fold text
o.fillchars = { -- Fold fill characters
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = ' ',
  eob = ' ',
}

---
-- Global Flags & Minor Optimizations
-------------------------------------------------------------------------------
g.have_nerd_font = true -- Nerd Font flag
g.markdown_recommended_style = 0 -- prevents rewrite of markdown style
