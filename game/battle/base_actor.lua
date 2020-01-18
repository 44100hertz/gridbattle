local oop = require 'src/oop'

local actor = oop.class()

------------------------------------------------------------
-- Override these fields!
------------------------------------------------------------

actor.time = 0     -- Length of existance in ticks. May break if modified.
actor.z = 0        -- z position, used in animation.

function actor:init ()
end

function actor:attach (name, ...)
   local class = self.battle:get_component(name)
   local component = setmetatable({}, {__index = class})
   self[name] = component
   self.components[#self.components+1] = component
   component:init(self, ...)
end

function actor:super () -- HACK
   return getmetatable(getmetatable(self).__index).__index
end

-- Called every tick
function actor:update ()
   self:move()
end

function actor:_update (input)
   self:update(input)
   self.time = self.time + 1

   if self.hp and self.hp:is_zero() or
      (self.lifespan and self.time >= self.lifespan)
      then
         self:die()
   end
end

-- Called every frame when colliding with other
function actor:collide (with)
end

-- Called during update when hp is below zero, or any time this actor is
-- supposed to die.
function actor:die ()
   self.despawn = true
end

------------------------------------------------------------
-- Call these methods!
------------------------------------------------------------

-- Update x and y positions (do this once per tick!)
function actor:move ()
   if self.velocity then
      self.pos = self.pos + self:real_velocity()
   end
   if self.dz then self.z = self.z + self.dz end
end

-- If on the right side, multiply by this to mirror x offsets and velocity
function actor:mirror ()
   return point(self.side == 2 and -1 or 1, 1.0)
end

-- Shorthand for effective velocity
function actor:real_velocity ()
   return self.velocity and self.velocity * self:mirror()
end

-- Spawn another actor (default at this location)
function actor:spawn (child)
   return self.battle.actors:add(child, child.pos or self.pos)
end

-- Set a panel's tenant to self, by default occupies here
function actor:occupy_panel (pos)
   self:get_panel(pos).tenant = self
end

-- Free a panel, default this one.
function actor:free_panel (pos)
   local panel = self:get_panel(pos)
   if panel and panel.tenant == self then
      panel.tenant = nil
   end
end

function actor:get_panel (pos)
   return self.battle.stage:get_panel(pos or self.pos)
end

function actor:is_panel_free (pos)
   return self.battle.stage:is_panel_free(pos or self.pos, self.side)
end

-- Hurt a known actor
function actor:damage_other (target, amount)
   self.battle.actors:apply_damage(self, target, amount)
end

-- Apply a status effect to a panel
function actor:apply_panel_stat (stat, offset)
   local pos = offset and self.pos + offset*self:mirror() or self.pos
   self.battle.stage:apply_stat(stat, pos)
end

-- Just a helper function for actors using a 'state' field
function actor:set_state (state_name, time)
   self.state = state_name
   self.time = time or 0
end

-- Use a chip by name
function actor:use_chip (chip_name)
   local added = self:spawn {
      GAME.chipdb[chip_name].class,
      parent = self,
      delay = 8,
   }
   added.side = added.side or self.side
end

function actor:locate_enemy ()
   return self.battle.stage:locate_enemy(self.pos, self.side)
end

function actor:locate_enemy_ahead ()
   return self.battle.stage:locate_enemy_ahead(self.pos, self.side)
end

-- Get the pixel position of the center of actor
function actor:screen_pos ()
   return self.battle.stage:to_screen_pos(self.pos - 0.5)
end

-- Draw HP and/or chip queue
function actor:draw_info (draw_shadow)
   local stage = self.battle.stage
end

------------------------------------------------------------
-- Internal methods (override with caution!)
------------------------------------------------------------

function actor:init (battle)
   self.battle = battle
end

function actor:_draw (draw_shadow)
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

function actor:draw ()
end

return actor
