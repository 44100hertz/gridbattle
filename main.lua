_G.RES_PATH = arg[2] or "res/"
local game = require(RES_PATH .. "game")
local lg = love.graphics
local lt = love.timer
local outdir

do
   _G.PATHS = {}
   local paths = {
      chipdb = "chipdb",
      enemydb = "enemydb",
      imgdb = "imgdb",
      chips = "chips/",
      bg = "bg/",
      fonts = "fonts/",
      foldedit = "foldedit/",
      folders = "folders/",
      menu = "menu/",
      battle = "battle/",
      sets = "battle/sets/",
   }

   for k,v in pairs(paths) do
      _G.PATHS[k] = RES_PATH .. v
   end

   -- Index chips by name or by index interchangeably
   local chipdb = require(PATHS.chipdb)
   for i,v in ipairs(chipdb) do
      v.index = i
      chipdb[v[1]] = v
   end
end

local scene = require "src/scene"
local config = require "src/config"
local input = require "src/input"

local time = 0
config.load()
lg.setDefaultFilter("nearest", "nearest")
local canvas = lg.newCanvas(GAME.width, GAME.height)
GAME.tickperiod = (1/GAME.tickrate)

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
end

love.update = scene.update
love.draw = function ()
   --lg.setBlendMode("alpha", "alphamultiply")
   canvas:renderTo(scene.draw)

   --lg.setBlendMode("replace", "premultiplied")
   lg.draw( canvas, 0,0,0, config.c.gamescale )
   lg.print(math.floor(collectgarbage("count")))
   lg.present()

   if outdir then
      time = time + 1
      local imgdata = canvas:newImageData()
      imgdata:encode("tga", outdir .. "/" .. time .. ".tga")
   end
end

love.run = function ()
   if arg[3] == "dump" then
      outdir = "out/" .. os.time()
      love.filesystem.createDirectory(outdir)
   end

   love.math.setRandomSeed(os.time())
   game.start()
   local next_tick = lt.getTime() + GAME.tickperiod

   while true do
      if poll() then return end
      love.update()
      while(lt.getTime() < next_tick) do
         love.draw(lt.getTime())
      end
      next_tick = next_tick + GAME.tickperiod
   end
end
