TMXMAPS:=$(wildcard game/world/maps/*/map.tmx)
LUAMAPS:=$(patsubst %.tmx,%.lua,$(TMXMAPS))

all: maps gridbattle.love

run: maps
	cd game/; love .

maps: $(LUAMAPS)

%map.lua: %map.tmx
	tiled --export-map $< $@

gridbattle.love: $(shell find game/)
	cd game/; zip -r ../$@ .

.PHONY: all run
