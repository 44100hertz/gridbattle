local boot = {
   extends = 'bullet',
   lifespan = 120,
   damage = 40,
}

function boot:init ()
   self:attach('image', 'boots')
   self.velocity = point(0.1, 0)
end

return boot
