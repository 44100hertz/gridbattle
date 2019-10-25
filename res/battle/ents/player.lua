local player = {
   extends = 'navi',
   img = 'ben',
   hp = 300, hide_hp = true,
}

function player:act (input)
   if not input then return end
   input = self.side=='left' and input[1] or input[2]

   self.selectchips = input.l>0 or input.r>0
   local move = function  (dx, dy)
      local goalx, goaly = self.x+dx, self.y+dy
      if self:is_panel_free(goalx, goaly) then
         self.goalx, self.goaly = goalx, goaly
         self.next_state = 'move'
      end
   end
   local lr = input.dr - input.dl
   local ud = input.dd - input.du

   if input.a == 1 then self:use_queue_chip()
   elseif ud<0 then move(0, -1)
   elseif ud>0 then move(0, 1)
   elseif lr<0 then move(-1, 0)
   elseif lr>0 then move(1, 0)
   end
end

return player
