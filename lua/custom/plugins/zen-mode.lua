return {
  'folke/zen-mode.nvim',
  dependencies = { 'folke/twilight.nvim' },
  keys = {
    {
      '<leader>z',
      function()
        return vim.cmd 'ZenMode'
      end,
      desc = '[Z]en mode',
    },
  },

  opts = {
    window = {
      options = {
        signcolumn = 'no', -- disable signcolumn
        number = false, -- disable number column
        relativenumber = false,
      },
    },
  },
}
