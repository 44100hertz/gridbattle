local SDL = require "SDL"
local scene = require "src/scene"

return {
   y = 40, spacing = 16,
   font = "title",
   bg_img = "title",
   {"battle",
    a = function ()
       scene.push_fade({}, (require "battle/battle"), "test")
   end},
   {"pvp",
    a = function ()
       scene.push_fade({}, (require "battle/battle"), "pvp")
   end},
   {"folder editor",
    a = function ()
       scene.push_fade({}, require "foldedit/editor",
          "test-collection", "test")
   end},
   {"worldmap test",
    a = function ()
       scene.push_fade({}, require "world/world")
   end},
   {"config",
    a = function ()
       scene.push_fade({}, (require "src/Menu"):new("settings"))
   end},
}
