-- A queue of chips, designed to be used by the player.

local chip = require "src/chip"

return {
   draw = function (queue, x,y)
      x = x - #queue - 8
      y = y - #queue - 8
      for i=#queue,1,-1 do
         chip.draw_icon(queue[i][1], x, y)
         x=x+2
         y=y+2
      end
   end,

   use_chip = function (actor)
      if #actor.queue>0 then
         local removed = table.remove(actor.queue, 1)
         local data = chip.getchip(removed[1])
         if data.src.act then data.src.act(actor) end
      end
   end,
}
