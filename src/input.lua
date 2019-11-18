local oop = require 'src/oop'

local input = {}
local joy_to_dpad_threshold = 0.5

love.joystick.loadGamepadMappings('res/gamecontrollerdb.txt')

function input.new()
   local self = oop.instance(input, {})
   self.keybinds = {
      {
         a='x', b='z',
         l='a', r='s',
         st='h', sel='g', -- Left player
         du='i', dd='k',
         dl='j', dr='l',
      },
      {
         a='right', b='down',
         l='left', r='up',
         st='kpenter', sel='kp+', -- Right player
         du='kp8', dd='kp5',
         dl='kp4', dr='kp6',
      }
   }
   self.joybinds = {
      {
         a='b', b='a',
         l='leftshoulder', r='rightshoulder',
         st='start', sel='back',
         du='dpup', dd='dpdown',
         dl='dpleft', dr='dpright',
      },
      {
         a='b', b='a',
         l='leftshoulder', r='rightshoulder',
         st='start', sel='back',
         du='dpup', dd='dpdown',
         dl='dpleft', dr='dpright',
      },
   }
   self.counts = {}
   for i = 1,2 do
      self.counts[i] = {}
      for key,_ in pairs(self.joybinds[1]) do
         self.counts[i][key] = 0
      end
   end
   return self
end

function input:update()
   local joys = love.joystick.getJoysticks()
   for i = 1,2 do
      for key,_ in pairs(self.joybinds[1]) do
         local lr = joys[i] and joys[i]:getAxis(1) or 0
         local ud = joys[i] and joys[i]:getAxis(2) or 0
         local down = love.keyboard.isScancodeDown(self.keybinds[i][key]) or
            (joys[i] and joys[i]:isGamepadDown(self.joybinds[i][key])) or
            (key=='dl' and lr < -joy_to_dpad_threshold) or
            (key=='dr' and lr > joy_to_dpad_threshold) or
            (key=='du' and ud < -joy_to_dpad_threshold) or
            (key=='dd' and ud > joy_to_dpad_threshold)
         self.counts[i][key] = down and self.counts[i][key]+1 or 0
      end
   end
   return self.counts
end

return input
