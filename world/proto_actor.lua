local proto = {}

function proto:update ()
   -- put your function here!
end

function proto:collide (with)
end

function proto:bounds ()
   return self.pos.x, self.pos.y, 16, 16
end

return proto
