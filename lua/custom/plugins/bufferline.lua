return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = { options = {
    numbers = 'ordinal',
  } },
  vim.keymap.set('n', '<leader>bb', function()
    return vim.cmd('BufferLineGoToBuffer' .. vim.v.count1)
  end, { desc = 'go to buffer' }),
  vim.keymap.set('n', '<leader>bn', function()
    return vim.cmd 'BufferLineCycleNext'
  end, { desc = ' [B]uffer [N]ext ' }),
  vim.keymap.set('n', '<leader>bp', function()
    return vim.cmd 'BufferLineCyclePrev'
  end, { desc = ' [B]uffer [P]revious ' }),
  vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = ' [B]uffer [D]elete ' }),
}
