local scene = require 'src/scene'

local menu = {
   y=100,
   spacing=16,
   font = 'title',
   bg_img = 'pause',
   transparent = true,
   {
      text = 'return',
      a = scene.pop
   },
   {
      text = 'main menu',
      a = function ()
         scene.pop()
         scene.pop()
      end,
   },
}

return menu
