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
    local packedMsg = {...}
    local request = serialization.unserialize(packedMsg[6])
    if (request == nil) then
      print("nil request")
      return
    elseif (request["processor"] == nil) or ( request["recipe"] == nil) then
      print("Error:")
      if (request["processor"] == nil) then
        print("Processor not specified")
      end
      if (request["recipe"] == nil) then
        print("Recipe not specified")
      end
      return
    else
      print("Request valid")
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
