if vim.g.vscode then
  
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
else

  -- Remap Keys
  require 'custom.key-mapping'
  -- Core Options
  require 'custom.options'
  -- Plugins
  require 'custom.lazy'
  -- Health Check
  require 'custom.health'
end
