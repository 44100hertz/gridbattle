local state = require "src/state"

return {
   y = 60, spacing = 12,
   font = "title",
   bg_image = "title",
   {"start",
    function ()
      local bmain = require "src/battle/main"
      state.push(bmain, require "res/battle/sets/test")
      bmain.selectchips()
      state.push(require "src/transition/fade", 0.4, true)
   end},
   {"options",
    function ()
   end},
   {"exit", love.event.quit},
}
