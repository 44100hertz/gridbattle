local oop = require 'src/oop'
local text = require 'src/text'
local image = require 'src/image'

local ent = {}

-- TODO: move many of these methods into battle (so self.battle.spawn, etc.)
-- It's okay that it makes the code a bit more complex. The self.x and self.y
-- defaults can go for the sake of consistency, and will also become nicer when
-- a coordinate type introduced.

function ent.new (battle)
   return oop.instance(ent, {battle = battle})
end

function ent:_load ()
   if self.start then self:start() end

   self.time = 0
   self.z = self.z or 0
   if self.max_hp then self.hp = self.max_hp end

   if self.img then
      self.image = image.new('battle/entities/' .. self.img)
      self.img = nil
   end

   if self.after_image_load then self:after_image_load() end -- HACK
end

function ent:die ()
   self.despawn = true
end

function ent:spawn (entity)
   entity.x = entity.x or self.x
   entity.y = entity.y or self.y
   return self.battle.entities:add(entity)
end

function ent:apply_damage (target, amount)
   self.battle.entities:apply_damage(self, target, amount)
end

function ent:apply_panel_stat (stat, x, y)
   self.battle.stage:apply_stat(stat, x or self.x, y or self.y)
end

function ent:free_space (x, y)
   x = x or self.x
   y = y or self.y
   local p = self.battle.stage.panels
   if p[x] and p[x][y] then
      p[x][y].tenant = nil
   end
end

function ent:_update (input)
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

function ent:update ()
   self:move()
end

function ent:move ()
   if self.dx then
      self.real_dx = self.side==2 and -self.dx or self.dx
      self.x = self.x + self.real_dx
   end
   if self.dy then self.y = self.y + self.dy end
   if self.dz then self.z = self.z + self.dz end
end

function ent:_draw ()
   local x, y = self.battle.stage:to_screen_pos(self.x - 0.5, self.y - 0.5)
   self:draw(x, y)
   self:draw_info(x, y)
end

function ent:draw (x, y)
   local flip = (self.side==2 and not self.noflip)
   if self.image then
      self.image.scale = (1.0 + 0.2 * self.z)
      self.image:draw(x, y, flip)
   end
end

function ent:draw_info (x, y)
   local stage = self.battle.stage
   if self.hp and not self.hide_hp then
      local hpstr = tostring(math.floor(self.hp))
      text.draw('hpnum', hpstr, x, y-stage.panel_height/2, 'center')
   end

   if self.queue then
      self.battle.chip_artist:draw_icon_queue(self.queue, x, y-stage.panel_height*0.7)
   end
end

function ent:use_chip (chip_name)
   local added = self:spawn {
      name = GAME.chipdb[chip_name].class,
      parent = self,
      delay = 8,
   }
   added.side = added.side or self.side
end

function ent:use_queue_chip ()
   if #self.queue>0 then
      local removed = table.remove(self.queue, 1)
      self:use_chip(removed.name)
   end
end

function ent:query_panel (x, y)
   x = x or self.x
   y = y or self.y
   return self.battle.stage:getpanel(x,y)
end

function ent:get_panel_enemy (x, y)
   x = x or self.x
   y = y or self.y
   local panel = self.battle.stage:getpanel(x,y)
   local opp_side = self.side==1 and 2 or 1
   return
      panel and
      panel.tenant and
      panel.tenant.tangible and
      panel.tenant.side == opp_side and panel.tenant
end

function ent:is_panel_free (x, y)
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

function ent:locate_enemy_ahead (x, y)
   x = x or self.x
   y = y or self.y
   local inc = self.side==1 and 1 or -1
   repeat
      x = x + inc
      local enemy = self:get_panel_enemy(x, y)
      if enemy then return enemy end
   until x < 0 or x > self.battle.stage.width
   return nil
end

return ent
