local heavy_ball = {}

function heavy_ball:init ()
   self.lifespan = 10
   self:spawn{class = 'throw_animation', offset = point(3,0)}
end

function heavy_ball:land ()
   self.battle:break_panel(self.pos)
end

function heavy_ball:draw ()
   love.graphics.setColor(0,0,0)
   local x, y = self:screen_pos():unpack()
   love.graphics.circle('fill', x, y, 8 * self:depth_scale())
   love.graphics.setColor(1,1,1)
end

return heavy_ball
