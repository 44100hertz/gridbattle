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

-- Called before anything else. At this point, a 'timer' component is already
-- attached to the actor, see battle/components/timer.lua
function base_actor:init ()
end

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

-- misc: An 'attach' method allows actors to add components, see
-- src/actor_loader.lua and battle/components/

-- Update x and y positions (do this once per tick!)
function base_actor:move ()
   self.pos = self.pos + self.velocity / GAME.tick_rate
   if self.dz then
      self.z = self.z + self.dz / GAME.tick_rate
   end
end

-- If on the right side, multiply by this to mirror x offsets and velocity
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

-- Use a chip by name
function base_actor:use_chip (chip_name)
   self:spawn{class = GAME.chipdb[chip_name].class}
end

-- Can I go here?
function base_actor:can_occupy (pos)
   pos = pos or self.pos
   local actor = self.battle:locate_actor(pos)
   return (actor == self or not actor) and
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

-- Return the nearest enemy within a given range ahead of self.
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
      if actor.side ~= self.side and actor.occupy_space and
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

-- Just a helper function for actors using a 'state' field
function base_actor:set_state (state_name, time)
   self.state = state_name
   self.timer:init()
end

-- Shortcut to add a ui element to this actor
function base_actor:add_ui_element (element)
   self.battle.ui.layout:add_element(element)
   return element
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
