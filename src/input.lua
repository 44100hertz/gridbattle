-- keys should be "friendly" names
-- values must be valid scancodes
local keyBind = {
   a ="x", b="z",
   l="a", r="s",
   st="return", sel="rshift",
   du="i", dd="k",
   dl="j", dr="l"
}

-- populate an array of buttons
local buttons = {}
for k,_ in pairs(keyBind) do buttons[k] = 0 end

local input = {
   update = function ()
      for k,v in pairs(keyBind) do
	 if love.keyboard.isScancodeDown(v) then
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
