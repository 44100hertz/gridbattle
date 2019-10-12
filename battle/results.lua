local scene = require 'src/scene'
local image

return {
   transparent = true,
   open = true,

   start = function (result)
      image = love.graphics.newImage(PATHS.battle .. result .. '.png')
   end,

   update = function (_, input)
      if input[1].a==1 then
	 scene.pop()
	 scene.pop()
      end
   end,

   draw = function ()
      love.graphics.draw(image)
   end,
}
