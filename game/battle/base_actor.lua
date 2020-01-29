local oop = require 'src/oop'

local base_actor = oop.class()

--[[

   Base Actor: a set of methods and properties inherited into every actor. These
   interact heavily with 'battle/battle', which can give a greater understanding of the
   internal functions. See 'src/actor_loader' for more.

   The "Override" section gives a set of defaults that should be set within each
   actor class in 'battle/actors/', but not modified in this file (unless you
   want to change defaults globally).

   The "Call These Methods" section gives a set of functionality attached to
   each actor. For other functionality, see 'battle/components/' for a list of
   components, and 'src/actor_loader' for documentation on the 'attach' method to
   use them.

]]

------------------------------------------------------------
-- Override these methods and properties!
------------------------------------------------------------

base_actor.is_fighter = false -- Set to 'true' and the game will check if this
                              -- actor is alive when determining if the battle
                              -- has ended.
base_actor.occupy_space = false -- Set to 'true' and this actor will appear
                                -- through 'battle.locate_actor', and other
                                -- actors will (usually) not be able to move to
                                -- the same space. Other actors will collide
                                -- with you, even with auto_collision = false.
base_actor.auto_collision = false -- Set to 'true' and this actor will collide
                                  -- automatically with enemies.
base_actor.neutral = false -- Set to 'true' and no other actor will consider you
                           -- an enemy. Also: see 'side' in next section.
base_actor.z = 0        -- z position / height
base_actor.dz = 0       -- z momentum / falling or rising
base_actor.despawn = false -- Set to 'true' the actor will be removed from
                           -- battle on the next tick.

-- Called before anything else. At this point, a 'timer' component is already
-- attached to the actor, see battle/components/timer.lua
function base_actor:init ()
end

-- Called every tick. Avoid using math that relies on a known tick rate, use
-- math with GAME.tick_rate if needed and be sure to utilize the 'timer'
-- component.
function base_actor:update ()
   self:move() -- add velocity to position
end

-- Called before the actor's components are drawn.
function base_actor:draw ()
end

-- Called every frame when colliding with other. Note that collisions only occur
-- if one actor has 'occupy_space' enabled, and the other has 'auto_collision'.
-- So far, there has been no need for manual collision, and it is not
-- recommended to call this function.
function base_actor:collide (with)
end

-- Called during update when hp is below zero, timer has exceeded lifespan, or
-- any time this actor is supposed to die. This is where you put death
-- animations, or behaviors alternative to dying.
function base_actor:die ()
   self.despawn = true
end

------------------------------------------------------------
-- Use these methods and properties!
------------------------------------------------------------

base_actor.side = nil -- Will be set to my side of battle. Set to 'self' to be
                      -- everyone's enemy!

-- misc: An 'attach' method allows actors to add components, see
-- src/actor_loader.lua and battle/components/

-- Update position and z using velocity and dz (do this once per tick!)
function base_actor:move ()
   self.pos = self.pos + self.velocity / GAME.tick_rate
   if self.dz then
      self.z = self.z + self.dz / GAME.tick_rate
   end
end

-- This is how actors move in the opposite direction so that both player and
-- enemies can use the same attack. For example, a bullet would use
-- self.velocity = self:mirror() * point(1,0) in order to move towards the
-- enemy. Or, self.velocity.x = self:mirror().x.
function base_actor:mirror ()
   if self.side == 2 then
      return point(-1, 1)
   else
      return point(1,1)
   end
end

-- Spawn another actor (default at this location)
function base_actor:spawn (actor)
   actor.parent = self
   actor.pos = actor.pos or self.pos
   actor.side = actor.side or self.side
   return self.battle:add_actor(actor)
end

-- Use a chip by name. See 'chipdb'.
function base_actor:use_chip (chip_name)
   local chip = GAME.chipdb[chip_name]
   assert(chip, 'Attempt to use nonexistant chip: ' .. chip_name)
   self:spawn{class = chip.class}
end

-- Can I go here? Checks to see if the panel's side matches my side, and that
-- there's no other actor with occupy_space in that location.
function base_actor:can_occupy (pos)
   pos = pos or self.pos
   local actor = self.battle:locate_actor(pos)
   return (actor == self or not actor) and
      self.battle:get_side(pos) == self.side
end

-- Determine if another actor is my enemy! Note that self:is_enemy(with) may be
-- true while with:is_enemy(self) is false!
function base_actor:is_enemy (other)
   assert(other)
   return self ~= other and (not other.neutral) and (other.side ~= self.side)
end

-- Is there an enemy on this panel? If so, return it.
function base_actor:locate_enemy (pos)
   pos = pos or self.pos
   local tenant = self.battle:locate_actor(pos)
   if tenant and self:is_enemy(tenant) then
      return tenant
   else
      return nil
   end
end

-- Return the nearest enemy within a given range ahead of self, if any.
-- @pos: location to detect from
-- @range: detection range in panels (default right ahead)
function base_actor:locate_enemy_ahead (pos, range)
   pos = pos or self.pos
   range = range or point(10, 0.5)
   -- Place rectangle in front of pos
   local x = self.side == 1 and pos.x or pos.x - range.x
   -- Center vertical position
   local y = pos.y - range.y / 2
   -- Locate the nearest (linear distance) actor within range
   local found_actor, found_distance = nil, 100
   for _,actor in ipairs(self.battle.actors) do
      if self:is_enemy(actor) and
         actor.pos:within_rectangle(x, y, range.x, range.y) and
         found_distance > actor.pos:distance_to(pos)
      then
         found_actor = actor
         found_distance = actor.pos:distance_to(pos)
      end
   end
   return found_actor, found_distance
end

-- Hurt another actor (to be called set number of times; not every frame!)
-- @target: who to hit
-- @amount: hit points of damage
function base_actor:damage_once (target, amount)
   if target.hp then
      target.hp:adjust(-amount)
   end
end

-- Hurt another actor (to be called every single frame for continuous pain!)
-- @target: who to hit
-- @amount: hit points of damage per second
function base_actor:damage_continuously (target, amount)
   self:damage_once(target, amount / GAME.tick_rate)
end

-- A helper function that sets self.state to state_name, and self.timer to 0
-- seconds. This is based on a simple pattern allowing for multiple animation
-- states.
function base_actor:set_state (state_name)
   self.state = state_name
   self.timer:init()
end

-- Shortcut to add a ui element to this actor.
function base_actor:add_ui_element (element)
   self.battle.layout:add_element(element)
   return element
end

-- Get the pixel position of the center of actor for drawing.
function base_actor:screen_pos ()
   return self.battle:stage_pos_to_screen(self.pos - 0.5)
end

-- Ignore this method.
function base_actor:init (battle)
   self.battle = battle
end

return base_actor
