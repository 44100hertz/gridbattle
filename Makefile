TMXMAPS:=$(wildcard game/world/maps/*/*.tmx)
LUAMAPS:=$(patsubst %.tmx,%.lua,$(TMXMAPS))

all: maps gridbattle.love

run: maps
	cd game/; love .

maps: $(LUAMAPS)

maps/*/%.lua: %.tmx
	tiled --export-map $< $@

gridbattle.love: $(shell find game/)
	cd game/; zip -r ../$@ .

.PHONY: all run maps
