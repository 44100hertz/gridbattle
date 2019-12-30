local boot = {
   extends = 'bullet',
   lifespan = 120,
   damage = 40,
   dx=0.1,
}

function boot:init ()
   self:attach('image', 'boots')
end

return boot
