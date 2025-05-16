return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    direction = 'float',
    mode = 'normal',
  },
  config = true,
  keys = {
    {
      '<leader>t',
      function()
        return vim.cmd('ToggleTerm' .. vim.v.count1)
      end,
      desc = '[t]erminal',
    },
  },
}

-- to correctly work with venv make sure init script (ie. .zshrc) has the follwoing configeration
-- if [ "$SHLVL" = 1]; then
--    export PATH = (all path commands)
-- fi
