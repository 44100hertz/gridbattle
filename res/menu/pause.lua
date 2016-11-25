local state = require "src/state"
local menu = require "src/menu"

local fonts = require "res/fonts/fonts"

local bg = love.graphics.newImage("res/menu/pause.png")

local pause = {
   st = function () state.pop() end,
   font = fonts.std15,
   [1] = {
      x=100, y=100, text="pause",
   }
}

local mod
return {
   start = function (lastmod)
      menu.start(pause)
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

