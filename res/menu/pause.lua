local state = require "src/state"
local menu = require "src/menu"

local fonts = require "res/fonts"

local bg = love.graphics.newImage("res/menu/pause.png")

local pause = {
   st = function () state.pop() end,
   font = fonts.std15,
   [1] = {
      d = 2, u = 2,
      x=180, y=150, text="return",
      a = state.pop,
   },
   [2] = {
      d = 1, u = 1,
      x=180, y=170, text="main menu",
      a = function ()
	 state.pop()
	 state.pop()
      end,
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
      menu.textdraw(pause)
   end,
}

