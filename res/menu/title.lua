local scene = require "src/scene"

return {
   y = 60, spacing = 16,
   font = "title",
   bg_img = "title",
   {"start",
    a = function ()
       scene.push_fade({}, (require "battle/battle"), "test", "test-folder")
   end},
   {"folder editor",
    a = function ()
       scene.push(require "foldedit/editor", "test-collection", "test")
   end},
   {"worldmap test",
    a = function ()
       scene.push(require "world/world")
   end},
   {"config",
    a = function ()
       scene.push((require "src/Menu"):new("settings"))
   end},
   {"exit", a = love.event.quit},
}
