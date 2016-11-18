require "test"
require "animation"
require "input"
require "fonts"

local state
main = {
   loadstate = function (mod)
      state = mod
      state.init()
      state.update()
   end,
}

local screenwidth = 240
local screenheight = 160
local screenscale = 3

love.run = function ()
   if arg[2] == "dump" then screenscale = 1 end
   local framecounter = 0
   love.window.setMode(screenwidth*screenscale, screenheight*screenscale)
   love.graphics.setDefaultFilter("nearest", "nearest")
   local gamestate

   local gamesize = {x=240, y=160}
   canvas_scale = 4

   local canvas = love.graphics.newCanvas(gamesize.x, gamesize.y)

   love.math.setRandomSeed(os.time())
   main.loadstate(require "menu/menu")

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
      love.graphics.draw( canvas, 0,0,0, screenscale )
      love.graphics.present()

      framecounter = framecounter + 1
      if arg[2] == "dump" then
	 local screenshot = love.graphics.newScreenshot()
	 local name = string.format("%3.3d.tga", framecounter)
	 screenshot:encode("tga", name)
      end
   end
end

love.quit = function ()
   if arg[2] == "dump" then
      os.execute("ffmpeg -framerate 60 -i ~/.local/share/love/src/%03d.tga -vf scale=iw*4:ih*4:sws_flags=neighbor out.mp4")
   end
end

