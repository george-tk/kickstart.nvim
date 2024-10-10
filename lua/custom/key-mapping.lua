--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- spelling
vim.keymap.set('n', '<leader>sS', '<cmd>set spell!<CR>', { desc = '[S]et [S]pell' })
-- Show spelling suggestions / spell suggestions
--vim.keymap.set('n', '<leader>Ss', 'z=', { desc = '[S]pelling [s]uggestions' })
vim.keymap.set('n', '<leader>sn', ']s', { desc = '[N]ext [S]pelling error' })
vim.keymap.set('n', '<leader>sp', '[s', { desc = '[P]revious [S]pelling error' })

-- autoindent pasted text
vim.keymap.set('n', 'p', 'p=`]', { desc = 'Indented Paste' })
