local triangle = {
   extends = 'bullet',
   lifespan = 60,
   dx = 0.01,
   damage = 80,
   desc={'Shoot out',
         'some triangle.'},
}

function triangle:init ()
   self.parent.next_state = 'shoot'
   self:attach('image', 'bullet')
end

function triangle:update ()
   self.dx = self.dx * 1.1
   self:move()
end

return triangle
