local sheet = {
   size = {x=50, y=60},
   img_size = {x=100, y=600},
   strips = {
      idle = {
	 pos = {x=0, y=0},
	 num = 2,
      },
      move = {
	 pos = {x=0, y=60},
	 num = 2,
      },
      shoot = {
	 pos = {x=0, y=120},
	 num = 1,
      }
   }
}

local anim = {
   idle = {
      timing = {5,5},
      loop = true,
   },
   move = {
      timing = {5,5},
   },
   shoot = {
      timing = {10},
   }
}

return {
   sheet = Sheet.new(sheet)
   anim = Animation.new(anim)
}
