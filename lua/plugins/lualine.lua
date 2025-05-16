return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = { { 'buffers', mode = 2, max_length = vim.o.columns * 0.9 } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },

  vim.keymap.set('n', '<leader>bb', function()
    return vim.cmd('LualineBuffersJump' .. vim.v.count1)
  end, { desc = 'go to [b]uffer' }),
  vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = '[n]ext' }),
  vim.keymap.set('n', '<leader>bp', ':bp<CR>', { desc = '[p]revious' }),
  vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = '[d]elete' }),
  vim.keymap.set('n', '<leader>br', '<C-6>', { desc = '[r]eturn' }),
}
