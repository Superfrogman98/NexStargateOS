--Programmed by: Superfrogman98
--Date: 2017-3-14

term = require("term")
event = require("event")
gpu = component.getPrimary("gpu")

--   Utility for calling a function and printing the
--   error message if it throws an exception

function try(func, ...)
  ok, result = pcall(func, ...)
  if not ok then
    print("Error: " .. result)
  end
end

--  Utility for checking the result of a function call and
--  throwing an exception if it returned an error indication

function check(...)
    values = {...}
    if values[1] == nil then
        error(values[2], 0)
    end
    return ...
end

--   Terminal API compatibility functions

screen_width, screen_height = gpu.getResolution()

function setCursor(col, row)
  term.setCursor(col, row)
end

function write(s)
  term.write(s)
end

--   Event API compatibility functions

function pull_event()
  return event.pull()
end

key_event_name = "key_down"

function key_event_char(e)
  return string.char(e[3])
end

--   Error message compatibility functions

function extractErrorMessage(mess)
    return mess
end


