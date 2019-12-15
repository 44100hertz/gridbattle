local battle = require 'battle/battle'
local proto = {
   visible = true,
   active = true,
}

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

return proto
