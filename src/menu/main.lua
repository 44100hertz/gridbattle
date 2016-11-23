local input = require "input"
local fonts = require "fonts"

local mod, current, sel
local bg

return {
   start = function (lastmod, root, bg)
      mod = lastmod
      current = root
      sel = current[1]
   end,

   update = function ()
      if input.du == 1 and sel.u then
	 sel = current[sel.u]
      elseif input.dd == 1 and sel.d then
         sel = current[sel.d]
      elseif input.dl == 1 and sel.l then
         sel = current[sel.l]
      elseif input.dr == 1 and sel.r then
         sel = current[sel.r]
      elseif input.a == 1 and sel.a then
	 sel.a()
      end
   end,

   draw = function ()
      if lastmod then lastmod.draw() end
      if bg then love.graphics.draw(bg) end

      love.graphics.circle("fill", sel.x-20, sel.y, 8)
      for _,v in ipairs(current) do
         love.graphics.setFont(fonts.std15)
         love.graphics.print(v.text, v.x, v.y)
      end
   end,
}
