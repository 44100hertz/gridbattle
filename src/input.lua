-- I originally wanted to have inputs be rebindable, etc, and I have a
-- decent amount of assets and code to support that right
-- now. However, I now think that's jumping the gun, and will rely on
-- fixed binds during the development process.

-- keys should be friendly names
-- values are valid scancodes
local keyBind = {
   a="x", b="z",
   du="up", dd="down",
   dl="left", dr="right"
}
-- initialize all button states
local buttons = {}
for k,_ in pairs(keyBind) do buttons[k] = 0 end

local joyBind = {
   a="b", b="a",
   l="leftshoulder", r="rightshoulder",
   st="start", sel="back",
   du="dpup", dd="dpdown",
   dl="dpleft", dr="dpright",
}

local joy = love.joystick.getJoysticks()[1] -- hard code
love.joystick.loadGamepadMappings("res/gamecontrollerdb.txt")

-- Currently only tested on iBuffalo snes controller
local joy2hat = function (lr, ud, check)
   local dz = 0.5 --deadzone
   if check == "dl" and lr < -dz then return true end
   if check == "dr" and lr >  dz then return true end
   if check == "du" and ud < -dz then return true end
   if check == "dd" and ud >  dz then return true end
end

local input = {
   update = function ()
      local lr, ud
      if joy then
         lr = joy:getAxis(1)
         ud = joy:getAxis(2)
      end

      for k,v in pairs(keyBind) do
         if love.keyboard.isScancodeDown(v) or -- Keyboard
            joy and joy:isGamepadDown(joyBind[k]) or -- dpad
            joy and joy2hat(lr, ud, k) -- joystick
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

   -- This is used for things like menu transitions.
   -- It forces the user to lift any buttons they intend to use.
   stale = function ()
      for k,_ in pairs(keyBind) do buttons[k] = -1 end
   end,

   rebind = function (binds)
      keyBind = binds
   end
}

-- Bind "input.a", for example, to the value of a, but return it; do
-- not allow modification. This mostly just serves a syntactic
-- purpose.
input.mt = {
   __index = function (_, key)
      return buttons[key]
   end
}

setmetatable(input, input.mt)

return input
