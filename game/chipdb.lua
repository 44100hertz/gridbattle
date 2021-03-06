-- All the chips in the game. Can be indexed by chipdb[index], or
-- chipdb[chip_name].

local chipdb = {
   {
      name = 'Triangle',
      info = 'Shoot out some triangle.',
      element = 'wood',
      damage = 80,
      class = 'triangle',
   },
   {
      name = 'Boots',
      info = 'Fire off a pair of boots.',
      element = 'wood',
      damage = 40,
      class = 'boots',
   },
   {
      name = 'WhlCrate',
      info = 'Damage makes it roll.',
      element = 'fire',
      damage = 40,
      class = 'wheel_crate',
   },
   {
      name = 'PoisDrop',
      info = 'Poison 3 spaces ahead.',
      element = 'water',
      class = 'poison_drop',
   },
   {
      name = 'HeavyBall',
      info = 'Break 3 spaces ahead.',
      class = 'heavy_ball',
   },
}

-- generate indexing by name
for i,chip in ipairs(chipdb) do
  chip.index = i
  chipdb[chip.name] = chip
end

return chipdb
