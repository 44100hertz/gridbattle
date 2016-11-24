local main = require "main"
local fonts = require "fonts"
local menu = require "menu/menu"
local bg = love.graphics.newImage("img/menu.png")

local options = {
   font = fonts.std15,
   [1] = {
      x=120, y=80, text="back",
      a = function () main.popstate() end,
      b = function () main.popstate() end,
   }
}

local optionsmenu = {
   start = function ()
   end,

   update = function ()
      menu.update(options)
   end,

   draw = function ()
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
         main.pushstate(require "battle/main", require "battle/sets/test")
      end,
   },
   [2] = {
      x=120, y=100, text="options",
      u=1, d=3,
      a = function ()
         main.pushstate(optionsmenu)
      end,
   },
   [3] = {
      x=120, y=120, text="exit",
      u=2, d=1,
      a = function () love.event.quit() end,
   }
}

return {
   start = function (lastmod)
      menu.start(lastmod, root)
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
