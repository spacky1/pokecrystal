; Audio interfaces.

_LoadMusicByte::
; [wCurMusicByte] = [a:de]
	ldh [hROMBank], a
	ld [rROMB], a

	ld a, [de]
	ld [wCurMusicByte], a
	ld a, BANK(LoadMusicByte)

	ldh [hROMBank], a
	ld [rROMB], a
	ret

PlayCry::
; Play cry de.

	push hl
	push de
	push bc
	push af

	ldh a, [hROMBank]
	push af

	; Cries are stuck in one bank.
	ld a, BANK(PokemonCries)
	ldh [hROMBank], a
	ld [rROMB], a

	ld hl, PokemonCries
rept MON_CRY_LENGTH
	add hl, de
endr

	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl

	ld a, [hli]
	ld [wCryPitch], a
	ld a, [hli]
	ld [wCryPitch + 1], a
	ld a, [hli]
	ld [wCryLength], a
	ld a, [hl]
	ld [wCryLength + 1], a

	ld a, BANK(_PlayCry)
	ldh [hROMBank], a
	ld [rROMB], a

	call _PlayCry

	pop af
	ldh [hROMBank], a
	ld [rROMB], a

	pop af
	pop bc
	pop de
	pop hl
	ret