local thread = require "thread"
local event = require "event"
local serialization = require "serialization"
local m = require("component").modem

local cleanup_thread = thread.create(function()
  event.pull("interrupted")
  print("exiting")
end )

function main()

  m.open(123)

  local recv = {}

  function receive(...)
    print("MESSAGE RECEIVED!")
    local packedMsg = {...} --table.pack(...)
    for k, v in pairs(packedMsg) do
      print(k, v)
    end
  end

  event.listen("modem_message", receive)

  local messages = {}
  while true do
    for k, v in pairs(recv) do
      table.insert(messages, v)
    end
    recv = {}
    os.sleep(0.25)
    print(#messages)
    os.sleep(5)
  end
end

local main_thread = thread.create(main)

thread.waitForAny({ cleanup_thread, main_thread })
m.close(123)
os.exit()
