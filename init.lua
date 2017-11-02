if (file.exists('wifi.cfg')) then
  tmr.alarm(6, 3000, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() == nil then
      print('ip unavailable, waiting...')
    else
      tmr.stop(6)
      local mqconn = 0
      m = mqtt.Client('node1', 120, 'node1', '321321321')
      m:on('connect', function (client) print ('connected') end)
      m:on('offline', function (client)
        if (mqconn == 1) then
         mqconn = 0
         dofile('init.lua')
        end
      end)
      m:on('message', function (client, topic, message)
        print(client, topic, messages)
        pin, mode = message:match('([^,]+),([^,]+)')
        gpio.mode(pin, gpio.OUTPUT)
        gpio.write(pin, mode)
        -- client:publish('/node1', pin .. ',' .. mode, 0, 0, function(client) print('sent') end)
      end)
      m:connect('192.168.1.99', 1883, 0, function(client)
        print('connected')
        mqconn = 1
        client:subscribe('/node1', 0, function(client) print('subscribe success') end)
      end,
      function(client, reason)
        print('failed reason: ' .. reason)
        dofile('init.lua')
      end)
    end
  end)
else
  wifi.setmode(wifi.STATION)
  wifi.sta.config({ ssid = '4m2g', pwd = '321321321', auto = true, save = true })
  if file.open('wifi.cfg', 'w+') then
    file.write('okay')
    file.close()
  end
end
