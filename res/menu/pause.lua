local state = require "src/state"

return {
   y=100, spacing=16,
   font = "title",
   bg_image = "pause",
   transparent = true,
   {"return", state.pop},
   {"main menu", function ()
       state.pop()
       state.pop()
   end},
}

