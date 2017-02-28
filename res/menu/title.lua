local state = require "src/state"
local menu = require "src/menu"

local fonts = require "res/fonts"
local bg = love.graphics.newImage("res/menu/title.png")

local root = {
   font = fonts.std15,
   draw = function () love.graphics.draw(bg) end,
   [1] = {
      x=120, y=80, text="start",
      du=2, dd=1,
      a = function ()
         state.push(require "src/battle/main",
		    require "res/battle/sets/test")
      end,
   },
   [2] = {
      x=120, y=120, text="exit",
      du=1, dd=2,
      a = love.event.quit,
   }
}

return {
   start = function ()
      menu.start(root)
   end,

   update = function ()
      menu.update(root)
   end,

   draw = function ()
      love.graphics.draw(bg)
      menu.textdraw(root)
   end,
}
