--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- spelling
vim.keymap.set('n', '<leader>sS', '<cmd>set spell!<CR>', { desc = '[S]et [S]pell' })

-- autoindent pasted text
vim.keymap.set('n', 'p', 'p=`]', { desc = 'Indented Paste' })
