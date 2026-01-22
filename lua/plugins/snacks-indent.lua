return {
  'folke/snacks.nvim',
  opts = {
    indent = {
      indent = {
        enabled = false, -- disable regular indent guides
      },
      scope = {
        cursor = false, -- use the line instead of cursor column (innermost scope on current line)
      },
    },
  },
}
