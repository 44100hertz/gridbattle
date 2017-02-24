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
   new_sheet =  -- tells the game to load this sheet
      {0,0,50,60,2,2}, -- xoff, yoff, xsize, ysize, numx, numy
   h=20, -- height; used for stacking, etc.
   ox=5, oy=5 -- X and Y origin of the sprite; the center of where they stand

   -- Functional --
   hp=200, -- set if this actor has HP
   hide_hp = nil,
   hbox = 1, -- single-square hitbox
   tangible = true, -- occupy physical space, panel

   init = function (self) end, -- when actor is initialized ingame
   act = function (self) end, -- run during idle state and interruptability

   states = states, -- states redefined here so that they can cross-reference
}

