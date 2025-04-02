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
    init = function()
      local color1_bg = '#5b4996'
      local color2_bg = '#21925b'
      local color3_bg = '#027d95'
      local color4_bg = '#585c89'
      local color5_bg = '#0f857c'
      local color6_bg = '#396592'
      local color_fg = '#ffffff'

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
      render_modes = true,
      bullet = {
        enabled = true,
      },
      heading = {
        sign = false,
        --icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        backgrounds = {
          'Headline1Bg',
          'Headline2Bg',
          'Headline3Bg',
          'Headline4Bg',
          'Headline5Bg',
          'Headline6Bg',
        },
        foregrounds = {
          'Headline1Fg',
          'Headline2Fg',
          'Headline3Fg',
          'Headline4Fg',
          'Headline5Fg',
          'Headline6Fg',
        },
      },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
    'jakewvincent/mkdnflow.nvim',
    ft = { 'markdown', 'text', 'tex', 'plaintex', 'norg' },
    opts = {
      modules = {
        bib = true,
        buffers = false,
        conceal = true,
        cursor = true,
        folds = false,
        foldtext = false,
        links = true,
        lists = true,
        maps = true,
        paths = true,
        tables = true,
        yaml = false,
        cmp = false,
      },
      mappings = {
        MkdnEnter = { { 'n', 'v', 'i' }, '<CR>', { buffer = true } },
        MkdnNextLink = { 'n', '<Tab>', { buffer = true } },
        MkdnPrevLink = { 'n', '<S-Tab>', { buffer = true } },
        MkdnGoBack = false,
        MkdnGoForward = false,
        MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<leader>mp', { buffer = true, desc = '[M]arkdown [P]aste link' } }, -- see MkdnEnter
        MkdnDestroyLink = { 'n', '<leader>md', { buffer = true, desc = '[M]arkdown [D]elete link' } },
        MkdnTagSpan = false,
        MkdnMoveSource = { 'n', '<leader>mm', { buffer = true, desc = '[M]arkdown [Move] link' } },
        MkdnYankAnchorLink = false,
        MkdnYankFileAnchorLink = false,
        MkdnIncreaseHeading = false,
        MkdnDecreaseHeading = false,
        MkdnToggleToDo = { { 'n', 'v' }, '<leader>mt', { buffer = true, desc = '[M]arkdown [T]odo' } },
        MkdnNewListItemBelowInsert = false,
        MkdnNewListItemAboveInsert = false,
        MkdnUpdateNumbering = { 'n', '<leader>mu', { buffer = true, desc = '[M]arkdown [U]pdate numbering' } },
        MkdnTableNextCell = { 'i', '<Tab>', { buffer = true } },
        MkdnTablePrevCell = { 'i', '<S-Tab>', { buffer = true } },
        MkdnTableNewRowBelow = { 'n', '<leader>mr', { buffer = true, desc = '[M]arkdown [r]ow below' } },
        MkdnTableNewRowAbove = { 'n', '<leader>mR', { buffer = true, desc = '[M]arkdown [R]ow above' } },
        MkdnTableNewColAfter = { 'n', '<leader>mc', { buffer = true, desc = '[M]arkdown [c]olumn after' } },
        MkdnTableNewColBefore = { 'n', '<leader>mC', { buffer = true, desc = '[M]arkdown [C]olumn befor' } },
        MkdnFoldSection = false,
        MkdnUnfoldSection = false,
      },
      links = {
        transform_explicit = function(text)
          text = text:gsub("%S+",function(w)
            return w:sub(1,1):upper() .. w:sub(2):lower() 
            end)
          text = text:gsub(' ', '')
          local folder = 'unorganised/'
          text = folder .. os.date '%d-%m-%Y_' .. text
          return text
        end,
      },
      new_file_template = {
        use_template = true,
        placeholders = {
          before = {
            title = 'link_title',
            date = 'os_date',
          },
          after = {
            filename = function()
                local text = vim.api.nvim_buf_get_name(0)
                local pattern = "_([^_]+)%.md$"
                local name = text:match(pattern)

                local result = ""
                for i = 1, #name do
                  local char = name:sub(i,i)
                  if i>1 and char:match("%u") then
                    result = result .. " " .. char
                  else
                    result = result .. char
                  end
                end
                return result
            end
          }
        },
        template = '# {{ filename }}',
      },
    },
  },
}
