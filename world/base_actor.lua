local oop = require 'src/oop'
local battle = require 'battle/battle'

local proto = oop.class {
   visible = true,
   active = true,
}

function proto:init (world)
   self.world = world
end

function proto:update ()
   -- put your function here!
end

function proto:collide (with)
end

function proto:rect ()
   return self.pos.x, self.pos.y, 16, 16
end

function proto:enter_battle (name)
   GAME.scene:push_fade({}, battle(name))
end

function proto:is_walkable (pos)
   return self.world.tiles:walkable((pos / 16 + 0.5):floor():unpack())
end

return proto
