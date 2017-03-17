local scene = require "src/scene"
local config = require "src/config"

return {
   y = 60, spacing = 16,
   font = "title",
   {"gamescale:" .. config.c.gamescale,
    dr = function (self)
       config.set_gamescale(config.c.gamescale + 1)
       self[1] = "gamescale: " .. config.c.gamescale
    end,
    dl = function (self)
       config.set_gamescale(math.max(config.c.gamescale - 1, 1))
       self[1] = "gamescale: " .. config.c.gamescale
   end},
   {"save", a = config.save},
   {"exit", a = function ()
       scene.pop()
   end},
}
