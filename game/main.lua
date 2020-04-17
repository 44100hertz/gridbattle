local oop = require 'src/oop'
_G.point = require 'src/point'

local input = require 'src/input'
local scene = require 'src/scene'
local config = require 'src/config'
local menu = require 'ui/menu'

local total_time = 0
local frame_count = 0
local next_tick = 0

local framedump_canvas, framedump_dir

function love.load ()
   GAME = {}

   -- !!! -- you found the secret debug flags! -- !!! --
   GAME.debug = {
      disable_all                   = false,-- enable to disable all debug flags!
      fast_customize                = true, -- customize without waiting for meter
      instant_reload_palette        = true, -- press R in customize to reload palette
      endless_folder                = true, -- never remove chips from folder when used
      invincibility                 = true, -- player can't die
   }
   if GAME.debug.disable_all then
      GAME.debug = {}
   end

   GAME.tick_rate = 60
   GAME.size = point(512, 288)
   GAME.tick_period = 1/GAME.tick_rate

   GAME.input = input()
   GAME.scene = scene()

   GAME.chipdb = love.filesystem.load('chipdb.lua')()
   GAME.imgdb = love.filesystem.load('imgdb.lua')()

   GAME.fonts = {
      square = love.graphics.newFont('fonts/squrave.ttf', 32, 'none')
   }
   love.graphics.setFont(GAME.fonts.square)

   GAME.config = config()

   -- NOTE: this is done AFTER fonts so fonts can be smooth
   love.graphics.setDefaultFilter('nearest', 'nearest')

   if arg[2] == 'dump' then
      framedump_canvas = love.graphics.newCanvas(GAME.size:unpack())
      framedump_dir = '../framedump/' .. os.time()
      love.filesystem.createDirectory(framedump_dir)
   end

   GAME.scene:push(menu('title'))
end

function love.draw ()
   love.graphics.origin()
   love.graphics.scale(GAME.config.settings.game_scale,
                       GAME.config.settings.game_scale)
   GAME.scene:draw()
--   -- Memory usage
--   love.graphics.origin()
--   love.graphics.print(math.floor(collectgarbage('count')))
end

function love.update (dt)
   -- This loop forces the game to run at a fixed speed.
   total_time = total_time + dt
   while total_time > next_tick do
      next_tick = next_tick + GAME.tick_period
      GAME.scene:update()
      -- Frame dumping; frames are dumped at the actual tick rate.
      frame_count = frame_count + 1
      if framedump_dir then
         love.graphics.origin()
         framedump_canvas:renderTo(oop.bind_by_name(GAME.scene, 'draw'))
         local imgdata = framedump_canvas:newImageData()
         imgdata:encode('tga', framedump_dir .. frame_count .. '.tga')
      end
   end
end
