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
    init  = function()
      local color1_bg = "#5b4996"
      local color2_bg = "#21925b"
      local color3_bg = "#027d95"
      local color4_bg = "#585c89"
      local color5_bg = "#0f857c"
      local color6_bg = "#396592"
      local color_fg = "#0D1116"

      -- Heading colors (when not hovered over), extends through the entire line
      vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
      vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
      vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
      vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
      vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
      vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))
      
      -- Highlight for the heading and sign icons (symbol on the left)
      -- I have the sign disabled for now, so this makes no effect
      vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
      vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
      vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
      vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
      vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
      vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
    end,
    opts = {
      anti_conceal = { enabled = false },
      sign = { enabled = false },
      bullet = {
        enabled = true,
      },
      heading = {
        sign = false,
        --icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        backgrounds = {
          "Headline1Bg",
          "Headline2Bg",
          "Headline3Bg",
          "Headline4Bg",
          "Headline5Bg",
          "Headline6Bg",
        },
        foregrounds = {
          "Headline1Fg",
          "Headline2Fg",
          "Headline3Fg",
          "Headline4Fg",
          "Headline5Fg",
          "Headline6Fg",
        },
      },
    },
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
        MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<leader>mp', { buffer = true, desc = '[M]arkdown [P]aste link' } }, -- see MkdnEnter
        MkdnFollowLink = false, -- see MkdnEnter
        MkdnDestroyLink = { 'n', '<leader>md', { buffer = true, desc = '[M]arkdown [D]elete link' } },
        MkdnTagSpan = false,
        MkdnMoveSource = { 'n', '<leader>mm', { buffer = true, desc = '[M]arkdown [Move] link' } },
        MkdnYankAnchorLink = false,
        MkdnYankFileAnchorLink = false,
        MkdnIncreaseHeading = false,
        MkdnDecreaseHeading = false,
        MkdnToggleToDo = { { 'n', 'v' }, '<leader>mt', { buffer = true, desc = '[M]arkdown [T]odo' } },
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = false,
        MkdnNewListItemAboveInsert = false,
        MkdnExtendList = false,
        MkdnUpdateNumbering = { 'n', '<leader>mu', { buffer = true, desc = '[M]arkdown [U]pdate numbering' } },
        MkdnTableNextCell = { 'i', '<Tab>', { buffer = true } },
        MkdnTablePrevCell = { 'i', '<S-Tab>', { buffer = true } },
        MkdnTableNextRow = false,
        MkdnTablePrevRow = { 'i', '<M-CR>', { buffer = true } },
        MkdnTableNewRowBelow = { 'n', '<leader>mr', { buffer = true, desc = '[M]arkdown [r]ow below' } },
        MkdnTableNewRowAbove = { 'n', '<leader>mR', { buffer = true, desc = '[M]arkdown [R]ow above' } },
        MkdnTableNewColAfter = { 'n', '<leader>mc', { buffer = true, desc = '[M]arkdown [c]olumn after' } },
        MkdnTableNewColBefore = { 'n', '<leader>mC', { buffer = true, desc = '[M]arkdown [C]olumn befor' } },
        MkdnFoldSection = false, --{ 'n', '<leader>mf', { buffer = true } },
        MkdnUnfoldSection = false, --{ 'n', '<leader>mF', { buffer = true } },
      },
    },
  },
}
