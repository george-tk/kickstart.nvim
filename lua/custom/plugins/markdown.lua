return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = {
      'markdown',
      'text',
      'tex',
      'plaintex',
      'norg',
    },
    ---@module 'render-markdown'
    config = function()
      require('render-markdown').setup {
        anti_conceal = { enabled = false },
        sign = { enabled = false },
      }
    end,
    --dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
    'jakewvincent/mkdnflow.nvim',
    ft = { 'markdown', 'text', 'tex', 'plaintex', 'norg' },
    opts = {
      mappings = {
        MkdnEnter = { { 'n', 'v', 'i' }, '<CR>', { buffer = true } },
        MkdnTab = false,
        MkdnSTab = false,
        MkdnNextLink = { 'n', '<Tab>', { buffer = true } },
        MkdnPrevLink = { 'n', '<S-Tab>', { buffer = true } },
        MkdnNextHeading = { 'n', ']]' },
        MkdnPrevHeading = { 'n', '[[' },
        MkdnGoBack = { 'n', '<BS>', { buffer = true } },
        MkdnGoForward = { 'n', '<Del>', { buffer = true } },
        MkdnCreateLink = false, -- see MkdnEnter
        MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<leader>mp', { buffer = true } }, -- see MkdnEnter
        MkdnFollowLink = false, -- see MkdnEnter
        MkdnDestroyLink = { 'n', '<leader>md', { buffer = true } },
        MkdnTagSpan = false,
        MkdnMoveSource = { 'n', '<leader>mm', { buffer = true } },
        MkdnYankAnchorLink = false,
        MkdnYankFileAnchorLink = false,
        MkdnIncreaseHeading = false,
        MkdnDecreaseHeading = false,
        MkdnToggleToDo = { { 'n', 'v' }, '<leader>mt', { buffer = true } },
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = false,
        MkdnNewListItemAboveInsert = false,
        MkdnExtendList = false,
        MkdnUpdateNumbering = { 'n', '<leader>mu', { buffer = true } },
        MkdnTableNextCell = { 'i', '<Tab>', { buffer = true } },
        MkdnTablePrevCell = { 'i', '<S-Tab>', { buffer = true } },
        MkdnTableNextRow = false,
        MkdnTablePrevRow = { 'i', '<M-CR>', { buffer = true } },
        MkdnTableNewRowBelow = { 'n', '<leader>mr', { buffer = true } },
        MkdnTableNewRowAbove = { 'n', '<leader>mR', { buffer = true } },
        MkdnTableNewColAfter = { 'n', '<leader>mc', { buffer = true } },
        MkdnTableNewColBefore = { 'n', '<leader>mC', { buffer = true } },
        MkdnFoldSection = { 'n', '<leader>mf', { buffer = true } },
        MkdnUnfoldSection = { 'n', '<leader>mF', { buffer = true } },
      },
    },
  },
}
