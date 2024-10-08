return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'princejoogie/dir-telescope.nvim' },
    { 'PhilippFeO/telescope-filelinks.nvim', ft = 'markdown' },
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local actions = require 'telescope.actions'
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        mappings = {
          i = {
            -- ['<esc>'] = actions.close,
            ['<Tab>'] = actions.move_selection_worse,

            ['<S-Tab>'] = actions.move_selection_better,

            ['<C-n>'] = false,

            ['<C-p>'] = false,

            ['<Down>'] = false,

            ['<Up>'] = false,
          },
        },
      },
      -- pickers = {}
      extensions = {
        {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'dir')
    pcall(require('telescope').load_extension 'filelinks')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
    vim.keymap.set('n', '<leader>fcw', builtin.grep_string, { desc = '[F]ind [C]urrent [W]ord' })
    vim.keymap.set('n', '<leader>fcd', builtin.lsp_definitions, { desc = '[F]ind [C]urrent [D]efinition' })
    vim.keymap.set('n', '<leader>fcr', builtin.lsp_references, { desc = '[F]ind [C]urrent [R]eferences' })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind by [W]ord' })
    --vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>bl', builtin.buffers, { desc = '[B]uffer [L]ist' })
    -- vim.keymap.set('n', '<leader>Ss', builtin.spell_suggest, { desc = '[S]pell [s]uggest' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>fb', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[F]ind [B]uffer' })

    vim.keymap.set('n', '<leader>ss', function()
      builtin.spell_suggest(require('telescope.themes').get_cursor { winblend = 10, layout_config = { width = 0.15 } })
    end, { desc = '[S]pell [s]uggest' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    -- vim.keymap.set('n', '<leader>f/', function()
    --   builtin.live_grep {
    --     grep_open_files = true,
    --     prompt_title = 'Live Grep in Open Files',
    --   }
    -- end, { desc = '[F]ind [/] in Open Files' })

    vim.keymap.set('n', '<leader>fif', function()
      builtin.find_files { hidden = true, no_ignore = true }
    end, { desc = '[F]ind [I]gnored [F]iles' })
    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [N]eovim files' })

    vim.keymap.set('n', '<leader>ml', function()
      require('telescope').extensions.filelinks.make_filelink {
        working_dir = vim.fn.getcwd(),
        format_string = '[%s](%s)',
        remove_extension = false,
        prompt_title = 'Markdown Link Finder',
      }
    end, { desc = '[M]arkdown [L]ink' })
  end,
}
