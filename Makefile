all: music sfx cries

music: crystal_music.gbs

sfx: crystal_sfx.gbs

cries: crystal_cries.gbs

mus_obj := \
audio_MUS.o \
home/audio_MUS.o \
main_MUS.o \
ram/wram_MUS.o

sfx_obj := \
audio_SFX.o \
home/audio_SFX.o \
main_SFX.o \
ram/wram_SFX.o

cries_obj := \
audio_CRY.o \
home/audio_CRY.o \
main_CRY.o \
ram/wram_CRY.o

RGBASMFLAGS = -Weverything -Wtruncation=0 -I. -P includes.asm

clean:
	powershell -NoProfile -Command "Get-ChildItem -Recurse -Include *.o,*.sym,*.map,*.gbs | Remove-Item -Force -ErrorAction SilentlyContinue"

tidy:
	powershell -NoProfile -Command "Get-ChildItem -Recurse -Include *.o,*.sym,*.map,*.raw | Remove-Item -Force -ErrorAction SilentlyContinue"

%.gbs: %.gbs.raw
	powershell -NoProfile -ExecutionPolicy Bypass -File truncate_gbs.ps1 $< $@

crystal_music.gbs.raw: $(mus_obj)
	rgblink -n crystal.sym -m crystal.map -l layout.link -p 0 -o $@ $(mus_obj)

crystal_sfx.gbs.raw: $(sfx_obj)
	rgblink -n crystal_sfx.sym -m crystal_sfx.map -l layout.link -p 0 -o $@ $(sfx_obj)

crystal_cries.gbs.raw: $(cries_obj)
	rgblink -n crystal_cries.sym -m crystal_cries.map -l layout.link -p 0 -o $@ $(cries_obj)

%_MUS.o: %.asm
	rgbasm -D_MUSIC $(RGBASMFLAGS) -o $@ $<

%_SFX.o: %.asm
	rgbasm -D_SFX $(RGBASMFLAGS) -o $@ $<

%_CRY.o: %.asm
	rgbasm -D_CRY $(RGBASMFLAGS) -o $@ $<

home/audio_MUS.o: home.asm
	rgbasm -D_MUSIC $(RGBASMFLAGS) -o $@ $<

home/audio_SFX.o: home.asm
	rgbasm -D_SFX $(RGBASMFLAGS) -o $@ $<

home/audio_CRY.o: home.asm
	rgbasm -D_CRY $(RGBASMFLAGS) -o $@ $<

ram/wram_MUS.o: ram.asm
	rgbasm -D_MUSIC $(RGBASMFLAGS) -o $@ $<

ram/wram_SFX.o: ram.asm
	rgbasm -D_SFX $(RGBASMFLAGS) -o $@ $<

ram/wram_CRY.o: ram.asm
	rgbasm -D_CRY $(RGBASMFLAGS) -o $@ $<
