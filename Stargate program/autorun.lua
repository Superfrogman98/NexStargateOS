local fs = require("filesystem")
local proxy = ...
fs.mount(proxy,"/stargate")
os.execute("/stargate/NexStargateOS.lua")