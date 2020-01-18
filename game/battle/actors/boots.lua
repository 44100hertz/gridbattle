-- a 2-boot spawner
local boots = {}

function boots:update ()
   if self.time == 1 or self.time == 30 then
      self:spawn{
         'boot',
         x=self.x, y=self.y,
         frame=self.count,
         side=self.side,
         damage=self.damage,
         parent=self.parent,
      }
   end
end

return boots
