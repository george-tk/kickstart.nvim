if vim.g.vscode then
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
else
  -- Remap Keys
  require 'key-mapping'
  -- Core Options
  require 'options'
  -- Plugins
  require 'plugin-loader'
  -- Health Check
  require 'health'
  -- Auto Commands
  require 'auto-commands'
end
