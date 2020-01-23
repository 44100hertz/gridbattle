-- a 2-boot spawner
local boots = {}

function boots:init ()
   self.boot_count = 1
end

function boots:update ()
   if self.timer:seconds_equals(0) or self.timer:seconds_equals(0.5) then
      self:spawn{
         class = 'boot',
         frame = self.boot_count,
         parent = self.parent,
      }
      self.boot_count = 2
   end
end

return boots
