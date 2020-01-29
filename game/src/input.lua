local oop = require 'src/oop'

local input = oop.class()

function input:init()
   self.joy_to_dpad_threshold = 0.5 -- currently uses a square hitbox
   self.keybinds = {
      a = 'x',     -- right button
      b = 'z',     -- left button
      l = 'a',     -- left trigger
      r = 's',     -- right trigger
      start = 'h', -- small center button (right side)
      option = 'g',-- small center button (left side)
      du = 'i',    -- dpad up
      dl = 'j',    -- dpad left
      dd = 'k',    -- dpad down
      dr = 'l',    -- dpad right
   }
   self.joybinds = {
      a = 'b',     -- switch xbox button order to nint*ndo!
      b = 'a',
      -- x and y are unused
      l = 'leftshoulder',
      r = 'rightshoulder',
      start = 'start',
      option = 'back',
      du = 'dpup',
      dd = 'dpdown',
      dl = 'dpleft',
      dr = 'dpright',
   }
   self.keys = {'a', 'b', 'l', 'r', 'start', 'option', 'du', 'dd', 'dl', 'dr'}
   self.buttons = {'a', 'b', 'l', 'r', 'start', 'option'}
   self.counts = {}
   for key,_ in pairs(self.joybinds) do
      self.counts[key] = 0
   end
   love.joystick.loadGamepadMappings('gamecontrollerdb.txt')
end

-- return true if an input is down/pressed
-- @key: which button/direction
function input:down (key)
   return self.counts[key] > 0
end

-- return the number of seconds a button has been held
-- please do not use == comparisons on this value!
-- @key: which button/direction
function input:seconds_down (key)
   return self.counts[key] / GAME.tick_rate
end

-- return true if an input went down on this frame
-- @key: which button/direction
function input:hit (key)
   return self.counts[key] == 1
end

-- return true if any button went down on this frame
function input:hit_any_button ()
   for _,button in ipairs(self.buttons) do
      if self.counts[button] == 1 then
         return true
      end
   end
end

-- after first press, repeat key after a certain delay
-- @key: which key
-- @delay: how many seconds until begins 'autofire'
-- @repeat_hz: freqency of repeating input
function input:hit_with_repeat (key, delay, repeat_hz)
   assert(delay and repeat_hz)
   local frames = self.counts[key]
   local delay_frames = math.floor(GAME.tick_rate * delay)
   local repeat_frames = math.floor(GAME.tick_rate / repeat_hz)
   assert(repeat_frames > 0, 'Cannot autofire faster than tick rate ', GAME.tick_rate)
   local held_time = frames - delay_frames
   return frames == 1 or (held_time > 0 and held_time % repeat_frames == 0)
end

function input:update()
   local joy = love.joystick.getJoysticks()[1]
   for _,key in ipairs(self.keys) do
      local joystick = joy and point(joy:getAxis(1), joy:getAxis(2))
      local down = love.keyboard.isScancodeDown(self.keybinds[key]) or
         (joy and joy:isGamepadDown(self.joybinds[key])) or
         (joy and key == 'dl' and joystick.x < -self.joy_to_dpad_threshold) or
         (joy and key == 'dr' and joystick.x >  self.joy_to_dpad_threshold) or
         (joy and key == 'du' and joystick.y < -self.joy_to_dpad_threshold) or
         (joy and key == 'dd' and joystick.y >  self.joy_to_dpad_threshold)
      self.counts[key] = down and self.counts[key]+1 or 0
   end
end

return input
