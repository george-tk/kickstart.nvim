return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
  },
  opts = { popup = {
    kind = 'tab',
  }, rebase_editor = {
    kind = 'tab',
  } },
  vim.keymap.set('n', '<leader>gs', ':Neogit<CR>', { desc = '[G]it [S]tatus' }),
  vim.keymap.set('n', '<leader>gc', ':Neogit commit <CR>', { desc = '[G]it [C]ommit' }),
  vim.keymap.set('n', '<leader>gr', ':Neogit rebase <CR>', { desc = '[G]it [R]ebase' }),
  vim.keymap.set('n', '<leader>gp', ':Neogit pull <CR>', { desc = '[G]it [P]ull' }),
  vim.keymap.set('n', '<leader>gP', ':Neogit push <CR>', { desc = '[G]it [P]ush' }),
  vim.keymap.set('n', '<leader>gb', ':Neogit branch <CR>', { desc = '[G]it [B]ranch' }),
  vim.keymap.set('n', '<leader>gd', ':DiffviewOpen <CR>', { desc = '[G]it [D]iff' }),
}
