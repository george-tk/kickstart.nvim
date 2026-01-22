return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'folke/snacks.nvim',
  },
  -- opts = { popup = {
  --   kind = 'tab',
  -- }, rebase_editor = {
  --   kind = 'tab',
  -- } },
  keys = {
    { '<leader>gs', ':Neogit<CR>', desc = '[s]tatus' },
    { '<leader>gc', ':Neogit commit <CR>', desc = '[c]ommit' },
    { '<leader>gr', ':Neogit rebase <CR>', desc = '[r]ebase' },
    { '<leader>gp', ':Neogit pull <CR>', desc = '[p]ull' },
    { '<leader>gP', ':Neogit push <CR>', desc = '[P]ush' },
    { '<leader>gb', ':Neogit branch <CR>', desc = '[b]ranch' },
    { '<leader>gd', ':DiffviewOpen <CR>', desc = '[d]iff' },
  },
}
