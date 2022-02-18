resource_type 'gametype' { name = 'Crazy Deluxo' }



client_scripts {
'main.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

game 'gta5'
fx_version 'cerulean'


dependencies {
	'spawnmanager',
    'mapmanager'
}