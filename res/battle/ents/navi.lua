local ai = require "battle/ai"
local ents = require "battle/ents"
local chip = require "battle/chip_wrangler"
local chip_artist = require "battle/chip_artist"

local class = {
   tangible = true,
   size = 0.4,
   states = {
      move = function (self)
         if not ai.is_panel_free(self.goalx, self.goaly, self.side) then
            self.enter_state = base
         end
         if self.time == 5 then
            self.x, self.y = self.goalx, self.goaly
         end
      end,
   },
}

return {
   class = class,
   variants = {
      player = {
         img = "ben",
         hp = 300, hide_hp = true,
         act = function (self, input)
            if not input then return end
            input = self.side=="left" and input[1] or input[2]

            self.selectchips = input.l>0 or input.r>0
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
