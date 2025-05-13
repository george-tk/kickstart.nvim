return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdLineEnter' },
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-cmdline',
    'octaltree/cmp-look',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'
    -- local cmp_dictionary = require 'cmp_dictionary' -- Not strictly needed to pre-require if using its setup function directly

    require('luasnip.loaders.from_vscode').lazy_load()

    -- Configure cmp-dictionary <<< ADDED SECTION
    -- IMPORTANT: Replace '/usr/share/dict/words' with the actual path to your dictionary file.
    -- Common paths:
    -- Linux: /usr/share/dict/words
    -- macOS: /usr/share/dict/words (usually present)
    -- Windows: You'll need to find or create a dictionary file (e.g., a plain text file with one word per line).

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert,noselect' },
      mapping = {
        ['<CR>'] = cmp.mapping {
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm { select = true },
          c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
      },
      sources = { -- These are your global sources
        {
          name = 'lazydev',
          group_index = 0,
        },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      formatting = { format = lspkind.cmp_format { mode = 'symbol', menu = {}, maxwidth = 20, ellipsis_char = '...' } },
    }

    -- Command line settings (unchanged from your original)
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })

    -- Filetype specific setup for Markdown <<< ADDED SECTION
    cmp.setup.filetype('markdown', {
      sources = cmp.config.sources {
        -- Include your global sources if desired, or define a specific set for markdown
        { name = 'lazydev', group_index = 0 },
        { name = 'nvim_lsp' }, -- May or may not be useful in markdown depending on your LSP
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'look', option = { dict = '/home/gkyriacou/.config/nvim/dict/en.txt' } },
      },
    })
  end,
}
