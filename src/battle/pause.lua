local main = require "main"
local img = love.graphics.newImage("img/pause.png")
local input = require "input"

local delay
local pausedmodule
return {
   init = function(mod)
      input.update()
      delay = 20
      pausedmodule = mod
   end,

   update = function ()
      if delay > 0 then delay = delay - 1 end
      if input.start == 1 and delay == 0 then main.popstate() end
   end,

   draw = function()
      pausedmodule.draw()
      love.graphics.draw(img)
   end,
}
