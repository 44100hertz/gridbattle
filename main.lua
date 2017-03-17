local game = require "res/game"
local scene = require "src/scene"
local config = require "src/config"
local input = require "src/input"

local time = 0
config.load()
love.graphics.setDefaultFilter("nearest", "nearest")

local poll = function ()
   love.event.pump()
   for name, a,b,c,d,e,f in love.event.poll() do
      if name == "quit" then
         if not love.quit or not love.quit() then
            return true
         end
      end
      love.handlers[name](a,b,c,d,e,f)
   end
   input.poll()
end

local tick = scene.update

local canvas = love.graphics.newCanvas(GAME.width, GAME.height)
local draw = function ()
   love.graphics.setBlendMode("alpha", "alphamultiply")
   canvas:renderTo(scene.draw)

   --      love.graphics.setBlendMode("replace", "premultiplied")
   love.graphics.draw( canvas, 0,0,0, config.c.gamescale )
   love.graphics.print(math.floor(collectgarbage("count")))
   love.graphics.present()

   if outdir then
      time = time + 1
      local imgdata = canvas:newImageData()
      imgdata:encode("tga", outdir .. "/" .. time .. ".tga")
   end
end

love.run = function ()
   local outdir
   if arg[2] == "dump" then
      outdir = "out/" .. os.time()
      love.filesystem.createDirectory(outdir)
   end

   love.math.setRandomSeed(os.time())
   game.start()

   while true do
      if poll() then return end
      tick()
      draw()
   end
end
