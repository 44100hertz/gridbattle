local keybind1 = {
   a="x", b="z",
   l="a", r="s",
   du="i", dd="k",
   dl="j", dr="l",
   st="g", sel="h"
}
local keybind2 = {
   a="right", b="down",
   l="left", r="up",
   du="kp8", dd="kp5",
   dl="kp4", dr="kp6",
   st="kpenter", sel="kp+"
}
local joybind = {
   a="b", b="a",
   l="leftshoulder", r="rightshoulder",
   st="start", sel="back",
   du="dpup", dd="dpdown",
   dl="dpleft", dr="dpright",
}
local count1 = {}
local count2 = {}

local joy1 = love.joystick.getJoysticks()[1]
local joy2 = love.joystick.getJoysticks()[2]
love.joystick.loadGamepadMappings("src/gamecontrollerdb.txt")

local joy2hat = function (joy, deadzone)
   local lr = joy:getAxis(1)
   local ud = joy:getAxis(2)
   return {
      dl = (lr < -deadzone),
      dr = (lr > deadzone),
      du = (ud < -deadzone),
      dd = (ud > deadzone),
   }
end

local check_joy = function (count, joy, bind)
   local emu_hat = joy2hat(joy, 0.5)
   for k,v in pairs(bind) do
      count[k] = joy:isGamePadDown(v) or emu_hat[k] and count[k]+1 or 0
   end
   return count
end

local check_keys = function (count, bind)
   for k,v in pairs(bind) do
      count[k] = love.keyboard.isScancodeDown(v) and count[k]+1 or 0
   end
   return count
end

local check1, check2
if joy1 then
   check1 = function () return check_joy(count1, joy1, joybind) end
else
   check1 = function () return check_keys(count1, keybind1) end
end
if joy2 then
   check2 = function () return check_joy(count2, joy2, joybind) end
elseif joy1 then
   check2 = function () return check_keys(count2, keybind1) end
else
   check2 = function () return check_keys(count2, keybind2) end
end

return {
   keybind1 = keybind1,
   keybind2 = keybind2,
   joybind = joybind,

   resolve = function ()
      return check1()
   end,

   rebind = function (binds)
      keyBind = binds
   end
}
