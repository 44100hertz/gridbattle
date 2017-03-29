local ai = require "battle/ai"
local ents = require "battle/ents"
local chip = require "battle/chip_wrangler"
local chip_artist = require "battle/chip_artist"

local class = {
   tangible = true,
   size = 0.4,
   states = {
      idle = {row = 0, anim = {0}, speed = 1000, iasa = 0},
      shoot = {row = 2, anim = {0,1}, speed = 10, length = 2},
      throw = {row = 3, anim = {0,1}, speed = 10, length = 2},
      move = {
         row = 1, anim = {0,1}, speed = 3.5, length = 5, iasa = 3,
         act = function (self)
            if not ai.is_panel_free(self.goalx, self.goaly, self.side) then
               self.enter_state = idle
            end
            if self.time == 5 then
               self.x, self.y = self.goalx, self.goaly
            end
         end,
      },
   },
}

return {
   class = class,
   variants = {
      player = {
         img = "ben",
         w=50, h=60,
         ox = 24, oy = 54,
         hp = 300, hide_hp = true,
         act = function (self, input)
            if not input then return end
            input = self.side=="left" and input[1] or input[2]

            self.selectchips = input.l or input.r
            local move = function  (dx, dy)
               local goalx, goaly = self.x+dx, self.y+dy
               if ai.is_panel_free(goalx, goaly, self.side) then
                  self.goalx, self.goaly = goalx, goaly
                  self.enter_state = "move"
               end
            end
            if input.a and input.a < 5  then chip.queue_use(self)
            elseif input.du then move(0, -1)
            elseif input.dd then move(0, 1)
            elseif input.dl then move(-1, 0)
            elseif input.dr then move(1, 0)
            end
         end,
      }
   }
}
