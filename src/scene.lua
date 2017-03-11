--[[ A state is a modular piece of game runtime, such as menu, a
battle, a dialog, etc. They handle the current inputs and drawing, and
can be layered.
--]]

local input = require "src/input"

local stack = {}

return {
   push = function (mod, ...)
      table.insert(stack, mod)
      if mod.start then mod.start(...) end
   end,

   pop = function ()
      if #stack > 0 then
         table.remove(stack)
         return true
      end
   end,

   update = function ()
      input.update()
      stack[#stack]:update()
   end,

   draw = function ()
      local pos = #stack
      while(stack[pos].transparent) do
         pos = pos - 1
      end
      while(stack[pos]) do
         stack[pos]:draw()
         pos = pos + 1
      end
   end,
}

