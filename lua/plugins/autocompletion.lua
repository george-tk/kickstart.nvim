-- Autocompletion (nvim-cmp)

return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdLineEnter' }, -- Load on Insert/CmdLine
  dependencies = {
    -- Snippets
    {
      'L3MON4D3/LuaSnip',
      build = (function() -- Build for regex support
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
          end, -- Load snippets
        },
      },
    },
    'saadparwaiz1/cmp_luasnip', -- LuaSnip source

    -- Sources
    'hrsh7th/cmp-nvim-lsp', -- LSP source
    'hrsh7th/cmp-path', -- Path source
    'hrsh7th/cmp-buffer', -- Buffer source
    'hrsh7th/cmp-cmdline', -- Cmdline source
    'octaltree/cmp-look', -- Dictionary source

    -- Icons
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      }, -- Snippet expansion
      completion = { completeopt = 'menu,menuone,noinsert,noselect' }, -- Completion behavior
      mapping = {
        ['<CR>'] = cmp.mapping { -- Accept
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
        ['<Tab>'] = cmp.mapping(function(fallback) -- Next item / Snippet jump forward
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback) -- Prev item / Snippet jump backward
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
        ['<C-f>'] = cmp.mapping.scroll_docs(4), -- Scroll docs down
        ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger
      },
      sources = { -- Global sources
        { name = 'lazydev', group_index = 0 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      formatting = { format = lspkind.cmp_format { mode = 'symbol', menu = {}, maxwidth = 50, ellipsis_char = '...' } }, -- Formatting
    }

    -- Cmdline setup (/)
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = 'buffer' } },
    })

    -- Cmdline setup (:)
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })

    -- Markdown specific setup
    cmp.setup.filetype('markdown', {
      sources = cmp.config.sources { -- Markdown sources
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'look', option = { dict = '/home/gkyriacou/.config/nvim/dict/en.txt' } }, -- Dictionary source (Update path!)
      },
    })
  end,
}
