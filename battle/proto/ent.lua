local text = require 'src/text'
local chip_artist = require 'battle/chip_artist'

local ai = require 'battle/proto/ai'

local ent = {}

function ent.initialize (bstate, stage, entities)
   ai.start(stage, bstate.stage.turf)

   ent.query_panel = ai.query_panel
   ent.locate_enemy_ahead = ai.locate_enemy_ahead
   ent.is_panel_free = ai.is_panel_free

   function ent:apply_panel_stat (stat, len, x, y)
      stage:apply_stat(stat, len, x or self.x, y or self.y)
   end
   function ent:free_space (x, y)
      stage.panels[x or self.x][y or self.y].tenant = nil
   end
   function ent:spawn (entity)
      entity.x = entity.x or self.x
      entity.y = entity.y or self.y
      return entities:add(entity)
   end
   function ent:apply_damage (target, amount)
      entities:apply_damage(self, target, amount)
   end
end

function ent:die ()
   self.despawn = true
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

return ent
