local scene = require "src/scene"

return {
   y = 60, spacing = 16,
   font = "title",
   bg_img = "title",
   {"start",
    function ()
       scene.push((require "battle/scene"), "test", "test")
   end},
   {"folder editor",
    function ()
       scene.push(require "foldedit/editor", "test-collection", "test")
   end},
   {"config",
    function ()
       scene.push((require "src/Menu"):new("settings"))
   end},
   {"exit", love.event.quit},
}
