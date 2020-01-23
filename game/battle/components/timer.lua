local timer = {}

function timer:init ()
   self.tick_count = 0
end

function timer:tick ()
   self.tick_count = self.tick_count + 1
end

function timer:seconds_equals (seconds)
   return self.tick_count == math.floor(seconds * GAME.tickrate)
end

function timer:seconds ()
   return self.tick_count / GAME.tickrate
end

return timer
