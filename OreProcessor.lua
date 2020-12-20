local component = require("component")
local filesystem = require("filesystem")
local shell = require("shell")
local serialization = require("serialization")
local sides = require("sides")

local inputAddr = "27088060-5035-44ce-a81d-9af965ad4343"
local inputProxy = component.proxy(inputAddr)

local outputAddr = "dddb8551-aac4-4fcf-a229-0ca69b9210a6"
local outputProxy = component.proxy(outputAddr)

local processTbl
if filesystem.exists(shell.resolve('text.txt')) then
  local file = io.open('text.txt')
  local contents = ""
  for line in file:lines() do
    contents = contents .. line
  end
  print(contents)
  processTbl = serialization.unserialize(contents)
else
  print("Process file not found, exiting")
  return
end

print(processTbl)

local bContinue = true
local index = 1

while bContinue do
  if index >= inputProxy.getInventorySize(sides.south) then
    bContinue = false
  else
    index = index + 1
    local stack = inputProxy.getStackInSlot(sides.south, index)
    print(stack.label)
  end
end

local file = io.open('text.txt')
for line in file:lines() do
  print(line)
end
