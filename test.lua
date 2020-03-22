return {
  on = {
    devices = {
       'HS110 Plugin - switch'
    }
  },
  execute = function(domoticz, switch)
    if (switch.state == 'On') then
       domoticz.log('Hey! I am on!')
    else
       domoticz.log('Hey! I am off!')
    end
  end
}