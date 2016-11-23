local main = require "main"

local options = {
   [1] = {
      x=120, y=80, text="back",
      a = function () main.popstate() end,
      b = function () main.popstate() end,
   }
}

local root = {
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
      end,
   },
   [3] = {
      x=120, y=120, text="exit",
      u=2, d=1,
      a = function () love.event.quit() end,
   }
}

return root
