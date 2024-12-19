return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set header
    dashboard.section.header.val = {
      '===================================',
      '========-:          :==============',
      '=====:                  :==========',
      '===:                      :========',
      '====-:                      =======',
      '==============-:..           :=====',
      '==========+*=======================',
      '========    +#%#%%=================',
      '========  -.##@%=*#================',
      '=====-:..%* .:==...@===============',
      '====     .  -@=.   :@@=============',
      '===.      :  :- :#@@@#@+===========',
      '===         %@@@%#@@: :============',
      '==-               .=#. :+==========',
      '==-               :-*@+..:=========',
      '===         .     .=*@==#+%@=======',
      '===          :-*+*##%%@+*@@%@@%====',
      '==-          ==**#%%%%@@@@**#*@@@*=',
      '===:        :-=***#*%%%%@%+-:-#@@@=',
      '====        -====*###%%%%%#-.-@@@%=',
      '====:      .=+==+*++*%%%%%%%#@@@@+=',
      '=====      =+*+=+*==++=****#@@@@+==',
      '=====      =***++*==++==::%@@@@@===',
      '====      :*****+++====-=@@@@@@*===',
      '===.      :+#*****=-===*@@@@@*=====',
      '==-   :   -+*****+-:=*%=%==========',
      '==:   =   =+#**===+%%@@..==========',
      '==   -=   =:-:*=#*#%@@=+ :*========',
      '=.   =-   -==****#%@@+===::========',
      '=         *%%%@@%#%*=====*=========',
      '===================================',
    }
    dashboard.section.buttons.val = {
      dashboard.button('f', '󰱼 > File', '<cmd>Telescope find_files<CR>'),
      dashboard.button('w', ' > Word', '<cmd>Telescope live_grep<CR>'),
      dashboard.button('r', ' > Restore ', function() require("persistence").load({last = true}) end),
      dashboard.button('l', ' > Load', function() require("persistence").select() end),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
  end,
}
