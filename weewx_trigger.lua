return {
  on = {
    timer = { 'every 1 minutes' },
    httpResponses = { 'gotWeewxData' }
  },
  logging = {
   level = domoticz.LOG_INFO,
   marker = 'weewx_trigger.lua'
  },
  execute = function(domoticz, item)
    if (item.isTimer) then
       domoticz.openURL({
          url = 'https://rpi3/weewx/current.json',
          method = 'GET',
          callback = 'gotWeewxData' --'../lua_parsers/weewx.lua'
       })
       --domoticz.log('Called weewx.lua')
    elseif (item.isHTTPResponse) then
      package.path = package.path .. ';' .. 'home/pi/domoticz/scripts/lua/weewx.lua;'
      local my1 = require ("weewx")
      if (item.ok) then -- statusCode == 2xx
        -- uptime value won't change until current.json is updated by weewx
        local var = item.json.uptime
        domoticz.log('weewx uptime: '..var)
        local weewxUptime = domoticz.variables('weewxUptime').value
        if weewxUptime ~= var then
          domoticz.variables('weewxUptime').set(var)
          domoticz.log('weewxUptime var = '..weewxUptime)
          updateWeewx(item.json)
        end
        --domoticz.devices('myCurrentUsage').updateEnergy(current)
      end
    end
  end
}