local scene = require "src/scene"

return {
   y = 60, spacing = 16,
   font = "title",
   bg_img = "title",
   {"start",
    function ()
       scene.push((require "src/battle/main"), "test", "test")
   end},
   {"folder editor",
    function ()
       scene.push(require "res/menu/folder_editor")
   end},
   {"exit", love.event.quit},
}
