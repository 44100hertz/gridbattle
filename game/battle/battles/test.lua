return {
   stage = {
      turf = {3,3,3},
   },
   sides = {
      {
         is_player = true,
         {'player', 2, 2},
      },
      {
         {'test_enemy', 4, 1, level=1},
         {'test_enemy', 4, 3, level=1},
         {'test_enemy', 6, 1, level=2},
         {'test_enemy', 6, 3, level=2},
      },
   },
   bg = {'scroll', 'acid'},
}
