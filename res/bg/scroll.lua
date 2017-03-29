local bg, bgquad
local bgsize
--local start_time
local rdr = _G.RDR

return {
   start = function (newbg)
--      start_time = love.timer.getTime()
--      bg = love.graphics.newImage(PATHS.bg .. newbg .. ".png")
--      bg:setWrap("repeat", "repeat")
--      bgsize = bg:getDimensions()
      -- bgquad = love.graphics.newQuad(
      --    0, 0, GAME.width+bgsize, GAME.height+bgsize,
      --    bgsize, bgsize
      -- )
   end,

   draw = function ()
      -- local offset = love.timer.getTime() - start_time
      -- local bgoff_y = offset*30 % bgsize - bgsize
      -- local bgoff_x = (offset + math.sin(offset))*30 % bgsize - bgsize
      -- love.graphics.draw(bg, bgquad, math.floor(bgoff_x), math.floor(bgoff_y))
      rdr:setDrawColor(0x0)
      rdr:clear()
   end,
}
