local ai = require "battle/ai"
local ents = require "battle/ents"
local chip = require "battle/chip_wrangler"
local chip_artist = require "battle/chip_artist"

local class = {
   tangible = true,
   size = 0.4,
   states = {
      idle = {row = 1, anim = {1}, speed = 1000, iasa = 0},
      shoot = {row = 3, anim = {1,2}, speed = 10, length = 2},
      throw = {row = 4, anim = {1,2}, speed = 10, length = 2},
      move = {
         row = 2, anim = {1,2}, speed = 3.5, length = 5, iasa = 3,
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
         sheet = {0,0,50,60,2,6},
         ox = 24, oy = 54,
         hp = 300, hide_hp = true,
         act = function (self, input)
            if not input then return end
            input = self.side=="left" and input[1] or input[2]

            if input.l==1 or input.r==1 then
               self.selectchips = true
               return
            end
            local move = function  (dx, dy)
               local goalx, goaly = self.x+dx, self.y+dy
               if ai.is_panel_free(goalx, goaly, self.side) then
                  self.goalx, self.goaly = goalx, goaly
                  self.enter_state = "move"
               end
            end
            local lr = input.dr - input.dl
            local ud = input.dd - input.du

            if input.a > 0 and input.a < 5  then chip.queue_use(self)
            elseif ud<0 then move(0, -1)
            elseif ud>0 then move(0, 1)
            elseif lr<0 then move(-1, 0)
            elseif lr>0 then move(1, 0)
            end
         end,
      }
   }
}
