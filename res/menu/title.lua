local state = require "src/state"
local menu = require "src/menu"

local fonts = require "res/fonts/fonts"
local bg = love.graphics.newImage("res/menu/title.png")

local options = {
   font = fonts.std15,
   a = state.pop,
   b = state.pop,
   [1] = {
      x=120, y=80, text="back",
   }
}

local optionsmenu = {
   start = function ()
      menu.start(options)
   end,

   update = function ()
      menu.update(options)
   end,

   draw = function ()
      love.graphics.draw(bg)
      menu.textdraw(options)
   end
}

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
      x=120, y=100, text="options",
      u=1, d=3,
      a = function ()
         state.push(optionsmenu)
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
      love.graphics.circle("fill", root[root.sel].x-20, root[root.sel].y, 8)
      menu.textdraw(root)
   end,
}
