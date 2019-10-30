local oop = require 'src/oop'
local text = require 'src/text'

local chip_artist = require 'battle/chip_artist'

local ent = {}

-- TODO: move many of these methods into battle (so self.battle.spawn, etc.)
-- It's okay that it makes the code a bit more complex. The self.x and self.y
-- defaults can go for the sake of consistency, and will also become nicer when
-- a coordinate type introduced.

function ent.new (battle)
   return oop.instance(ent, {battle = battle})
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

function ent:apply_panel_stat (stat, len, x, y)
   self.battle.stage:apply_stat(stat, len, x or self.x, y or self.y)
end

function ent:free_space (x, y)
   x = x or self.x
   y = y or self.y
   local p = self.battle.stage.panels
   if p[x] and p[x][y] then
      p[x][y].tenant = nil
   end
end

function ent:update ()
   self:move()
end

function ent:move ()
   if self.dx then
      self.real_dx = self.side=='right' and -self.dx or self.dx
      self.x = self.x + self.real_dx
   end
   if self.dy then self.y = self.y + self.dy end
   if self.dz then self.z = self.z + self.dz end
end

function ent:draw (x, y)
   local flip = (self.side=='right' and not self.noflip)
   if self.image then
      self.image:draw(x, y, flip)
   end
end

function ent:draw_info (x, y)
   if self.hp and not self.hide_hp then
      local hpstr = tostring(math.floor(self.hp))
      text.draw('hpnum', hpstr, x, y-40, 'center')
   end

   if self.queue then
      chip_artist.draw_icon_queue(self.queue, x, y-60)
   end
end

function ent:use_chip (chip_name)
   local added = self:spawn {
      name = chip_name,
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
   local opp_side = self.side=='left' and 'right' or 'left'
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
   local position_side = x > self.battle.state.stage.turf[y] and 'right' or 'left'
   local same_side = self.side == position_side
   return same_side and not panel.tenant
end

function ent:locate_enemy_ahead (x, y)
   x = x or self.x
   y = y or self.y
   local inc = self.side=='left' and 1 or -1
   repeat
      x = x + inc
      local enemy = self:get_panel_enemy(x, y)
      if enemy then return enemy end
   until x < 0 or x > self.battle.stage.width
   return nil
end

return ent
