assert "sheet"
assert "stage"

Actor.mt = {
   init = function ()
      self.update = idle_init
      self.img = love.graphics.newImage(imgString)
      self.frames = sheet.generate(50, 60, 1, 5, self.img:getDimensions())
      self.frame = self.frames[1]
      self.origin = {25, 57}
      self.pos_x = stage.position(stagePos)
      self.hp = self.hp_max
   end

   draw = function ()
      love.graphics.draw(self.img, self.frame,
			 unpack(self.pos), 0, 1, 1, unpack(self.origin))
   end
}

Actor.prototype = {
   imgString = "ben.png"
   stage_x = 2, stage_y = 2,
   posx = 0, posy = 0,
   side = 0
   hp_max = 0, hp = 0
   new = function (o)
	 o = o or {}
	 setmetatable(o, self)
	 self.HP = HPmax
	 self.__index = self
	 posx, posy = stage.position(stage_x, stage_y)
	 return o
   end
}

Actor.mt.__index = function (table, key)
   return Actor.prototype[key]
end
