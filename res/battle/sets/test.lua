return {
   stage = {
      turf = {3,3,3},
   },
   sides = {
      {
         is_player = true,
         {name='player', x=2, y=2},
      },
      {
         {name='test_enemy', level=1, x=4, y=1},
         {name='test_enemy', level=1, x=4, y=3},
         {name='test_enemy', level=2, x=6, y=1},
         {name='test_enemy', level=2, x=6, y=3},
      },
   },
   bg='scroll',
   bg_args={'test'},
}
