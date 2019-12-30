local player = {
   extends = 'navi',
}

function player:init ()
   self:attach('hp', 300, true)
   self:attach('image', 'ben')
   self.image.image.yscale = 0.5 -- HACK: why
   self:enter_state('base') -- HACK: normally done by 'actor', to be replaced
end

function player:act (input)
   if not input then return end
   input = input[self.side]

   if input.l>0 or input.r>0 then
      self.battle:request_select_chips()
   end
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
