local scene = require 'src/scene'
local world = require 'world/world'
local battle = require 'battle/battle'

return {
   y = 40, spacing = 16,
   font = 'title',
   bg_img = 'title',
   {'battle',
    a = function ()
       scene.push_fade({}, battle.new('test'))
   end},
   {'pvp',
    a = function ()
       scene.push_fade({}, battle.new('pvp'))
   end},
   {'folder editor',
    a = function ()
       scene.push_fade({}, require 'foldedit/editor',
          'test-collection', 'test')
   end},
   {'worldmap test',
    a = function ()
       local world = world.from_map_path('res/world/testmap/map1.lua')
       scene.push_fade({}, world)
   end},
   {'config',
    a = function ()
       scene.push_fade({}, (require 'src/menu').new('settings'))
   end},
   {'exit', a = love.event.quit},
}
