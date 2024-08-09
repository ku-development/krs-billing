fx_version 'cerulean'
game 'gta5'

author 'KurdYion / (discord: kurdyion6)'
description 'A custom billing system for FiveM QBCore'
version '1.0.0'

client_scripts {
    'Client/Client.lua'
}

server_scripts {
    'Server/Server.lua',
    'Shared/Sv_Config.lua',
    '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
    'Shared/Sh_Config.lua',
}

ui_page 'Nui/index.html'

files {
    'Nui/index.html',
    'Nui/css/styles.css',
    'Nui/css/menu.css',
    'Nui/js/app.js'
}