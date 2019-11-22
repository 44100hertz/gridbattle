-- a singleton that stores a stack of scenes
-- the stack top is the current game state.

local fade = require 'res/scenes/fade'

local scene = {}
local stack = {}

function scene.push (mod)
   table.insert(stack, mod)
end

function scene.pop ()
   if #stack > 0 then
      local removed = table.remove(stack)
      if removed.exit then removed:exit() end
      return true
   end
end

function scene.push_fade (fadeopts, mod, a,b,c,d,e)
   local length = fadeopts.length or 0.25
   local fadein = function ()
      scene.pop()
      scene.push(mod, a,b,c,d,e)
      scene.push(fade(length, true, scene.pop))
   end
   scene.push(fade(length, false, fadein))
end

function scene.update ()
   local top = stack[#stack]
   if top.open and stack[#stack-1].update then stack[#stack-1]:update() end
   local inputs = GAME.input:update()
   if stack[#stack].update then stack[#stack]:update(inputs) end
end

function scene.draw ()
   local pos = #stack
   while(stack[pos].transparent) do
      pos = pos - 1
   end
   while(stack[pos]) do
      if stack[pos].draw then stack[pos]:draw() end
      pos = pos + 1
   end
end

return scene
