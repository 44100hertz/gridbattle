local bg, bgquad
local bgsize

return {
   start = function (newbg)
      bg = newbg
      bg:setWrap("repeat", "repeat")
      bgsize = bg:getDimensions()
      bgquad = love.graphics.newQuad(
	 0, 0, gamewidth+bgsize, gameheight+bgsize,
	 bgsize, bgsize
      )
   end,

   draw = function ()
      local bgoff = love.timer.getTime() * 30 % bgsize - bgsize
      love.graphics.draw(bg, bgquad, math.floor(bgoff-0.5), math.floor(bgoff))
   end,
}
