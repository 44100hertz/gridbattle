local triangle = {
   extends = 'bullet',
   lifespan = 60,
   damage = 80,
   desc={'Shoot out',
         'some triangle.'},
}

function triangle:init ()
   self.velocity = point(0, 0)
   self.parent.next_state = 'shoot'
   self:attach('image', 'bullet')
end

function triangle:update ()
   self.velocity.x = self.time * 0.005
   self:move()
end

return triangle
