local oop = require 'src/oop'
local image = require 'src/image'

local actor = oop.class()

------------------------------------------------------------
-- Override these fields!
------------------------------------------------------------

actor.time = 0     -- Length of existance in ticks. May break if modified.
actor.z = 0        -- z position, used in animation.
actor.img = nil    -- if set, loads an image (src/image) into 'self.image'

-- initialize the actor
-- 'img' must be set here actor if has image
function actor:start ()
   --self:occupy()
end

function actor:attach (name, ...)
   self[name] = self.battle.components[name](...)
   self.components[#self.components+1] = self[name]
end

-- 'internal' initialization
function actor:_load ()
   self.components = {}

   self:start()

   if self.img then
      self.image = image('battle/actors/' .. self.img)
      self.img = nil
   end

   self:after_load()
end

-- change properties on loaded items
-- TODO: remove this
function actor:after_load ()
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

function actor:die ()
   self.despawn = true
end

function actor:draw (x, y, draw_shadow)
   if self.image then
      self:draw_image(x, y, draw_shadow)
   end
end

------------------------------------------------------------
-- Call these methods!
------------------------------------------------------------

-- Update x and y positions (do this once per tick!)
function actor:move ()
   -- Mirror x momentum for actors on the right side
   if self.dx then
      self.real_dx = self.side==2 and -self.dx or self.dx
      self.x = self.x + self.real_dx
   end
   if self.dy then self.y = self.y + self.dy end
   if self.dz then self.z = self.z + self.dz end
end

-- Default image drawing routine
function actor:draw_image (x, y, draw_shadow)
   local flip = (self.side==2 and not self.noflip)
   local scale_mult = draw_shadow and 0.3 or 0.2
   self.image.scale = (1.0 + scale_mult * self.z)
   self.image:draw(x, y, flip)
end

-- Spawn another actor (default at this location)
function actor:spawn (a)
   a.x = a.x or self.x
   a.y = a.y or self.y
   return self.battle.actors:add(a)
end

-- Set a panel's tenant to self, by default occupies here
function actor:occupy_panel (x, y)
   self:get_panel(x, y).tenant = self
end

-- Free a panel, default this one.
function actor:free_panel (x, y)
   local panel = self:get_panel(x, y)
   if panel and panel.tenant == self then
      panel.tenant = nil
   end
end

function actor:get_panel (x, y)
   return self.battle.stage:get_panel(x or self.x, y or self.y)
end

function actor:is_panel_free (x, y)
   return self.battle.stage:is_panel_free(x or self.x, y or self.y, self.side)
end

-- Hurt a known actor
function actor:damage_other (target, amount)
   self.battle.actors:apply_damage(self, target, amount)
end

-- Apply a status effect to a panel
function actor:apply_panel_stat (stat, xoff, yoff)
   xoff = xoff and (self.side == 2 and -xoff or xoff) or 0
   yoff = yoff or 0
   self.battle.stage:apply_stat(stat, self.x + xoff, self.y + yoff)
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

-- Use a chip in the current queue
function actor:use_queue_chip ()
   if #self.queue>0 then
      local removed = table.remove(self.queue, 1)
      self:use_chip(removed.name)
   end
end

function actor:locate_enemy ()
   return self.battle.stage:locate_enemy(self.x, self.y, self.side)
end

function actor:locate_enemy_ahead ()
   return self.battle.stage:locate_enemy_ahead(self.x, self.y, self.side)
end

-- Get the pixel position of the center of actor
function actor:screen_pos ()
   return self.battle.stage:to_screen_pos(self.x - 0.5, self.y - 0.5)
end

-- Draw HP and/or chip queue
function actor:draw_info (x, y)
   local stage = self.battle.stage
   if self.queue then
      self.battle.chip_artist:draw_icon_queue(self.queue, x, y-stage.panel_size.y*0.7)
   end
end

------------------------------------------------------------
-- Internal methods (override with caution!)
------------------------------------------------------------

function actor:init (battle)
   self.battle = battle
end

function actor:_draw (draw_shadow)
   local x, y = self:screen_pos()
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

   self:draw(x, y, draw_shadow)
   self:draw_info(x, y, draw_shadow)

   love.graphics.setColor(1,1,1)
   love.graphics.pop()
end

return actor
