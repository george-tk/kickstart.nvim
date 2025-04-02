return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '<leader>ed',
      '<cmd>Neotree float reveal toggle<CR> ',
      desc = '[d]irectory',
    },

    {
      '<leader>ef',
      function()
        require('neo-tree.command').execute { toggle = true, source = 'document_symbols' }
      end,
      desc = '[f]ile',
    },
  },
  opts = {
    sources = { 'filesystem', 'document_symbols' },
    filesystem = {

      filtered_items = {
        visible = true,
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      window = {
        position = 'right',
        mappings = {
          -- ['h'] = 'close_node',
          --['l'] = 'open',
          ['l'] = 'open',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
        },
      },
    },
    document_symbols = {
      window = {
        position = 'float',
        mappings = {
          ['l'] = 'toggle_node',
        },
      },
    },
    event_handlers = {
      {
        event = 'file_open_requested',
        handler = function()
          -- auto close
          -- vim.cmd("Neotree close")
          -- OR
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
