return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 0,
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      mappings = false,
      -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
      -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },
    icons = {group = '',mappings=false},
    -- Document existing key chains
    spec = {
      { '<leader>b', group = '[b]uffer' },
      { '<leader>d', group = '[d]ebug' },
      { '<leader>r', group = '[r]ename' },
      { '<leader>f', group = '[f]ind' },
      { '<leader>w', group = '[w]orkspace' },
      { '<leader>t', group = '[t]erminal' },
      { '<leader>g', group = '[g]it', mode = { 'n', 'v' } },
      { '<leader>e', group = '[e]xplore', mode = { 'n', 'v' } },
      { '<leader>z', group = '[z]en mode', mode = { 'n', 'v' } },
      { '<leader>m', group = '[m]arkdown' },
      { '<leader>s', group = '[s]pelling' },
      { '<leader>l', group = '[l]sp' },
      { '<leader>fw', group = '[w]ord' },
      { '<leader>fc', group = '[C]urrent' },
      -- Renaming markdown commands
      { '<leader>mt', desc = '[t]odo list' },
      { '<leader>mp', desc = '[p]aste link' },
      { '<leader>md', desc = '[d]elete link' },
      { '<leader>mm', desc = '[m]ove link' },
      { '<leader>mu', desc = '[u]pdate numbering' },
      { '<leader>mr', desc = 'create [r]ow below' },
      { '<leader>mR', desc = 'create [R]ow above' },
      { '<leader>mc', desc = 'create [c]olumn after' },
      { '<leader>mC', desc = 'create [C]olumn befor' },

    },
  },
}
