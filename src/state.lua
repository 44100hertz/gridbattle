local input = require "src/input"

local state
local statestack = {}

return {
   push = function (mod, ...)
      table.insert(statestack, state)
      mod.start(state, ...)
      state = mod
      input.update()
      state.update()
   end,

   pop = function ()
      if #statestack > 0 then
         state = table.remove(statestack)
         return true
      end
   end,

   update = function ()
      state.update()
   end,

   draw = function ()
      state.draw()
   end,
}

