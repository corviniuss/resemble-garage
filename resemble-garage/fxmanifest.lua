fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_script {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

escrow_ignore {
    "config.lua",
    "locales/*.lua",
  }

dependencies {
    'ox_lib',
}