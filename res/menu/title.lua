local menu = require 'src/menu'

local world = require 'world/world'

local battle = require 'battle/battle'
local foldedit = require 'foldedit/editor'

local menu = {
   y = 40,
   spacing = 16,
   font = 'title',
   bg_img = 'title',
   {
      text = 'battle',
      a = function ()
         GAME.scene:push_fade({}, battle('test'))
      end,
   },
   {
      text = 'pvp',
      a = function ()
         GAME.scene:push_fade({}, battle('pvp'))
      end,
   },
   {
      text = 'folder editor',
      a = function ()
         GAME.scene:push_fade({}, foldedit('test-collection', 'test'))
      end,
   },
   {
      text = 'worldmap test',
      a = function ()
         local world = world.from_map_path('res/world/testmap/map1.lua')
         GAME.scene:push_fade({}, world)
      end,
   },
   {
      text = 'config',
      a = function ()
         GAME.scene:push_fade({}, menu('settings'))
      end,
   },
   {
      text = 'exit',
      a = love.event.quit
   },
}

return menu
