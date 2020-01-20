-- a 2-boot spawner
local boots = {}

function boots:update ()
   if self.time == 1 or self.time == 30 then
      self:spawn{
         class = 'boot',
         frame = self.time == 1 and 1 or 2,
         parent = self.parent,
      }
   end
end

return boots
