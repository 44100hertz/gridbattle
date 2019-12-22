TMXMAPS:=$(wildcard game/world/maps/*/map.tmx)
LUAMAPS:=$(patsubst %.tmx,%.lua,$(TMXMAPS))

run: all
	cd game/; love .

all: $(LUAMAPS)

%map.lua: %map.tmx
	tiled --export-map $< $@

.PHONY: all run
