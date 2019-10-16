local text = require 'src/text'
local actors = require 'battle/actors'
local chip_artist = require 'battle/chip_artist'
local chip_wrangler = require 'battle/chip_wrangler'

local ai = require 'battle/proto/ai'

local lg = love.graphics

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
   function ent:use_chip (chip_name)
      chip_wrangler.use(self, chip_name)
   end
   function ent:use_queue_chip ()
      chip_wrangler.queue_use(self)
   end
   function ent:spawn (class_name, variant_name, props)
      props = props or {}
      props.x = props.x or self.x
      props.y = props.y or self.y
      return entities:add(class_name, variant_name, props)
   end
   function ent:apply_damage (target, amount)
      entities:apply_damage(self, target, amount)
   end
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
