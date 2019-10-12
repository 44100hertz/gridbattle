local lg = love.graphics
local img = lg.newImage(PATHS.battle ..  'start.png')

local start_time
local transition_length = 0.5
return {
   transparent = true,
   start = function ()
      start_time = love.timer.getTime()
   end,
   update = function ()
      local elapsed = (love.timer.getTime() - start_time) / transition_length
      if elapsed >= 1 then
         (require 'src/scene'):pop()
      end
   end,
   draw = function ()
      local elapsed = (love.timer.getTime() - start_time) / transition_length
      local ysize = math.sqrt(1 - elapsed) * 3
      local ypos = (1 - ysize) / 2 * GAME.height
      lg.draw(img, 0, ypos, 0, 1, ysize)
   end,
}
