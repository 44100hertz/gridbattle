local player = {
   is_fighter = true,
   occupy_space = true,
}

function player:init ()
   self:attach('hp', 300, {hidden = true, ui = true})
   self:attach('image', 'ben', {
                  base = {rect={0,0,50,60}, origin={24,31}, scale={1,0.5}},
                  move = {rect={0,60,50,60}, origin={24,31}, count={2,1}, scale={1,0.5}, anim={fps=20, order={1,2}}},
                  shoot = {rect={0,120,50,60}, origin={24,31}, count={2,1}, scale={1,0.5}, anim={fps=20, order={1,2}}},
                  throw = {rect={0,180,50,60}, origin={24,31}, count={2,1}, scale={1,0.5}, anim={fps=20, order={1,2}}},
   })
   self:attach('queue', 'user')
   self:set_state 'idle'
end

function player:update ()
   if self.state == 'idle' then
      if GAME.input:down'l' or GAME.input:down'r' then
         self.battle:request_select_chips()
      end
      local lr = GAME.input:seconds_down'dr' - GAME.input:seconds_down'dl'
      local ud = GAME.input:seconds_down'dd' - GAME.input:seconds_down'du'

      local offset = nil
      if GAME.input:hit'a' then
         self.queue:use_chip()
         self:set_state('use_chip')
      elseif ud<0 then offset = point(0, -1)
      elseif ud>0 then offset = point(0, 1)
      elseif lr<0 then offset = point(-1, 0)
      elseif lr>0 then offset = point(1, 0)
      end
      if offset then
         local goal = self.pos + offset
         if self:can_occupy(goal) then
            self:set_state('move')
            self.pos = goal
         end
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

function player:die ()
   if not GAME.debug.invincibility then
      self.remove_from_battle = true
   end
end

return player
