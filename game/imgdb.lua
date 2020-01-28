--[[
   Image database: for multiple frames inside of sprite sheets, and animations

   Normal fields are:
       rect: {x,y,w,h} rectangle use from image (default whole image)
             for sprite/tile sheets, this is the upper-left corner.
       origin: {x, y} center of image; how far to offset when drawing
       count: {columns, rows} how many frames in a sprite/tile sheet
       anim: Animation. These fields are needed:
           fps: <number> framerate of animation
           order: <list> Frame order. 1 is the first frame

   -- The sheet named 'base' will be used by default --
--]]

return {
   foldedit = {
      icons = {rect={0,0,16,16}, count={2,7}},
      fg = {rect={32,0,224,160},},
   },
   customize = {
      bg = {rect={0,0,120,160}},
      chipbg = {rect={0,160,16,16}, count={6,1}},
      letter = {rect={0,176,16,8}, count={5,1}},
      button = {rect={0,184,16,16}, count={3,1}},
   },
   chip = {
      icon = {rect={0,0,16,16}},
      art = {rect={0,16,64,72}},
   },

   ['battle/ui' ]= {
      bar = {rect={0,0,8,8}, count={3,1}},
   },
   ['battle/results'] = {
      base = {rect={0,0,240,160}, count={2,1}}
   },
   ['battle/start'] = {
      base = {rect={0,0,240,160}, origin={120,80}}
   },
   ['battle/actors/bullet'] = {
      base = {rect={0,0,16,16}, origin={8,8}, count={6,1}, anim = {order={1,2,3,4,5,6}, fps=20}},
   },
   ['battle/actors/boots'] = {
      base = {rect={0,0,24,16}, origin={11,7}, count={2,1}},
   },
   ['battle/actors/dustball'] = {
      base = {rect={0,0,40,40}, origin={20,20}},
   },
   ['battle/actors/wheel_crate'] = {
      base = {rect={0,0,45,60}, origin={17,45}}
   },
   ['battle/actors/poisdrop'] = {
      base = {rect={0,0,16,16}, origin={8,7}}
   },
   ['battle/actors/testenemy'] = {
      base = {rect={0,0,50,60}, origin={22,30}, scale={1,0.5}}
   },
   ['battle/actors/testenemy2'] = {
      base = {rect={0,0,50,60}, origin={22,30}, scale={1,0.5}}
   },
   ['battle/actors/ben'] = {
      base = {rect={0,0,50,60}, origin={24,31}, scale={1,0.5}},
      move = {rect={0,60,50,60}, origin={24,31}, count={2,1}, scale={1,0.5}, anim={fps=20, order={1,2}}},
      shoot = {rect={0,120,50,60}, origin={24,31}, count={2,1}, scale={1,0.5}, anim={fps=20, order={1,2}}},
      throw = {rect={0,180,50,60}, origin={24,31}, count={2,1}, scale={1,0.5}, anim={fps=20, order={1,2}}},
   },
}
