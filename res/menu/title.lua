local state = require "src/state"
local menu = require "src/menu"

local fonts = require "res/fonts"
local bg = love.graphics.newImage("res/menu/title.png")

local root = {
   font = fonts.std15,
   draw = function () love.graphics.draw(bg) end,
   [1] = {
      x=120, y=80, text="start",
      u=3, d=2,
      a = function ()
         state.push(require "src/battle/main", require "res/battle/sets/test")
      end,
   },
   [2] = {
      x=120, y=100, text="input settings",
      u=1, d=3,
      a = function ()
         state.push(require "res/menu/inputbind")
      end,
   },
   [3] = {
      x=120, y=120, text="exit",
      u=2, d=1,
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
