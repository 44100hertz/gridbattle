local oop = require 'src/oop'

local base_actor = oop.class()

------------------------------------------------------------
-- Override these methods and properties!
------------------------------------------------------------

base_actor.is_fighter = false -- Set to 'true' and the game will check if this
                              -- actor is alive when determining if the battle
                              -- has ended.
base_actor.occupy_space = false -- Set to 'true' and other actors will not be
                                -- able to occupy the same space.
base_actor.z = 0        -- z position / height
base_actor.dz = 0       -- z momentum / falling or rising
base_actor.despawn = false -- Set to 'true' the actor will be deleted.

-- misc:
-- A 'timer' component is on all actors, see battle/components/timer.lua
-- An 'attach' method allows actors to add components, see battle/components/
-- An 'init' method is called on every actor before any other

-- Called every tick
function base_actor:update ()
   self:move() -- add velocity to position
end

-- Called before the actor's components are drawn
function base_actor:draw ()
end

-- Called every frame when colliding with other
function base_actor:collide (with)
end

-- Called during update when hp is below zero, or any time this actor is
-- supposed to die.
function base_actor:die ()
   self.despawn = true
end

------------------------------------------------------------
-- Call these methods!
------------------------------------------------------------

-- Update x and y positions (do this once per tick!)
function base_actor:move ()
   self.pos = self.pos + self:real_velocity()
   if self.dz then self.z = self.z + self.dz end
end

-- If on the right side, multiply by this to mirror x offsets and velocity
function base_actor:mirror ()
   return point(self.side == 2 and -1 or 1, 1.0)
end

-- 'real velocity' is mirrored by side
function base_actor:real_velocity ()
   return self.velocity and self.velocity * self:mirror()
end

-- Spawn another actor (default at this location)
function base_actor:spawn (actor)
   actor.parent = self
   actor.pos = actor.pos or self.pos
   actor.side = actor.side or self.side
   return self.battle:add_actor(actor)
end

-- Use a chip by name
function base_actor:use_chip (chip_name)
   self:spawn{class = GAME.chipdb[chip_name].class}
end

-- Can I go here?
function base_actor:is_panel_free (pos)
   pos = pos or self.pos
   return not self.battle:locate_actor(pos) and
      self.battle:get_side(pos) == self.side
end

-- Is there an enemy here?
function base_actor:locate_enemy (pos)
   pos = pos or self.pos
   local tenant = self.battle:locate_actor(pos)
   if tenant and tenant.side ~= self.side then
      return tenant
   else
      return nil
   end
end

-- Is there an enemy in front of here?
function base_actor:locate_enemy_ahead (pos)
   pos = pos or self.pos
   local inc = self.side==1 and 1 or -1
   repeat
      pos = pos + point(inc, 0)
      local enemy = self:locate_enemy(pos)
      if enemy then return enemy end
   until pos.x < 0 or pos.x > self.battle.num_panels.x
end

-- Hurt a known actor
function base_actor:damage_other (target, amount)
   if target.hp then
      target.hp:adjust(-amount)
   end
end

-- Just a helper function for actors using a 'state' field
function base_actor:set_state (state_name, time)
   self.state = state_name
   self.timer:init()
end

-- Get the pixel position of the center of actor
function base_actor:screen_pos ()
   return self.battle:stage_pos_to_screen(self.pos - 0.5)
end

-- Ignore this method, it's just how the 'battle' field is bound since
-- base_actor is a class
function base_actor:init (battle)
   self.battle = battle
end

return base_actor
