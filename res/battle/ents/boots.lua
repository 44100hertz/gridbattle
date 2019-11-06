local boots = {
   extends = 'multi_bullet',
   count = 1,
   num = 2, delay = 10, period = 30,
   damage = 40,
}

function boots:make_bullet ()
   self:spawn{
      name = 'boot',
      x=self.x, y=self.y,
      frame=self.count,
      side=self.side,
      damage=self.damage,
      parent=self.parent,
   }
   self.count = self.count + 1
end

return boots
