local SDL = require "SDL"

local toscancode = function (table)
   local converted = {}
   for k,v in pairs(table) do
      converted[SDL.getScancodeFromName(k)] = v
   end
   return converted
end

local keybind1 = toscancode{
   x="a", z="b",
   a="l", s="r",
   h="st", g="sel",
   i="du", k="dd",
   j="dl", l="dr",
}

-- local keybind2 = {
--    a="right", b="down",
--    l="left", r="up",
--    st="kpenter", sel="kp+",
--    du="kp8", dd="kp5",
--    dl="kp4", dr="kp6",
-- }
-- local joybind = {
--    a="b", b="a",
--    l="leftshoulder", r="rightshoulder",
--    st="start", sel="back",
--    du="dpup", dd="dpdown",
--    dl="dpleft", dr="dpright",
-- }
-- local joy1 = love.joystick.getJoysticks()[1]
-- local joy2 = love.joystick.getJoysticks()[2]
-- love.joystick.loadGamepadMappings("src/gamecontrollerdb.txt")

-- local deadzone = 0.5
-- local check_key = function (keybind, k)
--    return love.keyboard.isScancodeDown(keybind[k])
-- end
-- local check_joy = function (joy, k)
--    local lr = joy:getAxis(1)
--    local ud = joy:getAxis(2)
--    if k=="dl" and (lr < -deadzone) then return true end
--    if k=="dr" and (lr > deadzone) then return true end
--    if k=="du" and (ud < -deadzone) then return true end
--    if k=="dd" and (ud > deadzone) then return true end
--    return joy:isGamepadDown(joybind[k])
-- end

local count1, methods1 = {}, {}
-- local count2, methods2 = {}, {}

-- if joy1 then
--    methods1[1] = function (k) return check_joy(joy1, k) end
-- end
-- table.insert(methods1, function (k) return check_key(keybind1, k) end)

-- if joy2 then
--    methods2[1] = function (k) return check_joy(joy2, k) end
-- end
-- table.insert(methods2, function (k) return check_key(keybind2, k) end)

-- local check_all = function (count, methods)
--    local check_defer = function (k)
--       for _,v in ipairs(methods) do
--          if v(k) then return true end
--       end
--       return false
--    end
--    local pressed
--    for k,_ in pairs(joybind) do
--       count[k] = check_defer(k) and count[k]+1 or 0
--    end
--    return count
-- end

return {
   keybind1 = keybind1,
   keybind2 = keybind2,
   joybind = joybind,

   handle_keydown = function (e)
      local sc = e.keysym.scancode
      if keybind1[sc] then count1[keybind1[e.keysym.scancode]] = 0 end
   end,

   handle_keyup = function (e)
      local sc = e.keysym.scancode
      if keybind1[sc] then count1[keybind1[sc]] = false end
   end,

   resolve = function ()
      for k,v in pairs(count1) do
         if v then count1[k] = v + 1 end
      end
      return {count1, count1}
   end,

   rebind = function (binds)
      keyBind = binds
   end
}
