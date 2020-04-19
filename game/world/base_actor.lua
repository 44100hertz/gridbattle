local oop = require 'src/oop'
local battle = require 'battle/battle'

local proto = oop.class {
   visible = true,
   active = true,
}

-- [[ Internal functions ]]

function proto:init (world)
   self.world = world
   self:custom_init()
end

-- [[ Overloadable functions ]]

function proto:custom_init ()
end
function proto:update ()
end
function proto:collide (with)
end
function proto:rect ()
   return self.pos.x, self.pos.y, self.size.x, self.size.y
end

-- [[ Callable functions ]]

function proto:enter_battle (name)
   GAME.scene:push_fade({}, battle(name))
end

function proto:set_tile_graphics_here (id, xoff, yoff)
   local x, y = (self.pos / self.world.tiles.tile_size):floor():unpack()
   xoff = xoff or 0
   yoff = yoff or 0
   self.world.tiles:set_tile_graphics(x + xoff, y + yoff, self.layer, id)
end

return proto
