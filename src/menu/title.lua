local main = require "main"
local fonts = require "fonts"
local bg = love.graphics.newImage("img/menu.png")

local options = {
   [1] = {
      x=120, y=80, text="back",
      a = function () main.popstate() end,
      b = function () main.popstate() end,
   }
}

local draw = function (sel)
   if true then
      love.graphics.circle("fill", sel.x-20, sel.y, 8)
   end
end

return {
   font = fonts.std15,
   draw = function () love.graphics.draw(bg) end,
   [1] = {
      x=120, y=80, text="start",
      u=3, d=2,
      a = function ()
         main.pushstate(require "battle/main", require "battle/sets/test")
      end,
      draw = draw,
   },
   [2] = {
      x=120, y=100, text="options",
      u=1, d=3,
      a = function ()
      end,
      draw = draw,
   },
   [3] = {
      x=120, y=120, text="exit",
      u=2, d=1,
      a = function () love.event.quit() end,
      draw = draw,
   }
}
