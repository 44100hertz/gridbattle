local state = require "src/state"

local sel
return {
   y = 100,
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
