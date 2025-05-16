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
      dashboard.button('f', '󰱼 > File', function()
        Snacks.picker.files()
      end),
      dashboard.button('w', ' > Word', function()
        Snacks.picker.grep_word()
      end),
      dashboard.button('r', ' > Restore ', function()
        require('persistence').load { last = true }
      end),
      dashboard.button('l', ' > Load', function()
        require('persistence').select()
      end),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
  end,
}
