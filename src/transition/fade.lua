local scene = require "src/scene"

local is_in, fadetime, starttime

return {
   transparent = true,
   start = function (new_fadetime, new_is_in)
      is_in, fadetime = new_is_in, new_fadetime
      starttime = love.timer.getTime()
   end,

   update = function ()
      -- Framerate-independent ending state
      local elapsed = love.timer.getTime() - starttime
      if elapsed > fadetime then scene.pop() end
   end,

   draw = function ()
      local elapsed = love.timer.getTime() - starttime
      local darkness = 255 * elapsed / fadetime
      if is_in then darkness = 255 - darkness end

      love.graphics.setColor(0, 0, 0, darkness)
      love.graphics.rectangle("fill", 0, 0, GAME.width, GAME.height)
      love.graphics.setColor(255, 255, 255, 255)
   end,
}
