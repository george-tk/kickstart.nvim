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
  end, { desc = 'go to buffer' }),
  vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = '[B]uffer [N]ext' }),
  vim.keymap.set('n', '<leader>bp', ':bp<CR>', { desc = '[B]uffer [P]revious' }),
  vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = '[B]uffer [D]elete' }),
  vim.keymap.set('n', '<leader>br', '<C-6>', { desc = '[B]uffer [R]eturn' }),
}
