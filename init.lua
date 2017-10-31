if (file.exists('wifi.cfg')) then
  tmr.alarm(1, 2000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
      print("IP unavailable, Waiting...")
    else
      tmr.stop(1)
      m = mqtt.Client('node1', 120, 'node1', '321321321')
      m:on('connect', function (client) print ('connected') end)

      m:connect('192.168.1.99', 1883, 0, function(client)
        print('connected')
        -- Calling subscribe/publish only makes sense once the connection
        -- was successfully established. You can do that either here in the
        -- 'connect' callback or you need to otherwise make sure the
        -- connection was established (e.g. tracking connection status or in
        -- m:on('connect', function)).

        -- subscribe topic with qos = 0
        client:subscribe('/topic', 0, function(client) print('subscribe success') end)
        -- publish a message with data = hello, QoS = 0, retain = 0
        client:publish('/topic', 'hello', 0, 0, function(client) print('sent') end)
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
