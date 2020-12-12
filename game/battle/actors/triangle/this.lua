local triangle = {
   lifespan = 1.5,
   auto_collision = true,
   gravity = 0,
}

function triangle:init ()
   self:attach('image', 'bullet',
               {base = {rect={0,0,16,16}, origin={8,8},
                        count={6,1}, anim={order={1,2,3,4,5,6}, fps=20}}}
   )
end

function triangle:update ()
   self.velocity.x = self:mirror().x * self.timer:seconds() * 10
   self:move()
end

function triangle:collide (with)
   self:damage_once(with, 80)
   self.remove_from_battle = true
end

return triangle
