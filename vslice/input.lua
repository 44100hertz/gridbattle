local stale = 1000

local keyBind = {
   a ="x", b="z", l="a", r="s", start="enter", sel="shift",
   up="i", down="k", left="j", right="l"
}

local buttons = {
   a=0, b=0, l=0, r=0, start=0, sel=0, up=0, down=0, left=0, right=0
}

input = {
   update = function ()
      for k,v in pairs(buttons) do
	 local pressed = love.keyboard.isScancodeDown(keyBind[k])
	 if pressed and buttons[k]~=stale then buttons[k]=buttons[k]+1
	 else buttons[k]=0
	 end
      end
   end,
   
   stale = function (arg)
      arg = arg or "move"
      if arg=="move" then
	 buttons.up = stale
	 buttons.down = stale
	 buttons.left = stale
	 buttons.right = stale
      else
	 buttons[arg] = stale
      end
   end,

   check = function (button, bufferLen)
      bufferLen = bufferLen or 6
      if buttons[button]>0 and buttons[button]<bufferLen then return true
      else return false
      end
   end
}
