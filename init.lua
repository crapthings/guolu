if (file.exists('wifi.cfg')) then
  tmr.alarm(1, 3000, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() == nil then
      print("IP unavailable, Waiting...")
    else
      tmr.stop(1)
      m = mqtt.Client('node1', 120, 'node1', '321321321')
      m:on('connect', function (client) print ('connected') end)
      m:on('message', function (client, topic, message)
        print(client, topic, message, gpio.LOW, gpio.HIGH)
        pin, mode = message:match("([^,]+),([^,]+)")
        gpio.mode(pin, gpio.OUTPUT)
        gpio.write(pin, mode)
      end)
      m:connect('192.168.1.99', 1883, 0, function(client)
        print('connected')
        client:subscribe('/topic', 0, function(client) print('subscribe success') end)
        -- client:publish('/topic', 'hello', 0, 0, function(client) print('sent') end)
      end,
      function(client, reason)
        print('failed reason: ' .. reason)
      end)
    end
  end)
else
  local cfg = { ssid = '4m2g', pwd = '321321321', auto = true, save = true }
  wifi.setmode(wifi.STATION)
  wifi.sta.config(cfg)

  if file.open('wifi.cfg', 'a+') then
    file.write('okay')
    file.close()
  end
end
