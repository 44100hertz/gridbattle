--[[ A state is a modular piece of game runtime, such as menu, a
battle, a dialog, etc. They handle the current inputs and drawing, and
can be layered.
--]]

local input = require "src/input"

local stack = {}

local push = function (mod, ...)
   table.insert(stack, mod)
   if mod.start then mod.start(...) end
end

local pop = function ()
   if #stack > 0 then
      local removed = table.remove(stack)
      if removed.exit then removed:exit() end
      return true
   end
end

local push_fade = function (fadeopts, mod, a,b,c,d,e)
   local length = fadeopts.length or 0.25
   local fadein = function ()
      pop()
      push(mod, a,b,c,d,e)
      push(require"src/scenes/fade", length, true, pop)
   end
   push(require"src/scenes/fade", length, false, fadein)
end

return {
   push = push,
   push_fade = push_fade,
   pop = pop,
   update = function ()
      local top = stack[#stack]
      if top.open and stack[#stack-1].update then stack[#stack-1]:update() end
      local inputs = input.resolve()
      if stack[#stack].update then stack[#stack]:update(inputs) end
   end,

   draw = function (rdr)
      local pos = #stack
      while(stack[pos].transparent) do
         pos = pos - 1
      end
      while(stack[pos]) do
         if stack[pos].draw then stack[pos]:draw() end
         pos = pos + 1
      end
   end,
}

