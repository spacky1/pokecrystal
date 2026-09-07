SECTION "Header", ROM0
    db "GBS"    ; magic number
    db 1        ; spec version

    ; # of songs
    IF DEF(_MUSIC)
    	db NUM_MUSIC_SONGS - 1
    ENDC
    IF DEF(_SFX)
    	db NUM_SFX - 1
    ENDC
    IF DEF(_CRY)
    	db NUM_POKEMON
    ENDC

    db 1        ; first song
    dw _load     ; load address
    dw _init     ; init address
    dw _play     ; play address
    dw wStackTop    ; stack
    db 0        ; timer modulo
    db 0        ; timer control

SECTION "Title", ROM0
    db "Pokémon Crystal"

SECTION "Author", ROM0
    db "Junichi Masuda"

SECTION "Copyright", ROM0
    db "2001 Gamefreak, Nintendo"

SECTION "GBS Code", ROM0
_load::
_init::
    push af
    call _InitSound

    ; set stereo flag
    ld a, [wOptions]
    set 5, a ; set STEREO, a
    ld [wOptions], a

    ; music ID (a) -> de
    pop af
    ld d, 0

    IF DEF(_MUSIC)
    	inc a
    ENDC

    ld e, a

    IF DEF(_MUSIC)
    	jp _PlayMusic
    ENDC
    IF DEF(_SFX)
    	jp _PlaySFX
    ENDC
    IF DEF(_CRY)
        ld a, $FF
        ld [wCryTracks], a
        jp PlayCry
    ENDC

_play::
    jp _UpdateSound
