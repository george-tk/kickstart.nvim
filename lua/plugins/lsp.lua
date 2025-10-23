return {
  ---------------------------------------------------------------------------
  -- Lua typing help for Neovim config/plugins (loads only for Lua files)
  ---------------------------------------------------------------------------
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Main LSP configuration (performance-tuned)
  ---------------------------------------------------------------------------
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' }, -- start when actually editing files
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- LSP status UI (defer to first LSP attach to keep startup snappy)
      { 'j-hui/fidget.nvim', opts = {}, event = 'LspAttach' },

      -- Blink is our completion client; we’ll use its capabilities
      'saghen/blink.cmp',
    },

    config = function()
      -----------------------------------------------------------------------
      -- Diagnostics: reasonable defaults, sorted by severity, rounded float
      -----------------------------------------------------------------------
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diag)
            return diag.message
          end,
        },
      }

      -----------------------------------------------------------------------
      -- Blink capabilities (full completion features)
      -----------------------------------------------------------------------
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -----------------------------------------------------------------------
      -- Large-file guard: return true if file < 1 MiB
      -----------------------------------------------------------------------
      local function small_file(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        if name == '' then
          return true
        end
        local ok, stat = pcall(vim.loop.fs_stat, name)
        return not ok or not stat or stat.size < 1024 * 1024
      end

      -----------------------------------------------------------------------
      -- root_dir helpers (avoid starting servers in $HOME, etc.)
      -----------------------------------------------------------------------
      local util = require 'lspconfig.util'
      local function root_with(patterns, fallback)
        return function(fname)
          return util.root_pattern(unpack(patterns))(fname) or util.find_git_ancestor(fname) or fallback
        end
      end

      -----------------------------------------------------------------------
      -- on_attach: cheap defaults, large-file safeguards, lean highlights
      -----------------------------------------------------------------------
      local function on_attach(client, bufnr)
        -- Large-file: disable expensive features
        if not small_file(bufnr) then
          if client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
          end
          -- If you prefer inlay hints off for big files:
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(bufnr, false)
          end
        end

        -- Helper: client supports method?
        local function supports(method)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- Document highlight (CursorHold only, not in Insert)
        if supports(vim.lsp.protocol.Methods.textDocument_documentHighlight) and small_file(bufnr) then
          local aug = vim.api.nvim_create_augroup('lsp-doc-hl-' .. bufnr, { clear = true })
          -- Increase updatetime a bit to reduce churn if you want:
          -- vim.opt_local.updatetime = 500
          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = bufnr,
            group = aug,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'BufLeave' }, {
            buffer = bufnr,
            group = aug,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            buffer = bufnr,
            group = aug,
            callback = function()
              vim.lsp.buf.clear_references()
              pcall(vim.api.nvim_del_augroup_by_id, aug)
            end,
          })
        end

        -- Optional: toggle inlay hints
        if supports(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          vim.keymap.set('n', '<leader>th', function()
            local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
            vim.lsp.inlay_hint.enable(bufnr, not enabled)
          end, { buffer = bufnr, desc = 'LSP: [T]oggle Inlay [H]ints' })
        end
      end

      -----------------------------------------------------------------------
      -- Servers
      -----------------------------------------------------------------------
      local servers = {
        marksman = {
          root_dir = root_with({ '.marksman.toml', '.git' }, vim.loop.cwd()),
        },

        lua_ls = {
          root_dir = root_with({ '.luarc.json', '.luarc.jsonc', '.git' }, vim.loop.cwd()),
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              -- diagnostics = { disable = { 'missing-fields' } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },

        -- Uncomment to enable TypeScript/JavaScript (tsserver via ts_ls)
        -- ts_ls = {
        --   root_dir = root_with({ 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }, vim.loop.cwd()),
        --   single_file_support = false,
        --   settings = {
        --     completions = { completeFunctionCalls = true }, -- call-site param snippets
        --   },
        --   -- Avoid conflicts with formatters (prettier/conform/biome/etc.)
        --   on_attach = function(client, bufnr)
        --     client.server_capabilities.documentFormattingProvider = false
        --     on_attach(client, bufnr)
        --   end,
        -- },
      }

      -----------------------------------------------------------------------
      -- Ensure tools via Mason (one-time), then set up servers via handlers
      -----------------------------------------------------------------------
      local ensure = vim.tbl_keys(servers)
      vim.list_extend(ensure, { 'stylua' }) -- formatter for Lua

      require('mason-tool-installer').setup { ensure_installed = ensure }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- we install via mason-tool-installer
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            -- Default flags to reduce churn
            server.flags = vim.tbl_deep_extend('force', {
              debounce_text_changes = 200,
            }, server.flags or {})

            -- Default on_attach unless server overrides it (ts_ls above)
            if not server.on_attach then
              server.on_attach = on_attach
            end

            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
