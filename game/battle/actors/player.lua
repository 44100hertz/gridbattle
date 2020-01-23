local player = {
   is_fighter = true,
   occupy_space = true,
}

function player:init ()
   self:attach('hp', 300, true)
   self:attach('image', 'ben')
   self:attach('queue', 'user', self.side)
   self:set_state 'idle'
end

function player:update (input)
   input = input[self.side]
   if self.state == 'idle' then
      if input.l>0 or input.r>0 then
         self.battle:request_select_chips()
      end
      local move = function  (dx, dy)
         local goal = self.pos + point(dx, dy)
         if self:is_panel_free(goal) then
            self:set_state('move')
            self.pos = goal
         end
      end
      local lr = input.dr - input.dl
      local ud = input.dd - input.du

      if input.a == 1 then
         self.queue:use_chip()
         self:set_state('use_chip')
      elseif ud<0 then move(0, -1)
      elseif ud>0 then move(0, 1)
      elseif lr<0 then move(-1, 0)
      elseif lr>0 then move(1, 0)
      end
   elseif self.state == 'move' then
      if self.timer:seconds_equals(8/60.0) then
         self.state = 'idle'
      end
   elseif self.state == 'use_chip' then
      if self.timer:seconds_equals(20/60.0) then
         self.state = 'idle'
      end
   else
      error('invalid player state: ', self.state)
   end
end

return player
