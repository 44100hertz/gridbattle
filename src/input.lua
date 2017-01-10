-- keys should be "friendly" names
-- values must be valid scancodes
local binds = require "res/binds"
local keyBind = binds[1]

local keyBind = {
   a="x", b="z",
   du="up", dd="down",
   dl="left", dr="right"
}


local joyBind = {
   a="b", b="a",
   l="leftshoulder", r="rightshoulder",
   st="start", sel="back",
   du="dpup", dd="dpdown",
   dl="dpleft", dr="dpright",
}

local joy = love.joystick.getJoysticks()[1]
love.joystick.loadGamepadMappings("gamecontrollerdb.txt")

local joy2hat = function (lr, ud, check)
   local dz = 0.5 --deadzone
   if check == "dl" and lr < -dz then return true end
   if check == "dr" and lr >  dz then return true end
   if check == "du" and ud < -dz then return true end
   if check == "dd" and ud >  dz then return true end
end

-- populate an array of buttons
local buttons = {}
for k,_ in pairs(keyBind) do buttons[k] = 0 end

local input = {
   bindindex = 1,
   update = function ()
      local lr, ud
      if joy then
         lr = joy:getAxis(1)
         ud = joy:getAxis(2)
      end

      for k,v in pairs(keyBind) do
         if love.keyboard.isScancodeDown(v) or
            joy and joy:isGamepadDown(joyBind[k]) or
            joy and joy2hat(lr, ud, k)
         then
            if buttons[k] > -1 then
               buttons[k] = buttons[k]+1
            end
         else
            -- reset to 0 when released
            buttons[k] = 0
         end
      end
   end,

   stale = function ()
      for k,_ in pairs(keyBind) do buttons[k] = -1 end
   end,

   rebind = function (binds)
      keyBind = binds
   end
}

-- Bind "input.a", for example, to the value of a
-- but return it; do not allow modification
input.mt = {
   __index = function (_, key)
      return buttons[key]
   end
}

setmetatable(input, input.mt)

return input
