-- Actors send data to the game by setting their own variables. Many
-- enable or disable functionality, and so are grouped with other
-- requirements.

-- Example state --
local states = {}
states.doathing = { -- Example state with several properties
   anim = {row=1, 1,1,2,3,4,5}, -- which frames to play
   speed = 20, -- run anim at 20fps (default)
   iasa = 5, -- run "act" each frame after this
   poise = 2, -- frames of vulnerable startup
   act = function (self) end -- optional function to run during state
}
states.die = { -- Automatically enter this state on death
}

actor = {
   -- Graphical --
   img = "res/img/cool.jpg", -- image from which to make sheet
   shadow = { -- optional
      img="res/img/shadow.jpg",
      ox = 25, oy = 25, -- shadow origin
   }
   new_sheet =  -- tells the game to load this sheet
      {0,0,50,60,2,2}, -- xoff, yoff, xsize, ysize, numx, numy
   height = 20, -- used for stacking, etc.
   ox = 5, oy = 5 -- X and Y origin of the sprite; the center of where they stand

   -- Functional --
   max_hp=200, -- set if this actor has HP.
   hide_hp = nil,
   hbox = 1, -- single-square hitbox
   tangible = true, -- occupy physical space, panel
   group = "enemy" -- collision group
   collide = function (self, with) end, -- extra stuff to run on collision

   -- Generally readonly vars --
   hp=200,

   start = function (self) end, -- optional; when actor is initialized
   act = function (self) end, -- optional; run when actionable
   draw = function (self) end, -- optional; draw extra things

   states = states, -- states redefined here so that they can cross-reference
}

