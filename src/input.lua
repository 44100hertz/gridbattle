-- keys should be "friendly" names
-- values must be valid scancodes
local keyBind = {
   a="x", b="z",
   l="a", r="s",
   st="return", sel="rshift",
   du="i", dd="k",
   dl="j", dr="l"
}

local joyBind = {
   a="a", b="b",
   l="leftshoulder", r="rightshoulder",
   st="start", sel="back",
   du="dpup", dd="dpdown",
   dl="dpleft", dr="dpright",
}

local joy = love.joystick.getJoysticks()[1]

local joy2hat = function (lr, ud)
   local dz = 0.5 --deadzone
   if math.abs(lr) > math.abs(ud) then -- left/right
      if lr < -dz then return "dl" end
      if lr > dz  then return "dr" end
   else
      if ud < -dz then return "du" end
      if ud > dz  then return "dd" end
   end
end

-- populate an array of buttons
local buttons = {}
for k,_ in pairs(keyBind) do buttons[k] = 0 end

local input = {
   update = function ()
      local fakehat
      if joy then
	 fakehat = joy2hat(joy:getAxis(1),joy:getAxis(2))
      else
	 fakehat = 0
      end

      for k,v in pairs(keyBind) do
	 if love.keyboard.isScancodeDown(v) or
	    joy and joy:isGamepadDown(joyBind[k]) or
	    fakehat == k
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
