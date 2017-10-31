wifi.setmode(wifi.STATION)
sta_cfg = {}
sta_cfg.ssid = '4m2g'
sta_cfg.pwd = '321321321'
sta_cfg.auto = true
sta_cfg.save = true
--wifi.sta.config(sta_cfg)
wifi.sta.autoconnect(1)
m = mqtt.Client('node1', 120, 'node1', '321321321')
m:on('connect', function (client) print ('connected') end)

m:connect("192.168.1.99", 1883, 0, function(client)
  print("connected")
  -- Calling subscribe/publish only makes sense once the connection
  -- was successfully established. You can do that either here in the
  -- 'connect' callback or you need to otherwise make sure the
  -- connection was established (e.g. tracking connection status or in
  -- m:on("connect", function)).

  -- subscribe topic with qos = 0
  client:subscribe("/topic", 0, function(client) print("subscribe success") end)
  -- publish a message with data = hello, QoS = 0, retain = 0
  client:publish("/topic", "hello", 0, 0, function(client) print("sent") end)
end,
function(client, reason)
  print("failed reason: " .. reason)
end)
