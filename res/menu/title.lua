local scene = require "src/scene"

return {
   y = 60, spacing = 16,
   font = "title",
   bg_img = "title",
   {"start",
    function ()
      local bmain = require "src/battle/main"
      scene.push(bmain, require "res/battle/sets/test")
      bmain.selectchips()
      scene.push(require "src/transition/fade", 0.4, true)
   end},
   {"folder editor",
    function ()
       scene.push(require "res/menu/folder_editor")
   end},
   {"exit", love.event.quit},
}
