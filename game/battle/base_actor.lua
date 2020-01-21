local oop = require 'src/oop'

local base_actor = oop.class()

------------------------------------------------------------
-- Override these fields!
------------------------------------------------------------

base_actor.time = 0     -- Length of existance in ticks. May break if modified.
base_actor.z = 0        -- z position, used in animation.
base_actor.is_fighter = false -- Set to 'true' and the game will check if this
                              -- actor is alive when determining if the battle
                              -- has ended.
base_actor.occupy_space = false -- Set to 'true' and other actors will not be
                                -- able to occupy the same space.

function base_actor:init ()
end

-- Called every tick
function base_actor:update ()
   self:move()
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

function base_actor:attach (name, ...)
   local class = self.battle:get_component(name)
   local component = setmetatable({}, {__index = class})
   self[name] = component
   self.components[#self.components+1] = component
   component:init(self, ...)
end

-- Update x and y positions (do this once per tick!)
function base_actor:move ()
   if self.velocity then
      self.pos = self.pos + self:real_velocity()
   end
   if self.dz then self.z = self.z + self.dz end
end

-- If on the right side, multiply by this to mirror x offsets and velocity
function base_actor:mirror ()
   return point(self.side == 2 and -1 or 1, 1.0)
end

-- Shorthand for effective velocity
function base_actor:real_velocity ()
   return self.velocity and self.velocity * self:mirror()
end

-- Spawn another actor (default at this location)
function base_actor:spawn (actor)
   actor.parent = self
   actor.pos = actor.pos or self.pos
   actor.side = actor.side or self.side
   return self.battle.actors:add(actor)
end

-- Use a chip by name
function base_actor:use_chip (chip_name)
   self:spawn{class = GAME.chipdb[chip_name].class}
end

function base_actor:get_panel (pos)
   return self.battle.stage:get_panel(pos or self.pos)
end

function base_actor:is_panel_free (pos)
   pos = pos or self.pos
   return self.battle.stage:is_panel_free(pos) and
      self.battle.stage:get_side(pos) == self.side
end

-- Hurt a known actor
function base_actor:damage_other (target, amount)
   self.battle.actors:apply_damage(self, target, amount)
end

-- Just a helper function for actors using a 'state' field
function base_actor:set_state (state_name, time)
   self.state = state_name
   self.time = time or 0
end

function base_actor:locate_enemy ()
   return self.battle.stage:locate_enemy(self.pos, self.side)
end

function base_actor:locate_enemy_ahead ()
   return self.battle.stage:locate_enemy_ahead(self.pos, self.side)
end

-- Get the pixel position of the center of actor
function base_actor:screen_pos ()
   return self.battle.stage:to_screen_pos(self.pos - 0.5)
end

-- Draw HP and/or chip queue
function base_actor:draw_info (draw_shadow)
   local stage = self.battle.stage
end

------------------------------------------------------------
-- Internal methods (override with caution!)
------------------------------------------------------------

function base_actor:init (battle)
   self.battle = battle
end

function base_actor:_draw (draw_shadow)
   love.graphics.push()

   -- Shadows are a bit offset from the main actor
   if draw_shadow then
      love.graphics.setColor(0,0,0,0.5)
      love.graphics.translate(self.z + 2, self.z * 2 + 2)
   end

   -- Fade out graphics when height is too much
   local fade_height_thresh = 20
   local fade_height_rate = 1.0/50
   if self.z > fade_height_thresh then
      local r, g, b = love.graphics.getColor()
      local alpha = 1.0 + fade_height_rate * (fade_height_thresh - self.z)
      love.graphics.setColor(r, g, b, alpha)
   end

   self:draw(draw_shadow)
   self:draw_info(draw_shadow)

   love.graphics.setColor(1,1,1)
   love.graphics.pop()
end

function base_actor:draw ()
end

return base_actor
