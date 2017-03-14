local bg, bgquad
local bgsize
local offset

return {
   start = function (newbg)
      offset = 0
      bg = love.graphics.newImage(PATHS.bg .. newbg .. ".png")
      bg:setWrap("repeat", "repeat")
      bgsize = bg:getDimensions()
      bgquad = love.graphics.newQuad(
	 0, 0, GAME.width+bgsize, GAME.height+bgsize,
	 bgsize, bgsize
      )
   end,

   draw = function ()
      offset = offset + 0.5
      local bgoff = offset % bgsize - bgsize
      love.graphics.draw(bg, bgquad, math.floor(bgoff-0.5), math.floor(bgoff))
   end,
}
