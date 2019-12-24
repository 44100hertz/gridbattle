return {
   stage = {
      turf = {3,3,3},
   },
   sides = {
      {
         is_player = true,
         {'player', x=2, y=2},
      },
      {
         {'test_enemy', level=1, x=4, y=1},
         {'test_enemy', level=1, x=4, y=3},
         {'test_enemy', level=2, x=6, y=1},
         {'test_enemy', level=2, x=6, y=3},
      },
   },
   bg = {'scroll', 'acid'},
}
