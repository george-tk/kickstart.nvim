return {
  'linux-cultist/venv-selector.nvim',
  cmd = 'VenvSelect',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python', --optional
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  branch = 'regexp', -- This is the regexp branch, use this for the new version
  opts = {},
}

-- requires brew install fd to work
