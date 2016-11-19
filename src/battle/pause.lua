local canvas
local img = love.graphics.newImage("img/pause.png")
local delay
return {
   init = function(pausecanvas)
      canvas = pausecanvas
      input.update()
      delay = 20
   end,

   update = function ()
      if delay > 0 then delay = delay - 1 end
      if input.start == 1 and delay == 0 then main.popstate() end
   end,

   draw = function()
      love.graphics.draw(canvas)
      love.graphics.draw(img)
   end,
}
