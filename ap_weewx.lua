--lua script to parse json data to http/https poller virtual hardware
--AP v2.0
--Sample json data from i.e. http://rpi3/weewx/current.json
--[[
 "stats": {
    "current": {
      "outTemp":"10.3",
      "heatIndex":"10.3",
      "pressure":"969.7"
      "barometer":"1017.3",
      "dewpoint":"8.6",
      "humidity":"89",
      "insideTemp":"16.1",      
      "insideHumidity":"65",
      "windSpeed":"0",
      "windDir":"   N/A",
      "windDirText":"N/A",
      "windchill":"10.3",
      "windGust":"0",
      "windGustDir":"   N/A",
      "rain":"0.0",
      "rainRate":"0.0",
      "rxCheckPercent":"100",
      "outTempBatteryStatus":"0.000000"
      }
  }
 ]]
local outTHB_id = 45
local wind_id = 46
local inTHB_id = 47
local rain_id = 79
local radiation_id = 188
--local rxCheckPercent_id = 
--local outTempBatteryStatus_id = 

-- Retrieve the content
s = request['content'];

-- Note the hierarchy .stats.current for the json
local outTemp = domoticz_applyJsonPath(s,'.stats.current.outTemp')
local windchill = domoticz_applyJsonPath(s,'.stats.current.windchill')
local humidity = domoticz_applyJsonPath(s,'.stats.current.humidity')
local insideHumidity = domoticz_applyJsonPath(s,'.stats.current.insideHumidity') 
local pressure = domoticz_applyJsonPath(s,'.stats.current.pressure')
local barometer = domoticz_applyJsonPath(s,'.stats.current.barometer')
local windSpeed = domoticz_applyJsonPath(s,'.stats.current.windSpeed')
local windDir = domoticz_applyJsonPath(s,'.stats.current.windDir')
local windDirText = domoticz_applyJsonPath(s,'.stats.current.windDirText')
local windGust = domoticz_applyJsonPath(s,'.stats.current.windGust')
local rain = domoticz_applyJsonPath(s,'.stats.current.rain') * 100
local rainRate = domoticz_applyJsonPath(s,'.stats.current.rainRate')
local radiation = domoticz_applyJsonPath(s,'.stats.current.radiation')
local insideTemp = domoticz_applyJsonPath(s,'.stats.current.insideTemp')
local rxCheckPercent = domoticz_applyJsonPath(s,'.stats.current.rxCheckPercent')
local outTempBatteryStatus = domoticz_applyJsonPath(s,'.stats.current.outTempBatteryStatus')
local forecast = 0
 
-- WS-1080 Convert signal strength from 1-100 to 0-12
if rxCheckPercent == "100" then
  rxCheckPercent = "12"
else
  rxCheckPercent = "0"
end
-- WS-1080 Convert battery level from 0 (OK) or 1 (low battery) to 1 or 100
if outTempBatteryStatus == "0" then
  outTempBatteryStatus = "100"
else
  outTempBatteryStatus = "1"
end

--Check the current value/s in Domoticz
s_1 = tostring(otherdevices['Ferndale - THB - weewx'])
print('Old outTemp: '..s_1) --debug
n_1 = tostring(outTemp .. ";" .. humidity .. ";" .. forecast .. ";" .. barometer .. ";" .. forecast)
print('New outTemp: '..n_1) --debug
if not s_1 == n_1 then
  domoticz_updateDevice(outTHB_id,'',outTemp .. ";" .. humidity .. ";" .. forecast .. ";" .. barometer .. ";" .. forecast,rxCheckPercent,outTempBatteryStatus)
end
s_1 = tostring(otherdevices['Ferndale - Wind - weewx'])
print('Old Wind: '..s_1) --debug
n_1 = tostring(windDir .. ";" .. windDirText .. ";" .. windSpeed .. ";" .. windGust .. ";" .. outTemp .. ";" .. windchill)
print('New Wind: '..n_1) --debug
if not s_1 == n_1 then
  domoticz_updateDevice(wind_id,'',windDir .. ";" .. windDirText .. ";" .. windSpeed .. ";" .. windGust .. ";" .. outTemp .. ";" .. windchill)
end
s_1 = tostring(otherdevices['Ferndale - Rain - weewx'])
print('Old Rain: '..s_1) --debug
n_1 = tostring(outTemp .. ";" .. rain .. ";" .. rainRate)
print('New Rain: '..n_1) --debug
if not s_1 == n_1 then
  domoticz_updateDevice(rain_id,'',rain .. ";" .. rainRate)
end
--WH3081 only
s_1 = tostring(otherdevices['Ferndale - Radiation - weewx'])
print('Old Radiation: '..s_1) --debug
n_1 = tostring(outTemp .. ";" .. radiation .. ";" .. radiation)
print('New Radiation: '..n_1) --debug
if not s_1 == n_1 then
  domoticz_updateDevice(radiation_id,'',radiation .. ";" .. radiation)
end

s_1 = tostring(otherdevices['Ferndale - shed THB - weewx'])
print('Old outTemp: '..s_1) --debug
n_1 = tostring(insideTemp .. ";" .. insideHumidity .. ";" .. forecast .. ";" .. pressure .. ";" .. forecast)
print('New outTemp: '..n_1) --debug
if not s_1 == n_1 then
  domoticz_updateDevice(inTHB_id,'',insideTemp .. ";" .. insideHumidity .. ";" .. forecast .. ";" .. pressure .. ";" .. forecast)
end
