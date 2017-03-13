local scene = require "src/scene"

local image

return {
   transparent = true,
   open = true,

   start = function (result)
      if result=="win" then
	 image = love.graphics.newImage("res/battle/win.png")
      else
	 image = love.graphics.newImage("res/battle/lose.png")
      end
   end,

   update = function (_, input)
      if input.a==1 then
	 scene.pop()
	 scene.pop()
      end
   end,

   draw = function ()
      love.graphics.draw(image)
   end,
}
