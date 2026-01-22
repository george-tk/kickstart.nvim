return {
  'folke/snacks.nvim',
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = { layout = { position = 'right' } },
          jump = { close = true },
        },
      },
    },
  },
  keys = {
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      desc = '[e]xplore',
    },
  },
}
