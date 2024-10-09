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
  keys = {
    { '<leader>gs', ':Neogit<CR>', desc = '[G]it [S]tatus' },
    { '<leader>gc', ':Neogit commit <CR>', desc = '[G]it [C]ommit' },
    { '<leader>gr', ':Neogit rebase <CR>', desc = '[G]it [R]ebase' },
    { '<leader>gp', ':Neogit pull <CR>', desc = '[G]it [P]ull' },
    { '<leader>gP', ':Neogit push <CR>', desc = '[G]it [P]ush' },
    { '<leader>gb', ':Neogit branch <CR>', desc = '[G]it [B]ranch' },
    { '<leader>gd', ':DiffviewOpen <CR>', desc = '[G]it [D]iff' },
  },
}
