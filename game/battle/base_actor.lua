local oop = require 'src/oop'
local image = require 'src/image'

local actor = oop.class()

function actor:init (battle)
   self.battle = battle
end

function actor:_load ()
   if self.start then self:start() end

   self.time = 0
   self.z = self.z or 0
   if self.max_hp then self.hp = self.max_hp end

   if self.img then
      self.image = image('battle/actors/' .. self.img)
      self.img = nil
   end

   if self.after_image_load then self:after_image_load() end -- HACK
end

function actor:die ()
   self.despawn = true
end

function actor:spawn (a)
   a.x = a.x or self.x
   a.y = a.y or self.y
   return self.battle.actors:add(a)
end

function actor:apply_damage (target, amount)
   self.battle.actors:apply_damage(self, target, amount)
end

function actor:apply_panel_stat (stat, x, y)
   self.battle.stage:apply_stat(stat, x or self.x, y or self.y)
end

function actor:free_space (x, y)
   x = x or self.x
   y = y or self.y
   local p = self.battle.stage.panels
   if p[x] and p[x][y] then
      p[x][y].tenant = nil
   end
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

function actor:update ()
   self:move()
end

function actor:move ()
   if self.dx then
      self.real_dx = self.side==2 and -self.dx or self.dx
      self.x = self.x + self.real_dx
   end
   if self.dy then self.y = self.y + self.dy end
   if self.dz then self.z = self.z + self.dz end
end

function actor:_draw ()
   local x, y = self.battle.stage:to_screen_pos(self.x - 0.5, self.y - 0.5)
   self:draw(x, y)
   self:draw_info(x, y)
end

function actor:draw (x, y)
   local flip = (self.side==2 and not self.noflip)
   if self.image then
      self.image.scale = (1.0 + 0.2 * self.z)
      self.image:draw(x, y, flip)
   end
end

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

function actor:use_chip (chip_name)
   local added = self:spawn {
      GAME.chipdb[chip_name].class,
      parent = self,
      delay = 8,
   }
   added.side = added.side or self.side
end

function actor:use_queue_chip ()
   if #self.queue>0 then
      local removed = table.remove(self.queue, 1)
      self:use_chip(removed.name)
   end
end

function actor:query_panel (x, y)
   x = x or self.x
   y = y or self.y
   return self.battle.stage:getpanel(x,y)
end

function actor:get_panel_enemy (x, y)
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

return actor
