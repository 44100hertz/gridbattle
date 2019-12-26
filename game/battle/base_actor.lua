local oop = require 'src/oop'
local image = require 'src/image'

local actor = oop.class()

------------------------------------------------------------
-- Override these fields!
------------------------------------------------------------

-- Initialize data and set up loading parameters
function actor:start ()
   --self:occupy()
end

-- Do anything with the loaded content
function actor:after_load ()
end

-- Called every tick
function actor:update ()
   self:move()
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

-- Set a panel's tenant, by default occupies here with 'self'.
-- Does NOT check if the panel is free, self:is_panel_free()
function actor:occupy (x, y, actor)
   x = x or self.x
   y = y or self.y
   self.battle.stage:set_tenant(x, y, actor or self)
end

-- Free a panel, default this one.
function actor:free_space (x, y)
   x = x or self.x
   y = y or self.y
   self.battle.stage:set_tenant(x, y, nil)
end

-- Hurt a specific actor
function actor:apply_damage (target, amount)
   self.battle.actors:apply_damage(self, target, amount)
end

-- Apply a status effect to a panel
function actor:apply_panel_stat (stat, x, y)
   self.battle.stage:apply_stat(stat, x or self.x, y or self.y)
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

-- Get the information about a panel
function actor:query_panel (x, y)
   x = x or self.x
   y = y or self.y
   return self.battle.stage:getpanel(x,y)
end

-- AI: figure out if there's an actor belonging to the opposite side
function actor:get_panel_enemy (x, y)
   x = x or self.x
   y = y or self.y
   local panel = self.battle.stage:getpanel(x,y)
   local opp_side = self.side==1 and 2 or 1
   return
      panel and
      panel.tenant and
      panel.tenant.side == opp_side and panel.tenant
end

-- AI: figure out if there's an actor in my line of sight
function actor:locate_enemy_ahead (x, y)
   x = x or self.x
   y = y or self.y
   local inc = self.side==1 and 1 or -1
   repeat
      x = x + inc
      local enemy = self:get_panel_enemy(x, y)
      if enemy then return enemy end
   until x < 0 or x > self.battle.stage.num_panels.x
   return nil
end


-- AI: figure out if I can move to a location
function actor:is_panel_free (x, y)
   x = x or self.x
   y = y or self.y
   local panel = self.battle.stage:getpanel(x,y)
   if not panel then
      return false
   end
   local position_side = x > self.battle.state.stage.turf[y] and 2 or 1
   local same_side = self.side == position_side
   return same_side and not panel.tenant
end

-- Get a current pixel position on screen (default center of actor)
function actor:screen_pos (x, y)
   x = x or self.x - 0.5
   y = y or self.y - 0.5
   return self.battle.stage:to_screen_pos(x, y)
end

-- Draw HP and/or chip queue
function actor:draw_info (x, y)
   local stage = self.battle.stage
   if self.hp and not self.hide_hp then
      local hpstr = tostring(math.floor(self.hp))
      love.graphics.printf(hpstr, x - 200, y-stage.panel_size.y/2, 400, 'center')
   end

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

function actor:_load ()
   self:start()

   self.time = 0
   self.z = self.z or 0
   if self.max_hp then self.hp = self.max_hp end

   if self.img then
      self.image = image('battle/actors/' .. self.img)
      self.img = nil
   end

   self:after_load()
end

function actor:_update (input)
   if self.time then
      self.time = self.time + 1
   end
   self:update(input)
   if self.hp and self.hp <= 0 or
      self.lifespan and self.time == self.lifespan
   then
      self:die()
   end
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
