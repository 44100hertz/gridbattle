local spawn = {}

function spawn:debug_draw (world)
   love.graphics.circle('line', self.pos.x+8, self.pos.y+8, 2)
end

return spawn
