local state = require "src/state"
local input = require "src/input"
local test = require "src/test"
local fonts = require "src/fonts"

gamewidth = 400
gameheight = 240
gamescale = 2

love.run = function ()
   love.math.setRandomSeed(os.time())
   local time = 0

   love.window.setMode(gamewidth*gamescale, gameheight*gamescale)
   love.graphics.setDefaultFilter("nearest", "nearest")

   local canvas = love.graphics.newCanvas(gamewidth, gameheight)

   state.push(require "src/menu/title")

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
      love.graphics.draw( canvas, 0,0,0, gamescale )
      love.graphics.present()

      if arg[2] == "dump" then
         time = time + 1
         local screenshot = love.graphics.newScreenshot()
         local name = string.format("%3.3d.tga", time)
         screenshot:encode("tga", name)
      end
   end
end

love.quit = function ()
   if arg[2] == "dump" then
      os.execute("ffmpeg -loglevel warning -framerate 60 -i ~/.local/share/love/src/%03d.tga -vf scale=iw*2:ih*2:sws_flags=neighbor -c:v vp8 -qmin 20 -qmax 20 out/vid.webm")
   end
end
