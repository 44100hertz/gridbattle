local scene = require "src/scene"

return {
   y=100, spacing=16,
   font = "title",
   bg_img = "pause",
   transparent = true,
   {"return", a = scene.pop},
   {"main menu", a = function ()
       scene.pop()
       scene.pop()
   end},
}
