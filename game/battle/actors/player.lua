local player = {
   is_fighter = true,
   occupy_space = true,
}

function player:init ()
   self:attach('hp', 300, {hidden = true, ui = true})
   self:attach('image', 'ben')
   self:attach('queue', 'user')
   self:set_state 'idle'
end

function player:update ()
   if self.state == 'idle' then
      if GAME.input:down'l' or GAME.input:down'r' then
         self.battle:request_select_chips()
      end
      local move = function  (dx, dy)
         local goal = self.pos + point(dx, dy)
         if self:can_occupy (goal) then
            self:set_state('move')
            self.pos = goal
         end
      end
      local lr = GAME.input:seconds_down'dr' - GAME.input:seconds_down'dl'
      local ud = GAME.input:seconds_down'dd' - GAME.input:seconds_down'du'

      if GAME.input:hit'a' then
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
