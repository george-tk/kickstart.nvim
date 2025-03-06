return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            -- to close the picker on ESC instead of going to normal mode,
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<Tab>'] = { 'list_down', mode = { 'i', 'n' } },
            ['<S-Tab>'] = { 'list_up', mode = { 'i', 'n' } },
          },
        },
      },
    },
    explorer = {},
  },
  keys = {
    -- Top Pickers & Explorer
    {
      '<leader>ff',
      function()
        Snacks.picker.files()
      end,
      desc = 'find files',
    },
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'find buffers',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.spelling {
          layout = { layout = { relative = 'cursor', height = 5, min_height = 10, min_width = 18, width = 0.1 }, backdrop = false },
        }
      end,
      desc = 'spelling suggestion',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'resume find',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.help()
      end,
      desc = 'find help',
    },
    {
      '<leader>fk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'find keymaps',
    },
    {
      '<leader>fp',
      function()
        Snacks.picker.pickers()
      end,
      desc = 'find pickers',
    },
    {
      '<leader>fwb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'find word in current buffer',
    },
    {
      '<leader>fwB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'find work in open Buffers',
    },
    {
      '<leader>fww',
      function()
        Snacks.picker.grep()
      end,
      desc = 'find word',
    },
    {
      '<leader>fcw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'find selected word',
      mode = { 'n', 'x' },
    },
    {
      'fcd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'find current Definition',
    },
    {
      'fcD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'find current declaration',
    },
    {
      'fcr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'find current references',
    },
    {
      'fci',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'find current implimentation',
    },
    {
      'fct',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'find current type',
    },
  },
}
