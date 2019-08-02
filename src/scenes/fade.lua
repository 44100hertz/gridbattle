local is_in, length, starttime, after

return {
   transparent = true,
   start = function (new_length, new_is_in, new_after)
      is_in, length, after = new_is_in, new_length, new_after
      starttime = love.timer.getTime()
   end,

   update = function ()
      if love.timer.getTime() - starttime > length then
         after()
      end
   end,

   draw = function ()
      local elapsed = love.timer.getTime() - starttime
      local darkness = elapsed / length
      if is_in then darkness = 1.0 - darkness end

      love.graphics.setColor(0, 0, 0, darkness)
      love.graphics.rectangle("fill", 0, 0, GAME.width, GAME.height)
      love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
   end,
}
