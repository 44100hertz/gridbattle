local main = require "main"
local fonts = require "fonts"

local bg = love.graphics.newImage("img/pause.png")

return {
   draw = function () love.graphics.draw(bg) end,
   st = function () main.popstate() end,
   font = fonts.std15,
   {  x=100, y=100, text="pause",
   }
}
