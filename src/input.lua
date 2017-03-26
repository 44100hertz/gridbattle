local keybind1 = {
   a="x", b="z",
   l="a", r="s",
   st="h", sel="g",
   du="i", dd="k",
   dl="j", dr="l",
}
local keybind2 = {
   a="right", b="down",
   l="left", r="up",
   st="kpenter", sel="kp+",
   du="kp8", dd="kp5",
   dl="kp4", dr="kp6",
}
local joybind = {
   a="b", b="a",
   l="leftshoulder", r="rightshoulder",
   st="start", sel="back",
   du="dpup", dd="dpdown",
   dl="dpleft", dr="dpright",
}
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

local check_key = function (keybind, k)
   return love.keyboard.isScancodeDown(keybind[k])
end
local check_joy = function (joy, k)
   return joy:isGamepadDown(joybind[k])
end

local count1, methods1 = {}, {}
local count2, methods2 = {}, {}

if joy1 then
   methods1[1] = function (k) return check_joy(joy1, k) end
end
table.insert(methods1, function (k) return check_key(keybind1, k) end)

if joy2 then
   methods2[2] = function (k) return check_joy(joy2, k) end
end
table.insert(methods2, function (k) return check_key(keybind2, k) end)

local check_all = function (count, methods)
   local check_defer = function (k)
      for _,v in ipairs(methods) do
         if v(k) then return true end
      end
      return false
   end
   local pressed
   for k,_ in pairs(joybind) do
      count[k] = check_defer(k) and count[k]+1 or 0
   end
   return count
end

return {
   keybind1 = keybind1,
   keybind2 = keybind2,
   joybind = joybind,

   resolve = function ()
      return {check_all(count1, methods1), check_all(count2, methods2)}
   end,

   rebind = function (binds)
      keyBind = binds
   end
}
