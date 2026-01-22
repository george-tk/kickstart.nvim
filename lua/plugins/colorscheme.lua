return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
    vim.cmd.hi 'Comment gui=none'
    vim.cmd.hi 'Folded guibg=none'
  end,
  opts = {
    flavour = 'mocha',
    transparent_background = true,
    show_end_of_buffer = false,
    styles = {
      comments = {},
      conditionals = {},
    },
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      mason = true,
      mini = { enabled = true },
      native_lsp = { enabled = true },
      neogit = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
      snacks = true,
    },
  },
}
