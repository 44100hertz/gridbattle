local text = require 'src/text'
local actors = require 'battle/actors'
local chip_artist = require 'battle/chip_artist'

local ai = require 'battle/proto/ai'

local lg = love.graphics

local ent = {}

-- Must call initialize before prototype entity is usable at all
function ent:initialize (bstate, stage)
   ai.start(stage, bstate.stage.turf)
   ent.query_panel = ai.query_panel
   ent.locate_enemy_ahead = ai.locate_enemy_ahead
   ent.is_panel_free = ai.is_panel_free
end

function ent:start ()
   if self.states then actors.start(self) end
end

function ent:die ()
   if self.states and self.states.die then
      actors.kill(self)
   else
      self.despawn = true
   end
end

function ent:update (input)
   if self.states then actors.update(self, input) end
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

return ent
