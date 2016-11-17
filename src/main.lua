require "test"
require "animation"

local state
main = {
   loadstate = function (mod)
      state = mod
      state.init()
   end,
}

love.run = function ()
   love.graphics.setDefaultFilter("nearest", "nearest")
   local gamestate

   local gamesize = {x=240, y=160}
   canvas_scale = 4

   local canvas = love.graphics.newCanvas(gamesize.x, gamesize.y)

   love.math.setRandomSeed(os.time())
   main.loadstate(require "battle/battle")

   while true do
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
	 if name == "quit" then
	    if not love.quit or not love.quit() then
	       return a
	    end
	 end
	 love.handlers[name](a,b,c,d,e,f)
      end

      input.update()
      state.update()

      love.graphics.setBlendMode("alpha", "alphamultiply")
      canvas:renderTo( function()
	    state.draw()
      end)

      love.graphics.setBlendMode("replace", "premultiplied")
      love.graphics.draw( canvas, 0,0,0, 3 )
      love.graphics.present()
   end
end
