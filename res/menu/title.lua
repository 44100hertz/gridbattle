local state = require "src/state"
local menu = require "src/menu"

local fonts = require "res/fonts"
local bg = love.graphics.newImage("res/menu/title.png")

local root = {
   font = fonts.std15,
   draw = function () love.graphics.draw(bg) end,
   [1] = {
      x=120, y=80, text="start",
      du=2, dd=2,
      a = function ()
         local bmain = require "src/battle/main"
         state.push(bmain, require "res/battle/sets/test")
         bmain.selectchips()
         state.push(require "src/transition/fade", 0.4, true)
      end,
   },
   [2] = {
      x=120, y=120, text="exit",
      du=1, dd=1,
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
