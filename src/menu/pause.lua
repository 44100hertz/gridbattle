local main = require "main"
local fonts = require "fonts"
local menu = require "menu/menu"

local bg = love.graphics.newImage("img/pause.png")

local pause = {
   st = function () main.popstate() end,
   font = fonts.std15,
   [1] = {
      x=100, y=100, text="pause",
   }
}

local mod
return {
   start = function (lastmod)
      menu.start(_, pause)
      mod = lastmod
   end,

   update = function ()
      menu.update(pause)
   end,

   draw = function ()
      mod.draw()
      love.graphics.draw(bg)
   end,
}

