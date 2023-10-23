fx_version 'cerulean'
game 'gta'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


description 'Server security script'
author 'Jack Oneill and Pingouin'

version '1.2.0'

server_script {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/security.lua'
    -- 'server/anticheat.lua'
}

client_scripts {
    'client/client.lua'
}

escrow_ignore {
    'config.lua',
    'client/client.lua',
    '*.txt',
    '*.sql'
}


lua54 'yes'
