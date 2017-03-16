local scene = require "src/scene"
local config = require "src/config"

return {
   y = 60, spacing = 16,
   font = "title",
   {"gamescale: " .. config.c.gamescale,
    function ()
       config.set_gamescale((config.c.gamescale % 5) + 1)
   end},
   {"save", config.save},
   {"exit",
    function ()
       scene.pop()
   end},
}
