-- I originally wanted to have inputs be rebindable, etc, and I have a
-- decent amount of assets and code to support that right
-- now. However, I now think that's jumping the gun, and will rely on
-- fixed binds during the development process.

-- keys should be friendly names
-- values are valid scancodes
local keyBind = {
   a="x", b="z",
   l="a", r="s",
   du="up", dd="down",
   dl="left", dr="right",
   st="return", sel="rshift"
}
-- initialize all button states
local buttons = {}
local resolved = {}

local joyBind = {
   a="b", b="a",
   l="leftshoulder", r="rightshoulder",
   st="start", sel="back",
   du="dpup", dd="dpdown",
   dl="dpleft", dr="dpright",
}

local joy = love.joystick.getJoysticks()[1] -- hard code
love.joystick.loadGamepadMappings("src/gamecontrollerdb.txt")

-- Currently only tested on iBuffalo snes controller
local joy2hat = function (lr, ud, check)
   local dz = 0.5 --deadzone
   if check == "dl" and lr < -dz then return true end
   if check == "dr" and lr >  dz then return true end
   if check == "du" and ud < -dz then return true end
   if check == "dd" and ud >  dz then return true end
end

local input = {
   poll = function (time)
      time = time or love.timer.getTime()
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
            if not buttons[k] then
               buttons[k] = time
            end
         else
            buttons[k] = false
         end
      end
      return buttons
   end,

   resolve = function (time)
      time = time or love.timer.getTime()
      for k,v in pairs(buttons) do
         if not v then
            resolved[k] = 0
         else
            resolved[k] = math.floor((time - v) * GAME.tickrate + 0.5)
         end
      end
      return resolved
   end,

   rebind = function (binds)
      keyBind = binds
   end
}

return input
