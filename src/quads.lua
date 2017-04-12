local sheet = function (x, y, w, h, numx, numy, iw, ih)
   local quads = {}

   numy = numy or 1
   local offy = y

   for iy=1,numy do
      local offx = x
      quads[iy] = {}
      for ix=1,numx do
         quads[iy][ix] = love.graphics.newQuad(
            offx, offy, w, h, iw, ih
         )
         offx = offx + w
      end
      offy = offy + h
   end

   return quads
end

return {
   sheet=sheet,
   multi_sheet = function (multi_sheet)
      local w,h = multi_sheet.img:getDimensions()
      local out = {}
      for k,v in pairs(multi_sheet) do
         if k=="img" then goto continue end
         out[k] = sheet(v[1], v[2], v[3], v[4], (v[5] or 1), (v[6] or 1), w, h)
         if (v[5] or 1) == 1 then out[k] = out[k][1] end
         if (v[6] or 1) == 1 then out[k] = out[k][1] end
         ::continue::
      end
      return out
   end,
}
