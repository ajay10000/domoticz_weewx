# domoticz_weewx
 Domoticz LUA parser for weewx weather logging
 
## Set up in Domoticz
Install weewx.lua to domoticz -> scripts -> lua_parsers folder
i.e. /home/pi/domoticz/scripts/lua_parsers

Create Domoticz hardware HTTP/HTTPS poller with URL for current.json
i.e. http://rpi3/weewx/current.json
Method: GET
Command: weewx.lua
Refresh: 60 (60s intervals)

