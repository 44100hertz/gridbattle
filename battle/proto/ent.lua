local text = require "src/text"
local actors = require "battle/actors"
local chip_artist = require "battle/chip_artist"
local lg = love.graphics

local kill = function (ent)
   if ent.states and ent.states.die then
      actors.kill(ent)
   elseif ent.die then
      ent:die()
   else
      ent.despawn = true
   end
end

return {
   kill=kill,

   start = function (self)
      if self.states then actors.start(self) end
      self.time = 0
      self.z = self.z or 0
      if self.max_hp then self.hp = self.max_hp end
   end,

   update = function (self, input)
      if self.states then actors.update(self, input) end
      if self.update then self:update(input) end

      if self.hp and self.hp <= 0 or
         self.lifespan and self.time == self.lifespan
      then
         kill(self)
      end

      if self.dx then
         self.real_dx = self.side=="right" and -self.dx or self.dx
         self.x = self.x + self.real_dx
      end
      if self.dy then self.y = self.y + self.dy end
      if self.dz then self.z = self.z + self.dz end

      self.time = self.time + 1
   end,

   draw = function (self, x, y)
      local flip = (self.side=="right" and not self.noflip)

      if self.image then
         self.image:draw(x, y, flip)
      end

      if self.draw then self:draw(x, y) end

      if self.hp and not self.hide_hp then
         local hpstr = tostring(math.floor(self.hp))
         text.draw("hpnum", hpstr, x, y-4, "center")
      end

      if self.queue then
         chip_artist.draw_icon_queue(self.queue, x, y-15)
      end
   end,
}
