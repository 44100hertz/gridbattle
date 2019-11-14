_G.RES_PATH = arg[2] or 'res/'
local outdir

local scene = require 'src/scene'
local config = require 'src/config'
local menu = require 'src/menu'

_G.GAME = {
   width = 240,
   height = 160,
   tickrate = 60,
}

GAME.tickperiod = 1/GAME.tickrate

_G.PATHS = {
   chips      = 'res/chips/',
   chipdb     = 'res/chipdb',
   imgdb      = 'res/imgdb',
   folders    = 'res/folders/',
   bg         = 'res/bg/',
   fonts      = 'res/fonts/',
   menu       = 'res/menu/',

   foldedit   = 'foldedit/',
   battle     = 'battle/',
   sets       = 'battle/sets/',
}

-- Index chips by name or by index interchangeably
do
   local chipdb = require(PATHS.chipdb)
   for i,v in ipairs(chipdb) do
      v.index = i
      chipdb[v[1]] = v
   end
end

local time = 0
config.load()
love.graphics.setDefaultFilter('nearest', 'nearest')
GAME.tickperiod = (1/GAME.tickrate)

local dump_canvas

local poll = function ()
   love.event.pump()
   for name, a,b,c,d,e,f in love.event.poll() do
      if name == 'quit' then
         if not love.quit or not love.quit() then
            return true
         end
      end
      love.handlers[name](a,b,c,d,e,f)
   end
end

love.run = function ()
   if arg[3] == 'dump' then
      dump_canvas = love.graphics.newCanvas(240, 160)
      outdir = 'out/' .. os.time()
      love.filesystem.createDirectory(outdir)
   end

   love.math.setRandomSeed(os.time())
   scene.push(menu.new('title'))
   local next_tick = love.timer.getTime() + GAME.tickperiod

   while true do
      if poll() then return end
      scene.update()
      while(love.timer.getTime() < next_tick) do
         love.draw(love.timer.getTime())
      end
      next_tick = next_tick + GAME.tickperiod
   end
end

love.draw = function ()
   love.graphics.origin()
   love.graphics.scale( config.c.gamescale, config.c.gamescale )
   scene.draw()
   love.graphics.origin()
   love.graphics.print(math.floor(collectgarbage('count')))
   love.graphics.present()

   if outdir then
      dump_canvas:renderTo(scene.draw)
      time = time + 1
      local imgdata = dump_canvas:newImageData()
      imgdata:encode('tga', outdir .. '/' .. time .. '.tga')
   end
end
