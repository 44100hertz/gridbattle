local oop = require 'src/oop'

local menu = {
   y=100,
   spacing=16,
   font = 'title',
   bg_img = 'pause',
   transparent = true,
}

menu[1] = {
   text = 'return',
   a = oop.bind_by_name(GAME.scene, 'pop'),
}
menu[2] = {
   text = 'exit',
   a = function ()
      GAME.scene:pop()
      GAME.scene:pop()
   end,
}

return menu
