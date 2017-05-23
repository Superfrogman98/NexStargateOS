






--Programmed by: Superfrogman98 
--Date: 2017-3-14
--This version uses code mostly from the sgcraft website
local computer = require("computer")

dofile("/stargate/config.lua")
dofile("/stargate/compat.lua")
dofile("/stargate/addresses.lua")

function pad(s, n)
  if string.len(s) < n then
    s = s .. string.rep(" ", n - string.len(s))
  end
  return s
end

function showMenu()
  setCursor(1, 1)
  for i, na in pairs(addresses) do
    print(string.format("%d %s", i, na[1]))
  end
  print("")
  print("D Disconnect")
  print("O Open Iris")
  print("C Close Iris")
  print("Q Quit")
  print("")
  write("Option? ")
end

--function getIrisState()
--  ok, result = pcall(sg.irisState)
--  return result
--end

function showState()
  locAddr = check(sg.localAddress())
  remAddr = check(sg.remoteAddress())
  state, chevrons, direction = check(sg.stargateState())
  energy = check(sg.energyAvailable())
  iris = check(sg.irisState())
  showAt(stateX, 1, "Local:     " .. locAddr)
  showAt(stateX, 2, "Remote:    " .. remAddr)
  showAt(stateX, 3, "State:     " .. state)
  showAt(stateX, 4, "Energy:    " .. string.format("%d", energy))
  showAt(stateX, 5, "Iris:      " .. iris)
  showAt(stateX, 6, "Engaged:   " .. chevrons)
  showAt(stateX, 7, "Direction: " .. direction)
end

function showAt(x, y, s)
  setCursor(x, y)
  write(pad(s, 50 - x))
end

function showMessage(mess)
  showAt(1, screen_height, mess)
end

function showError(mess)
  showMessage("Error: " .. mess)
end

handlers = {}

function dial(name, addr)
  showMessage(string.format("Dialling %s (%s)", name, addr))
  check(sg.dial(addr))
end

handlers[key_event_name] = function(e)
  c = key_event_char(e)
  if c == "d" then
    check(sg.disconnect())
  elseif c == "o" then
    check(sg.openIris())
  elseif c == "c" then
    check(sg.closeIris())
  elseif c == "q" then
    running = false
  elseif c >= "1" and c <= "9" then
    na = addresses[tonumber(c)]
    if na then
      dial(na[1], na[2])
    end
  end
end

function handlers.sgChevronEngaged(e)
  chevron = e[3]
  symbol = e[4]
  showMessage(string.format("Chevron %s engaged! (%s)", chevron, symbol))
end

function eventLoop()
  while running do
    showState()
    e = {pull_event()}
    name = e[1]
    f = handlers[name]
    if f then
      showMessage("")
      ok, result = pcall(f, e)
      if not ok then
        showError(result)
      end
    end
  end
end

function main()
  term.clear()
  showMenu()
  eventLoop()
  term.clear()
  setCursor(1, 1)
end

function start()
 if computer.uptime() > 6  then
  running = true
  main()
 else
  start()
 end
end

start()