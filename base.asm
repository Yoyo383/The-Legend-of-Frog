IDEAL
MODEL small
P186
STACK 100h

; buffer for double buffering (the thing that makes it not flicker)
segment SCREEN
	db 64000 dup(?)
ends SCREEN

DATASEG
	tilesetFilename db "tileset.bmp", 0
	minimapFilename db "mini.bmp", 0
	mainMenuFilename db "main.bmp", 0
	loseScreenFilename db "lose.bmp", 0
	winScreenFilename db "win.bmp", 0
	storyScreenFilename db "story.bmp", 0
	creditsScreenFilename db "credits.bmp", 0

	fileErrorMsg db "couldn't open file.", 13, 10, '$'

	screenLine db 320 dup(?)

	musicFilename db "zelda.imf", 0
	musicSize equ 8748
	music db musicSize dup(?)

	noteCount dw 0
	currentNoteCount dw 0
	noteIndex dw 0
	
	minimap db 6912 dup(?)
	tileset db 4096 dup(?)
	
	header db 54 dup(?)
	palette db 1024 dup(?)
	
	x dw 160
	y dw 100
	playerDirection db 2 ; 0 - up, 1 - left, 2 - down, 3 - right
	isMoving db 0
	playerFrame db 0
	frameTimer db 0

	isHurt db 0
	hurtTimer db 0

	isAttacking db 0
	swordX dw 0
	swordY dw 0
	
	gold db 0
	diamond db 0
	ruby db 0
	health db 120
	
	armorPoints db 0
	swordPoints db 0
	ringPoints db 0
	
	enemiesAlive db 42
	enemiesMovementCount db 0
	enemiesCountPerScreen db 1, 3, 0, 1, 2, 2
						  db 2, 1, 0, 2, 0, 1
						  db 0, 2, 0, 1, 0, 1
						  db 1, 1, 2, 1, 2, 0
						  db 0, 1, 1, 2, 2, 2
						  db 1, 0, 0, 2, 3, 2
	; x, y, direction, health, hurt timer, is hurt (12 bytes)
	enemies dw 144, 72, 0, 40, 0, 0

			dw 32, 24, 0, 40, 0, 0
			dw 32, 80, 0, 40, 0, 0
			dw 230, 88, 0, 40, 0, 0

			dw 160, 110, 0, 40, 0, 0

			dw 48, 88, 0, 40, 0, 0
			dw 250, 104, 0, 40, 0, 0

			dw 24, 72, 0, 40, 0, 0
			dw 40, 72, 0, 40, 0, 0

			dw 64, 80, 0, 40, 0, 0
			dw 160, 24, 0, 40, 0, 0

			dw 48, 48, 0, 40, 0, 0

			dw 248, 72, 0, 40, 0, 0
			dw 72, 24, 0, 40, 0, 0

			dw 40, 72, 0, 40, 0, 0

			dw 176, 24, 0, 40, 0, 0
			dw 120, 72, 0, 40, 0, 0

			dw 40, 88, 0, 40, 0, 0

			dw 88, 88, 0, 40, 0, 0

			dw 168, 24, 0, 40, 0, 0

			dw 56, 24, 0, 40, 0, 0

			dw 40, 96, 0, 40, 0, 0
			dw 240, 72, 0, 40, 0, 0

			dw 56, 56, 0, 40, 0, 0

			dw 144, 24, 0, 40, 0, 0
			dw 32, 80, 0, 40, 0, 0

			dw 120, 80, 0, 40, 0, 0

			dw 72, 72, 0, 40, 0, 0

			dw 136, 88, 0, 40, 0, 0
			dw 240, 56, 0, 40, 0, 0

			dw 88, 32, 0, 40, 0, 0
			dw 72, 88, 0, 40, 0, 0

			dw 96, 8, 0, 40, 0, 0
			dw 216, 80, 0, 40, 0, 0

			dw 200, 40, 0, 40, 0, 0

			dw 112, 48, 0, 40, 0, 0
			dw 272, 24, 0, 40, 0, 0

			dw 160, 40, 0, 40, 0, 0
			dw 24, 64, 0, 40, 0, 0
			dw 88, 16, 0, 40, 0, 0

			dw 96, 24, 0, 40, 0, 0
			dw 208, 40, 0, 40, 0, 0
	
	currentScreen db 2

	; structured in a way that the first byte is how many of the tile, and the second byte is the tile
	map db 149, 15h, 11, 10h, 25, 15h, 15, 10h, 17, 15h, 23, 10h, 16, 15h, 24, 10h, 15, 15h, 25, 10h, 14, 15h
		db 13, 10h, 7, 12h, 6, 10h, 12, 15h, 15, 10h, 7, 12h, 6, 10h, 11, 15h, 16, 10h, 7, 12h, 6, 10h, 10, 15h
		db 18, 10h, 6, 12h, 6, 10h, 8, 15h, 32, 10h, 7, 15h, 33, 10h, 7, 15h, 33, 10h

		db 120, 15h, 13, 10h, 27, 15h, 19, 10h, 21, 15h, 23, 10h, 17, 15h, 24, 10h, 16, 15h, 28, 10h, 12, 15h
		db 30, 10h, 10, 15h, 31, 10h, 9, 15h, 32, 10h, 8, 15h, 33, 10h, 7, 15h, 35, 10h, 5, 15h, 36, 10h, 4, 15h
		db 36, 10h, 4, 15h
		
		db 255, 15h, 114, 15h, 25, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h
		db 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 6, 15h
		
		db 255, 15h, 168, 15h, 17, 10h, 16, 15h, 13, 10h, 1, 14h, 3, 10h, 1, 14h, 6, 10h, 3, 15h, 22, 10h
		db 1, 14h, 10, 10h, 1, 14h, 3, 10h, 3, 15h, 37, 10h, 3, 15h, 37, 10h
		
		db 255, 15h, 63, 15h, 2, 10h, 36, 15h, 4, 10h, 35, 15h, 16, 10h, 23, 15h, 2, 10h, 2, 12h, 16, 10h
		db 18, 15h, 3, 10h, 3, 12h, 17, 10h, 15, 15h, 5, 10h, 3, 12h, 19, 10h, 12, 15h, 28, 10h, 12, 15h, 11, 10h
		
		db 247, 15h, 4, 10h, 29, 15h, 4, 10h, 2, 15h, 6, 10h, 28, 15h, 12, 10h, 28, 15h, 13, 10h, 27, 15h
		db 13, 10h, 27, 15h, 14, 10h, 26, 15h, 15, 10h, 25, 15h, 15, 10h, 25, 15h, 15, 10h, 25, 15h
		
		db 7, 15h, 33, 10h, 7, 15h, 33, 10h, 6, 15h, 34, 10h, 6, 15h, 26, 10h, 1, 14h, 7, 10h, 6, 15h, 8, 10h, 3, 11h
		db 17, 10h, 1, 14h, 5, 10h, 5, 15h, 9, 10h, 4, 11h, 12, 10h, 1, 14h, 5, 10h, 1, 14h, 3, 10h, 5, 15h, 9, 10h
		db 4, 11h, 9, 10h, 1, 14h, 5, 10h, 1, 14h, 6, 10h, 5, 15h, 9, 10h, 4, 11h, 22, 10h, 4, 15h, 11, 10h, 3, 11h
		db 12, 10h, 1, 14h, 9, 10h, 4, 15h, 22, 10h, 1, 14h, 1, 10h, 1, 14h, 2, 10h, 1, 14h, 8, 10h, 4, 15h, 36, 10h
		db 3, 15h, 26, 10h, 1, 14h, 10, 10h, 3, 15h, 37, 10h, 3, 15h, 37, 10h, 3, 15h, 37, 10h
		
		db 36, 10h, 4, 15h, 36, 10h, 4, 15h, 37, 10h, 3, 15h, 38, 10h, 2, 15h, 38, 10h, 2, 15h, 38, 10h, 2, 15h, 26, 10h
		db 4, 13h, 9, 10h, 1, 15h, 26, 10h, 4, 13h, 9, 10h, 1, 18h, 26, 10h, 3, 13h, 10, 10h, 1, 19h, 39, 10h, 1, 15h
		db 39, 10h, 1, 15h, 38, 10h, 2, 15h, 38, 10h, 2, 15h, 37, 10h, 3, 15h, 36, 10h, 4, 15h
		
		db 9, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h
		db 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah
		db 23, 1Bh, 1, 1Ah, 6, 15h, 9, 18h, 24, 1Bh, 1, 1Ah, 6, 15h, 9, 19h, 24, 1Bh, 1, 1Ah, 15, 15h, 1, 1Ah, 23, 1Bh
		db 1, 1Ah, 15, 15h, 1, 1Ah, 24, 1Bh, 6, 18h, 9, 15h, 1, 1Ah, 24, 1Bh, 6, 19h, 9, 15h, 3, 1Ah, 2, 1Bh, 20, 1Ah
		db 2, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 22, 15h
		db 1, 16h, 1, 17h, 2, 15h
		
		db 3, 15h, 37, 10h, 3, 15h, 37, 10h, 4, 15h, 36, 10h, 4, 15h, 26, 10h, 3, 11h, 7, 10h, 4, 15h, 26, 10h, 3, 11h
		db 7, 10h, 4, 15h, 26, 10h, 3, 11h, 7, 10h, 4, 15h, 26, 10h, 2, 11h, 8, 10h, 4, 15h, 15, 10h, 1, 14h, 2, 10h
		db 1, 14h, 17, 10h, 5, 15h, 5, 10h, 2, 12h, 4, 10h, 1, 14h, 23, 10h, 5, 15h, 4, 10h, 3, 12h, 9, 10h, 1, 14h
		db 18, 10h, 5, 18h, 3, 10h, 4, 12h, 6, 10h, 1, 14h, 21, 10h, 5, 19h, 3, 10h, 3, 12h, 29, 10h, 6, 15h, 34, 10h
		db 6, 15h, 34, 10h, 7, 15h, 33, 10h
		
		db 17, 10h, 12, 15h, 29, 10h, 11, 15h, 31, 10h, 9, 15h, 15, 10h, 5, 13h, 11, 10h, 9, 15h, 15, 10h, 6, 13h
		db 10, 10h, 9, 15h, 14, 10h, 7, 13h, 10, 10h, 9, 15h, 3, 10h, 1, 13h, 10, 10h, 7, 13h, 9, 10h, 11, 15h, 5, 10h
		db 1, 13h, 9, 10h, 3, 13h, 10, 10h, 12, 15h, 3, 10h, 1, 13h, 3, 10h, 1, 13h, 20, 10h, 12, 18h, 28, 10h, 12, 19h
		db 2, 10h, 1, 13h, 1, 10h, 1, 13h, 22, 10h, 13, 15h, 7, 10h, 1, 13h, 19, 10h, 13, 15h, 4, 10h, 1, 13h, 21, 10h
		db 14, 15h, 25, 10h, 15, 15h, 24, 10h, 17, 15h, 9, 10h

		db 15, 10h, 25, 15h, 15, 10h, 25, 15h, 16, 10h, 24, 15h, 16, 10h, 24, 15h, 7, 10h, 4, 11h, 5, 10h, 24, 15h
		db 7, 10h, 4, 11h, 5, 10h, 24, 15h, 7, 10h, 4, 11h, 5, 10h, 24, 15h, 16, 10h, 24, 15h, 15, 10h, 25, 15h, 15, 10h
		db 25, 15h, 15, 10h, 25, 15h, 14, 10h, 26, 15h, 13, 10h, 27, 15h, 12, 10h, 28, 15h, 11, 10h, 29, 15h

		db 3, 15h, 37, 10h, 3, 15h, 37, 10h, 3, 15h, 37, 10h, 3, 15h, 37, 10h, 3, 15h, 13, 10h, 1, 14h, 4, 10h, 1, 14h
		db 18, 10h, 3, 15h, 17, 10h, 1, 14h, 8, 10h, 5, 12h, 6, 10h, 3, 15h, 9, 10h, 1, 14h, 5, 10h, 1, 14h, 1, 10h
		db 1, 14h, 8, 10h, 6, 12h, 5, 10h, 3, 15h, 12, 10h, 1, 14h, 4, 10h, 1, 14h, 8, 10h, 6, 12h, 5, 10h, 3, 15h
		db 17, 10h, 1, 14h, 8, 10h, 5, 12h, 6, 10h, 4, 15h, 36, 10h, 5, 15h, 35, 10h, 6, 15h, 34, 10h, 6, 15h, 34, 10h
		db 7, 15h, 33, 10h, 8, 15h, 32, 10h

		db 36, 10h, 4, 15h, 36, 10h, 4, 15h, 35, 10h, 5, 15h, 34, 10h, 6, 15h, 33, 10h, 7, 15h, 10, 10h
		db 3, 12h, 19, 10h, 8, 15h, 9, 10h, 4, 12h, 18, 10h, 9, 15h, 8, 10h, 4, 12h, 19, 10h, 9, 15h, 8, 10h
		db 3, 12h, 19, 10h, 10, 15h, 29, 10h, 11, 15h, 28, 10h, 12, 15h, 27, 10h, 13, 15h, 26, 10h, 14, 15h, 24, 10h
		db 16, 15h, 22, 10h, 18, 15h

		db 12, 15h, 1, 16h, 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h
		db 1, 16h, 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h
		db 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h
		db 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 22, 15h, 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 22, 15h
		db 1, 16h, 1, 17h, 14, 15h, 1, 16h, 1, 17h, 15, 15h, 7, 1Ah, 2, 1Bh, 2, 1Ah, 12, 15h, 1, 16h, 1, 17h, 15, 15h
		db 1, 1Ah, 10, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah, 10, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah
		db 10, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah, 10, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah, 10, 1Bh

		db 7, 15h, 33, 10h, 7, 15h, 33, 10h, 9, 15h, 24, 10h, 3, 13h, 4, 10h, 20, 15h, 14, 10h, 2, 13h
		db 4, 10h, 31, 15h, 9, 10h, 160, 15h, 13, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h
		db 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h

		db 14, 10h, 17, 15h, 21, 10h, 1, 16h, 1, 17h, 17, 15h, 20, 10h, 1, 15h, 1, 16h, 1, 17h, 18, 15h
		db 17, 10h, 3, 15h, 1, 16h, 1, 17h, 19, 15h, 12, 10h, 7, 15h, 1, 16h, 1, 17h, 21, 15h, 5, 10h, 12, 15h
		db 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h
		db 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h
		db 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 26, 15h

		db 11, 10h, 29, 15h, 11, 10h, 29, 15h, 6, 10h, 34, 15h, 5, 10h, 35, 15h, 3, 10h, 247, 15h, 23, 1Ah
		db 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah
		db 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 7, 15h

		db 8, 15h, 32, 10h, 8, 15h, 32, 10h, 10, 15h, 27, 10h, 1, 14h, 2, 10h, 11, 15h, 22, 10h, 1, 14h
		db 6, 10h, 14, 15h, 11, 10h, 2, 12h, 8, 10h, 1, 14h, 4, 10h, 17, 15h, 8, 10h, 3, 12h, 12, 10h, 20, 15h
		db 5, 10h, 3, 12h, 2, 10h, 1, 14h, 9, 10h, 22, 15h, 18, 10h, 25, 15h, 13, 10h, 242, 15h

		db 22, 10h, 18, 15h, 22, 10h, 18, 15h, 5, 10h, 1, 12h, 1, 10h, 1, 12h, 11, 10h, 21, 15h, 15, 10h
		db 25, 15h, 6, 10h, 1, 12h, 6, 10h, 27, 15h, 11, 10h, 29, 15h, 8, 10h, 32, 15h, 5, 10h, 37, 15h, 1, 16h
		db 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h, 1, 16h, 1, 17h, 38, 15h, 1, 16h
		db 1, 17h, 34, 15h, 2, 10h, 2, 15h, 1, 16h, 1, 17h, 33, 15h, 3, 10h, 2, 15h, 1, 16h, 1, 17h, 33, 15h
		db 3, 10h

		db 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah, 10, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah
		db 10, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah, 10, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah
		db 2, 1Bh, 6, 11h, 2, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah, 2, 1Bh, 6, 11h, 2, 1Bh, 12, 15h
		db 1, 16h, 1, 17h, 15, 15h, 1, 1Ah, 2, 1Bh, 6, 11h, 2, 1Bh, 12, 15h, 1, 16h, 1, 17h, 15, 15h, 1, 1Ah
		db 2, 1Bh, 6, 11h, 2, 1Bh, 7, 15h, 10, 10h, 12, 15h, 1, 1Ah, 3, 1Bh, 5, 11h, 2, 1Bh, 5, 15h, 14, 10h
		db 10, 15h, 1, 1Ah, 3, 1Bh, 4, 11h, 3, 1Bh, 4, 15h, 12, 10h, 2, 11h, 2, 10h, 9, 15h, 1, 1Ah, 10, 1Bh
		db 2, 15h, 13, 10h, 3, 11h, 3, 10h, 8, 15h, 1, 1Ah, 10, 1Bh, 1, 15h, 15, 10h, 2, 11h, 4, 10h, 7, 15h
		db 1, 1Ah, 10, 1Bh, 23, 10h, 6, 15h, 1, 1Ah, 10, 1Bh, 23, 10h, 6, 15h, 2, 1Ah, 2, 1Bh, 7, 1Ah, 23, 10h
		db 8, 15h, 1, 16h, 1, 17h, 7, 15h

		db 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah
		db 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah, 27, 15h, 12, 1Bh, 1, 1Ah
		db 27, 15h, 12, 1Bh, 1, 1Ah, 25, 15h, 2, 10h, 12, 1Bh, 1, 1Ah, 24, 15h, 3, 10h, 12, 1Bh, 1, 1Ah, 23, 15h
		db 4, 10h, 12, 1Bh, 1, 1Ah, 22, 15h, 5, 10h, 12, 1Bh, 1, 1Ah, 21, 15h, 6, 10h, 6, 1Ah, 2, 1Bh, 5, 1Ah
		db 20, 15h, 7, 10h, 6, 15h, 1, 16h, 1, 17h, 25, 15h, 7, 10h

		db 12, 15h, 1, 16h, 1, 17h, 36, 15h, 15, 10h, 23, 15h, 18, 10h, 20, 15h, 21, 10h, 17, 15h, 24, 10h
		db 15, 15h, 11, 10h, 3, 11h, 12, 10h, 13, 15h, 11, 10h, 4, 11h, 12, 10h, 12, 15h, 11, 10h, 5, 11h, 13, 10h
		db 10, 15h, 11, 10h, 6, 11h, 13, 10h, 10, 15h, 11, 10h, 5, 11h, 15, 10h, 9, 15h, 13, 10h, 2, 11h, 17, 10h
		db 8, 15h, 33, 10h, 7, 15h, 34, 10h, 6, 15h, 34, 10h, 6, 15h, 34, 10h, 6, 15h

		db 10, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h
		db 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah
		db 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh
		db 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah
		db 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 7, 15h

		db 255, 15h, 62, 15h, 3, 10h, 32, 15h, 8, 10h, 30, 15h, 10, 10h, 26, 15h, 8, 10h, 4, 13h, 2, 10h
		db 24, 15h, 9, 10h, 5, 13h, 2, 10h, 23, 15h, 10, 10h, 5, 13h, 2, 10h, 22, 15h, 18, 10h, 22, 15h, 18, 10h

		db 2, 15h, 1, 16h, 1, 17h, 33, 15h, 3, 10h, 2, 15h, 1, 16h, 1, 17h, 33, 15h, 3, 10h, 2, 15h
		db 1, 16h, 1, 17h, 32, 15h, 4, 10h, 2, 15h, 1, 16h, 1, 17h, 32, 15h, 4, 10h, 2, 15h, 1, 16h, 1, 17h
		db 32, 15h, 4, 10h, 2, 15h, 1, 16h, 1, 17h, 32, 15h, 4, 10h, 2, 15h, 5, 10h, 30, 15h, 21, 10h, 19, 15h
		db 24, 10h, 16, 15h, 13, 10h, 3, 13h, 10, 10h, 14, 15h, 12, 10h, 4, 13h, 10, 10h, 14, 15h, 5, 10h, 2, 13h
		db 5, 10h, 4, 13h, 10, 10h, 17, 15h, 2, 10h, 2, 13h, 19, 10h, 17, 15h, 24, 10h, 16, 15h, 24, 10h, 16, 15h

		db 23, 10h, 8, 15h, 1, 16h, 1, 17h, 7, 15h, 23, 10h, 8, 15h, 1, 16h, 1, 17h, 7, 15h, 23, 10h, 8, 15h, 1, 16h
		db 1, 17h, 7, 15h, 7, 10h, 2, 11h, 5, 10h, 1, 14h, 8, 10h, 8, 15h, 1, 16h, 1, 17h, 7, 15h, 5, 10h, 5, 11h, 3, 10h
		db 1, 14h, 2, 10h, 1, 14h, 6, 10h, 8, 15h, 1, 16h, 1, 17h, 7, 15h, 4, 10h, 6, 11h, 5, 10h, 1, 14h, 6, 10h, 9, 15h
		db 1, 16h, 1, 17h, 7, 15h, 4, 10h, 6, 11h, 7, 10h, 1, 14h, 4, 10h, 9, 15h, 1, 16h, 1, 17h, 7, 15h, 4, 10h, 6, 11h
		db 4, 10h, 1, 14h, 6, 10h, 10, 15h, 1, 16h, 1, 17h, 7, 15h, 4, 10h, 5, 11h, 11, 10h, 11, 15h, 1, 16h, 1, 17h
		db 7, 15h, 19, 10h, 12, 15h, 1, 16h, 1, 17h, 7, 15h, 17, 10h, 14, 15h, 1, 16h, 1, 17h, 9, 15h, 14, 10h, 15, 15h
		db 1, 16h, 1, 17h, 12, 15h, 8, 10h, 13, 15h, 5, 1Ah, 2, 1Bh, 5, 1Ah, 8, 15h, 4, 10h, 16, 15h, 1, 1Ah, 10, 1Bh
		db 1, 1Ah, 28, 15h, 1, 1Ah, 10, 1Bh, 1, 1Ah, 2, 15h

		db 6, 15h, 1, 16h, 1, 17h, 25, 15h, 7, 10h, 6, 15h, 1, 16h, 1, 17h, 24, 15h, 8, 10h, 6, 15h, 1, 16h, 1, 17h
		db 23, 15h, 9, 10h, 6, 15h, 1, 16h, 1, 17h, 22, 15h, 10, 10h, 6, 15h, 1, 16h, 1, 17h, 22, 15h, 10, 10h, 6, 15h
		db 1, 16h, 1, 17h, 21, 15h, 11, 10h, 6, 15h, 1, 16h, 1, 17h, 21, 15h, 11, 10h, 6, 15h, 1, 16h, 1, 17h, 21, 15h
		db 11, 10h, 4, 15h, 2, 1Ah, 2, 1Bh, 16, 1Ah, 5, 15h, 11, 10h, 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 5, 15h, 11, 10h
		db 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 5, 15h, 11, 10h, 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 5, 15h, 11, 10h, 4, 15h
		db 1, 1Ah, 18, 1Bh, 1, 1Ah, 5, 15h, 11, 10h, 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 5, 15h, 11, 10h, 4, 15h, 1, 1Ah
		db 18, 1Bh, 1, 1Ah, 6, 15h, 10, 10h

		db 34, 10h, 6, 15h, 34, 10h, 6, 15h, 34, 10h, 6, 15h, 34, 10h, 6, 15h, 6, 10h, 1, 13h, 27, 10h, 6, 18h, 10, 10h
		db 1, 13h, 23, 10h, 6, 19h, 3, 10h, 1, 13h, 3, 10h, 1, 13h, 26, 10h, 6, 15h, 5, 10h, 1, 13h, 14, 10h, 5, 12h
		db 9, 10h, 6, 15h, 19, 10h, 8, 12h, 7, 10h, 6, 15h, 10, 10h, 1, 13h, 8, 10h, 8, 12h, 7, 10h, 6, 15h, 3, 10h
		db 1, 13h, 3, 10h, 1, 13h, 11, 10h, 8, 12h, 7, 10h, 6, 15h, 20, 10h, 6, 12h, 8, 10h, 6, 15h, 6, 10h, 1, 13h
		db 26, 10h, 7, 15h, 33, 10h, 7, 15h, 33, 10h, 7, 15h

		db 10, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h
		db 1, 1Ah, 21, 1Bh, 1, 1Ah, 7, 15h, 10, 18h, 22, 1Bh, 1, 1Ah, 7, 15h, 10, 19h, 22, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah
		db 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh
		db 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah
		db 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 7, 15h

		db 22, 15h, 18, 10h, 22, 15h, 18, 10h, 22, 15h, 9, 10h, 3, 13h, 6, 10h, 23, 15h, 8, 10h, 3, 13h
		db 6, 10h, 23, 15h, 8, 10h, 3, 13h, 6, 10h, 24, 15h, 7, 10h, 3, 13h, 6, 10h, 24, 15h, 8, 10h, 2, 13h
		db 6, 10h, 25, 15h, 15, 10h, 25, 15h, 15, 10h, 29, 15h, 11, 10h, 34, 15h, 6, 10h, 160, 15h

		db 24, 10h, 16, 15h, 24, 10h, 16, 15h, 23, 10h, 17, 15h, 4, 10h, 1, 14h, 17, 10h, 18, 15h, 2, 10h
		db 1, 14h, 5, 10h, 3, 12h, 10, 10h, 19, 15h, 4, 10h, 1, 14h, 2, 10h, 4, 12h, 9, 10h, 20, 15h, 2, 10h
		db 1, 14h, 4, 10h, 4, 12h, 7, 10h, 22, 15h, 8, 10h, 3, 12h, 6, 10h, 23, 15h, 16, 10h, 24, 15h, 13, 10h
		db 27, 15h, 3, 10h, 197, 15h

		db 26, 15h, 1, 1Ah, 10, 1Bh, 1, 1Ah, 28, 15h, 1, 1Ah, 11, 1Bh, 2, 18h, 26, 15h, 1, 1Ah, 11, 1Bh, 2, 19h, 26, 15h
		db 1, 1Ah, 10, 1Bh, 1, 1Ah, 28, 15h, 1, 1Ah, 2, 1Bh, 1, 11h, 7, 1Bh, 1, 1Ah, 28, 15h, 1, 1Ah, 5, 1Bh, 1, 11h
		db 4, 1Bh, 1, 1Ah, 28, 15h, 1, 1Ah, 3, 1Bh, 1, 11h, 6, 1Bh, 1, 1Ah, 28, 15h, 1, 1Ah, 2, 1Bh, 1, 11h, 2, 1Bh
		db 1, 11h, 4, 1Bh, 1, 1Ah, 28, 15h, 1, 1Ah, 10, 1Bh, 1, 1Ah, 28, 15h, 1, 1Ah, 10, 1Bh, 1, 1Ah, 28, 15h, 12, 1Ah
		db 162, 15h

		db 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 6, 15h, 10, 10h, 4, 18h, 19, 1Bh, 1, 1Ah, 6, 15h, 10, 10h
		db 4, 19h, 19, 1Bh, 1, 1Ah, 7, 15h, 9, 10h, 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 9, 15h, 7, 10h, 4, 15h
		db 1, 1Ah, 18, 1Bh, 1, 1Ah, 10, 15h, 6, 10h, 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 10, 15h, 6, 10h, 4, 15h
		db 1, 1Ah, 18, 1Bh, 1, 1Ah, 11, 15h, 5, 10h, 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 11, 15h, 5, 10h, 4, 15h
		db 1, 1Ah, 18, 1Bh, 1, 1Ah, 11, 15h, 5, 10h, 4, 15h, 1, 1Ah, 18, 1Bh, 1, 1Ah, 12, 15h, 4, 10h, 4, 15h
		db 20, 1Ah, 14, 15h, 2, 10h, 160, 15h

		db 33, 10h, 7, 15h, 33, 10h, 7, 15h, 32, 10h, 8, 15h, 31, 10h, 9, 15h, 30, 10h, 10, 15h, 29, 10h
		db 11, 15h, 28, 10h, 12, 15h, 26, 10h, 14, 15h, 25, 10h, 15, 15h, 23, 10h, 17, 15h, 21, 10h, 179, 15h

		db 10, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h
		db 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah
		db 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh
		db 1, 1Ah, 17, 15h, 1, 1Ah, 21, 1Bh, 1, 1Ah, 17, 15h, 23, 1Ah, 127, 15h
	
	screensByteCount db 64, 50, 48, 38, 46, 42
					 db 124, 72, 136, 112, 114, 72
					 db 112, 76, 182, 64, 106, 56
					 db 66, 96, 198, 108, 88, 122
					 db 46, 118, 200, 164, 116, 122
					 db 66, 76, 106, 126, 44, 94

CODESEG

; Random
; action: generates a random number in the range provided
; parameters:
low_Random equ [word ptr bp + 6] ; low end of the random (inclusive)
high_Random equ [word ptr bp + 4] ; high end of the random (exclusive)
; returns: nothing
proc Random
	push bp
	mov bp, sp
	push bx
	push dx
	push es

	mov ax, 40h
	mov es, ax
	mov ax, [word ptr es:6Ch] ; get the time

	xor al, ah ; make it more random
	xor ax, [word ptr cs:bx] ; even more random

	; put in the range
	mov bx, high_Random
	sub bx, low_Random
	xor dx, dx
	div bx
	mov ax, dx
	add ax, low_Random

	pop es
	pop dx
	pop bx
	pop bp
	ret 4
endp Random


; Abs
; action: return the absolute value of the number
; parameters:
num_Abs equ [word ptr bp + 4] ; the number
; returns: the absolute value of the number
proc Abs
	push bp
	mov bp, sp

	mov ax, num_Abs
	cmp ax, 0
	jge RetAbs
	neg ax

	RetAbs:
		pop bp
		ret 2
endp Abs

; Delay
; action: waits 1500 microseconds
; parameters: none
; returns: nothing
proc Delay
	pusha
	
	; cx:dx - the number of microseconds
	mov ax, 8600h
	xor cx, cx
	mov dx, 1500
	int 15h
	
	popa
	ret
endp Delay

; GetTileCoordsOnTileset
; action: returns the tile coordinates on the tileset
; parameters:
tile_GetTileCoordsOnTileset equ [word ptr bp + 4] ; the tile index
; returns: dx - x in tileset, ax - y in tileset
proc GetTileCoordsOnTileset
	push bp
	mov bp, sp
	push bx
	
	mov ax, tile_GetTileCoordsOnTileset
	mov bx, 10h
	div bx
	shl ax, 3
	shl dx, 3
	
	pop bx
	pop bp
	ret 2
endp GetTileCoordsOnTileset

; GetTileFromCoords
; action: returns the tile in the provided coordinates
; parameters:
x_GetTileFromCoords equ [word ptr bp + 6] ; x
y_GetTileFromCoords equ [word ptr bp + 4] ; y
; returns: ax - the tile in the provided coordinates, si - the offset of the tile in memory
proc GetTileFromCoords
	push bp
	mov bp, sp
	push bx
	push cx
	push dx
	
	mov ax, y_GetTileFromCoords
	mov bx, x_GetTileFromCoords
	
	shr ax, 3
	shr bx, 3
	
	; get the offset in tiles
	mov cx, 40
	mul cx
	add ax, bx
	mov bx, ax
	
	; get to the correct screen
	mov al, [byte ptr currentScreen]
	mov ah, 0
	mov si, ax
	xor ax, ax
	CountPreviousBytes:
		cmp si, 0
		je EndGetTileFromCoords
		
		dec si
		mov cl, [byte ptr screensByteCount + si]
		xor ch, ch
		add ax, cx
		jmp CountPreviousBytes
	
	EndGetTileFromCoords:
		mov si, ax
	
	; go to the correct tile
	xor cx, cx
	GetTileFromCoordsLoop:
		mov dl, [byte ptr map + si]
		xor dh, dh
		add cx, dx
		add si, 2
		cmp cx, bx
		jbe GetTileFromCoordsLoop

	dec si
	mov al, [byte ptr map + si]
	xor ah, ah

	pop dx
	pop cx
	pop bx
	pop bp
	ret 4
endp GetTileFromCoords

; Erase
; action: draws the world above the coordinates such that it erases what was there before
; parameters:
x_Erase equ [word ptr bp + 6] ; x
y_Erase equ [word ptr bp + 4] ; y
; returns: nothing
proc Erase
	push bp
	mov bp, sp
	pusha

	mov cx, x_Erase
	shr cx, 3
	shl cx, 3

	mov dx, y_Erase
	shr dx, 3
	shl dx, 3

	; top left
	cmp cx, 0
	jl EraseTopRight
	cmp dx, 0
	jl EraseTopRight
	push cx
	push dx
	call GetTileFromCoords

	push SCREEN
	push cx
	push dx
	push ax
	call DrawTile

	; top right
	EraseTopRight:
		add cx, 8
		cmp cx, 312
		ja EraseBottomRight
		cmp dx, 0
		jl EraseBottomRight
		push cx
		push dx
		call GetTileFromCoords

		push SCREEN
		push cx
		push dx
		push ax
		call DrawTile

	; bottom right
	EraseBottomRight:
		add dx, 8
		cmp cx, 312
		ja EraseBottomLeft
		cmp dx, 112
		ja EraseBottomLeft
		push cx
		push dx
		call GetTileFromCoords

		push SCREEN
		push cx
		push dx
		push ax
		call DrawTile

	; bottom left
	EraseBottomLeft:
		sub cx, 8
		cmp cx, 0
		jl RetErase
		cmp dx, 112
		ja RetErase
		push cx
		push dx
		call GetTileFromCoords

		push SCREEN
		push cx
		push dx
		push ax
		call DrawTile

	RetErase:
		popa
		pop bp
		ret 4
endp Erase


; OpenFile
; action: opens a file and returns a file handle of the file
; parameters:
filename_OpenFile equ [word ptr bp + 4] ; the filename
; returns: the file handle, if there was an error then exits the program
proc OpenFile
	push bp
	mov bp, sp
	push dx

	mov dx, filename_OpenFile
	mov ax, 3D00h
	int 21h
	jnc EndOpenFile

	; exit program if couldn't open file
	mov ax, 02h
	int 10h

	mov dx, offset fileErrorMsg
	mov ah, 09h
	int 21h

	mov ax, 4C00h
	int 21h

	EndOpenFile:
		pop dx
		pop bp
		ret 2
endp OpenFile


; ReadHeader
; action: reads the header of the bmp into memory
; parameters:
header_ReadHeader equ [word ptr bp + 6] ; offset of header in memory
handle_ReadHeader equ [word ptr bp + 4] ; bmp handle
; returns: nothing
proc ReadHeader
	push bp
	mov bp, sp
	pusha

	mov bx, handle_ReadHeader
	mov dx, header_ReadHeader
	mov ax, 3F00h
	mov cx, 54
	int 21h

	popa
	pop bp
	ret 4
endp ReadHeader


; ReadAndSetPalette
; action: reads the palette from bmp and sets it to the color palette
; parameters:
palette_ReadAndSetPalette equ [word ptr bp + 6] ; palette offset in memory
handle_ReadAndSetPalette equ [word ptr bp + 4] ; bmp handle
; returns: nothing
proc ReadAndSetPalette
	push bp
	mov bp, sp
	pusha

	mov bx, handle_ReadAndSetPalette
	mov dx, palette_ReadAndSetPalette
	mov ax, 3F00h
	mov cx, 1024
	int 21h
	
	mov si, dx
	mov dx, 3C8h
	mov al, 0
	out dx, al
	inc dx

	mov cx, 256
	PaletteLoop:
		mov al, [byte ptr si + 2]
		shr al, 2
		out dx, al
		mov al, [byte ptr si + 1]
		shr al, 2
		out dx, al
		mov al, [byte ptr si]
		shr al, 2
		out dx, al
		add si, 4
		loop PaletteLoop

	popa
	pop bp
	ret 4
endp ReadAndSetPalette


; LoadPixelsToMemory
; action: copies the bmp data into memory
; parameters:
width_LoadPixelsToMemory equ [word ptr bp + 10] ; width of image
height_LoadPixelsToMemory equ [word ptr bp + 8] ; height of image
buffer_LoadPixelsToMemory equ [word ptr bp + 6] ; offset of target buffer in memory
handle_LoadPixelsToMemory equ [word ptr bp + 4] ; bmp handle
; returns: nothing
proc LoadPixelsToMemory
	push bp
	mov bp, sp
	pusha

	mov bx, handle_LoadPixelsToMemory
	mov dx, buffer_LoadPixelsToMemory
	mov ax, width_LoadPixelsToMemory
	mov cx, height_LoadPixelsToMemory
	push ax
	push dx
	mul cx
	pop dx
	add dx, ax
	pop di
	sub dx, di
	
	ReadLine:
		push cx
		mov cx, di
		mov ax, 3F00h
		int 21h
		sub dx, cx
		pop cx
		loop ReadLine

	popa
	pop bp
	ret 8
endp LoadPixelsToMemory


; CloseFile
; action: closes the file
; parameters:
handle_CloseFile equ [word ptr bp + 4] ; file handle
; returns: nothing
proc CloseFile
	push bp
	mov bp, sp
	pusha

	mov bx, handle_CloseFile
	mov ax, 3E00h
	int 21h

	popa
	pop bp
	ret 2
endp CloseFile


; LoadMusic
; action: loads the music into memory
; parameters: none
; returns: nothing
proc LoadMusic
	pusha

	push offset musicFilename
	call OpenFile
	
	mov bx, ax
	mov dx, offset music
	mov ah, 3Fh
	mov cx, musicSize
	int 21h

	push bx
	call CloseFile

	popa
	ret
endp LoadMusic


; LoadBMP
; action: loads the bmp into memory
; parameters:
filename_LoadBMP equ [word ptr bp + 10] ; bmp filename
width_LoadBMP equ [word ptr bp + 8] ; width of image
height_LoadBMP equ [word ptr bp + 6] ; height of image
buffer_LoadBMP equ [word ptr bp + 4] ; target buffer in memory
; returns: nothing
handle_LoadBMP equ [word ptr bp - 2]
proc LoadBMP
	push bp
	mov bp, sp
	sub sp, 2
	pusha
	
	; open file
	push filename_LoadBMP
	call OpenFile
	mov handle_LoadBMP, ax
	
	; set header
	push offset header
	push handle_LoadBMP
	call ReadHeader
	
	; set palette
	push offset palette
	push handle_LoadBMP
	call ReadAndSetPalette
	
	; load pixels to tileset
	push width_LoadBMP
	push height_LoadBMP
	push buffer_LoadBMP
	push handle_LoadBMP
	call LoadPixelsToMemory
	
	; close file
	push handle_LoadBMP
	call CloseFile
	
	popa
	add sp, 2
	pop bp
	ret 8
endp LoadBMP


; DrawBMP
; action: draws a 320x200 bmp on the screen
; parameters:
filename_DrawBMP equ [word ptr bp + 4] ; bmp filename
; returns: nothing
proc DrawBMP
	push bp
	mov bp, sp
	pusha
	push es

	push filename_DrawBMP
	call OpenFile

	push offset header
	push ax
	call ReadHeader

	push offset palette
	push ax
	call ReadAndSetPalette

	mov bx, ax

	mov ax, 0A000h
	mov es, ax

	mov cx, 200
	DrawBMPLoop:
		push cx
		dec cx

		mov di, cx
		shl cx, 6
		shl di, 8
		add di, cx

		mov ah, 3Fh
		mov cx, 320
		mov dx, offset screenLine
		int 21h

		cld
		mov cx, 320
		mov si, offset screenLine
		rep movsb

		pop cx
		loop DrawBMPLoop

	pop es
	popa
	pop bp
	ret 2
endp DrawBMP


; DrawMinimap
; action: draws the minimap in target coordinates
; parameters:
x_DrawMinimap equ [word ptr bp + 6] ; target x
y_DrawMinimap equ [word ptr bp + 4] ; target y
; returns: nothing
proc DrawMinimap
	push bp
	mov bp, sp
	pusha
	push es
	
	mov ax, SCREEN
	mov es, ax
	
	mov ax, y_DrawMinimap
	mov bx, 320
	mul bx
	add ax, x_DrawMinimap
	mov di, ax
	mov si, offset minimap
	
	mov cx, 48
	DrawMinimapCols:
		push cx
		
		mov cx, 144
		cld
		rep movsb
		add di, 176
		
		pop cx
		loop DrawMinimapCols
		
	pop es
	popa
	pop bp
	ret 4
endp DrawMinimap


; DrawTile
; action: draws a tile in coordinates
; parameters
segment_DrawTile equ [word ptr bp + 10] ; segment to draw the tile in
x_DrawTile equ [word ptr bp + 8] ; x
y_DrawTile equ [word ptr bp + 6] ; y
tile_DrawTile equ [word ptr bp + 4] ; tile index
; returns: nothing
proc DrawTile
	push bp
	mov bp, sp
	pusha
	
	mov ax, segment_DrawTile
	mov es, ax
	
	; set destination
	mov ax, y_DrawTile
	mov bx, 320
	mul bx
	cld
	mov di, ax
	add di, x_DrawTile
	
	; set tile to draw
	mov si, offset tileset
	push tile_DrawTile
	call GetTileCoordsOnTileset
	add si, dx
	shl ax, 7
	add si, ax
	
	; draw loop
	mov cx, 8
	DrawTileLoop:
		push cx
		mov cx, 8
		TileRepMovsbLoop:
			mov al, [byte ptr ds:si]
			cmp al, 09h
			je TileIncSiDi
			mov [byte ptr es:di], al
			TileIncSiDi:
				inc si
				inc di
			loop TileRepMovsbLoop
		add di, 312
		add si, 120
		pop cx
		loop DrawTileLoop

	popa
	pop bp
	ret 8
endp DrawTile

; DrawWorld
; action: draws current world screen in target segment
; parameters:
segment_DrawWorld equ [word ptr bp + 4] ; target segment
; returns: nothing
x_DrawWorld equ [word ptr bp - 2]
y_DrawWorld equ [word ptr bp - 4]
proc DrawWorld
	push bp
	mov bp, sp
	push 0
	push 0
	pusha

	mov cx, 15
	DrawWorldColumn:
		push cx
		mov x_DrawWorld, 0
		
		mov cx, 40
		DrawWorldRow:
			push cx
			
			; push x, y
			push segment_DrawWorld
			push x_DrawWorld
			push y_DrawWorld
			
			; calculating, pushing and drawing tile	
			push x_DrawWorld
			push y_DrawWorld
			call GetTileFromCoords
			
			push ax
			call DrawTile
	
			pop cx
			add x_DrawWorld, 8
			loop DrawWorldRow
			
		pop cx
		add y_DrawWorld, 8
		loop DrawWorldColumn

	popa
	add sp, 4
	pop bp
	ret 2
endp DrawWorld


; DrawNumber
; action: draws a 3-digit number
; parameters:
x_DrawNumber equ [word ptr bp + 8] ; x
y_DrawNumber equ [word ptr bp + 6] ; y
num_DrawNumber equ [word ptr bp + 4] ; number to draw
; returns: nothing

digit1_DrawNumber equ [word ptr bp - 2]
digit2_DrawNumber equ [word ptr bp - 4]
digit3_DrawNumber equ [word ptr bp - 6]
proc DrawNumber
	push bp
	mov bp, sp
	sub sp, 6
	pusha
	
	mov ax, num_DrawNumber
	mov bl, 10
	div bl
	mov al, ah
	xor ah, ah
	mov digit3_DrawNumber, ax
	
	mov ax, num_DrawNumber
	mov bl, 10
	div bl
	xor ah, ah
	div bl
	mov al, ah
	xor ah, ah
	mov digit2_DrawNumber, ax
	
	mov ax, num_DrawNumber
	mov bl, 100
	div bl
	xor ah, ah
	mov digit1_DrawNumber, ax
	
	push SCREEN
	push x_DrawNumber
	push y_DrawNumber
	push digit1_DrawNumber
	call DrawTile
	
	add x_DrawNumber, 8
	push SCREEN
	push x_DrawNumber
	push y_DrawNumber
	push digit2_DrawNumber
	call DrawTile
	
	add x_DrawNumber, 8
	push SCREEN
	push x_DrawNumber
	push y_DrawNumber
	push digit3_DrawNumber
	call DrawTile
	
	popa
	add sp, 6
	pop bp
	ret 6
endp DrawNumber

; DrawUI
; action: draws the ui on screen
; parameters: none
; returns: nothing
proc DrawUI
	pusha
	push es

	; clear UI part
	mov ax, SCREEN
	mov es, ax

	mov cx, 12800
	mov ax, 0
	mov di, 38400
	rep stosw
	
	; draw gold
	push SCREEN
	push 160
	push 128
	push 1Fh
	call DrawTile
	
	mov al, [byte ptr gold]
	xor ah, ah
	push 176
	push 128
	push ax
	call DrawNumber
	
	; draw diamond
	push SCREEN
	push 160
	push 152
	push 20h
	call DrawTile
	
	mov al, [byte ptr diamond]
	xor ah, ah
	push 176
	push 152
	push ax
	call DrawNumber
	
	; draw ruby
	push SCREEN
	push 160
	push 176
	push 21h
	call DrawTile
	
	mov al, [byte ptr ruby]
	xor ah, ah
	push 176
	push 176
	push ax
	call DrawNumber
	
	; draw armor
	push SCREEN
	push 216
	push 128
	push 24h
	call DrawTile
	
	push SCREEN
	push 232
	push 128
	push 0Eh
	call DrawTile
	
	mov al, [byte ptr armorPoints]
	xor ah, ah
	push 240
	push 128
	push ax
	call DrawNumber
	
	; draw sword
	push SCREEN
	push 216
	push 152
	push 25h
	call DrawTile
	
	push SCREEN
	push 232
	push 152
	push 0Fh
	call DrawTile
	
	mov al, [byte ptr swordPoints]
	xor ah, ah
	push 240
	push 152
	push ax
	call DrawNumber
	
	; draw ring
	push SCREEN
	push 216
	push 176
	push 26h
	call DrawTile
	
	push SCREEN
	push 232
	push 176
	push 0Fh
	call DrawTile
	
	mov al, [byte ptr ringPoints]
	xor ah, ah
	push 240
	push 176
	push ax
	call DrawNumber
	
	; draw health
	mov al, [byte ptr health]
	xor ah, ah
	push 280
	push 160
	push ax
	call DrawNumber
	
	; draw minimap
	push 8
	push 128
	call DrawMinimap
	
	; draw player in minimap
	mov al, [byte ptr currentScreen]
	xor ah, ah
	mov bl, 6
	div bl
	mov cl, ah ; save x for later
	xor ah, ah
	shl ax, 3
	add ax, 128
	mov si, ax ; y
	mov ax, [word ptr y]
	mov bl, 15
	div bl
	xor ah, ah
	add si, ax ; add player y
	
	mov al, cl
	xor ah, ah
	mov bl, 24
	mul bl
	add ax, 8
	mov di, ax ; x
	mov ax, [word ptr x]
	mov bl, 13
	div bl
	xor ah, ah
	add di, ax ; add player x
	
	mov ax, 320
	mul si
	add ax, di
	mov bx, ax
	
	mov ax, SCREEN
	mov es, ax
	
	mov [byte ptr es:bx], 110 ; orange

	; draw armor text

	; number of key
	push SCREEN
	push 8
	push 176
	push 01h
	call DrawTile

	; armor logo
	push SCREEN
	push 24
	push 176
	push 24h
	call DrawTile

	; gold price
	push SCREEN
	push 40
	push 176
	push 1Fh
	call DrawTile

	push SCREEN
	push 48
	push 176
	push 0Eh
	call DrawTile

	push SCREEN
	push 56
	push 176
	push 09h
	call DrawTile

	; diamond price
	push SCREEN
	push 80
	push 176
	push 20h
	call DrawTile

	push SCREEN
	push 88
	push 176
	push 0Eh
	call DrawTile

	push SCREEN
	push 96
	push 176
	push 00h
	call DrawTile

	; ruby price
	push SCREEN
	push 120
	push 176
	push 21h
	call DrawTile

	push SCREEN
	push 128
	push 176
	push 0Eh
	call DrawTile

	push SCREEN
	push 136
	push 176
	push 00h
	call DrawTile

	; draw sword text

	; number of key
	push SCREEN
	push 8
	push 184
	push 02h
	call DrawTile

	; sword logo
	push SCREEN
	push 24
	push 184
	push 25h
	call DrawTile

	; gold price
	push SCREEN
	push 40
	push 184
	push 1Fh
	call DrawTile

	push SCREEN
	push 48
	push 184
	push 0Eh
	call DrawTile

	push SCREEN
	push 56
	push 184
	push 02h
	call DrawTile

	; diamond price
	push SCREEN
	push 80
	push 184
	push 20h
	call DrawTile

	push SCREEN
	push 88
	push 184
	push 0Eh
	call DrawTile

	push SCREEN
	push 96
	push 184
	push 07h
	call DrawTile

	; ruby price
	push SCREEN
	push 120
	push 184
	push 21h
	call DrawTile

	push SCREEN
	push 128
	push 184
	push 0Eh
	call DrawTile

	push SCREEN
	push 136
	push 184
	push 01h
	call DrawTile

	; draw ring text

	; number of key
	push SCREEN
	push 8
	push 192
	push 03h
	call DrawTile

	; ring logo
	push SCREEN
	push 24
	push 192
	push 26h
	call DrawTile

	; gold price
	push SCREEN
	push 40
	push 192
	push 1Fh
	call DrawTile

	push SCREEN
	push 48
	push 192
	push 0Eh
	call DrawTile

	push SCREEN
	push 56
	push 192
	push 00h
	call DrawTile

	; diamond price
	push SCREEN
	push 80
	push 192
	push 20h
	call DrawTile

	push SCREEN
	push 88
	push 192
	push 0Eh
	call DrawTile

	push SCREEN
	push 96
	push 192
	push 03h
	call DrawTile

	; ruby price
	push SCREEN
	push 120
	push 192
	push 21h
	call DrawTile

	push SCREEN
	push 128
	push 192
	push 0Eh
	call DrawTile

	push SCREEN
	push 136
	push 192
	push 08h
	call DrawTile
	
	pop es
	popa
	ret
endp DrawUI

; DrawScreen
; action: moves the screen buffer to video memory (the screen)
; parameters: none
; returns: nothing
proc DrawScreen
	pusha
	
	mov ax, 0A000h
	mov es, ax
	
	push ds
	mov ax, SCREEN
	mov ds, ax
	
	cld
	xor di, di
	xor si, si
	
	mov cx, 32000
	rep movsw
	
	pop ds
	popa
	ret
endp DrawScreen


; CheckScreenMovement
; action: moves the screen according to direction
; parameters: none
; returns: nothing
proc CheckScreenMovement
	cmp [byte ptr playerDirection], 0
	je MoveScreenUpLabel
	cmp [byte ptr playerDirection], 2
	je MoveScreenDownLabel
	cmp [byte ptr playerDirection], 3
	je MoveScreenRightLabel
	jmp MoveScreenLeftLabel
	
	MoveScreenUpLabel:
		call MoveScreenUp
		ret
	
	MoveScreenDownLabel:
		call MoveScreenDown
		ret
	
	MoveScreenRightLabel:
		call MoveScreenRight
		ret
	
	MoveScreenLeftLabel:
		call MoveScreenLeft
		ret
endp CheckScreenMovement


; CheckIfCollides
; action: check if the tile is collidable
; parameters:
tile_CheckIfCollides equ [word ptr bp + 4] ; tile index
; returns: 1 if collides, 0 if not
proc CheckIfCollides
	push bp
	mov bp, sp
	
	mov ax, tile_CheckIfCollides
	cmp ax, 10h
	je NotCollides
	cmp ax, 16h
	je NotCollides
	cmp ax, 17h
	je NotCollides
	cmp ax, 18h
	je NotCollides
	cmp ax, 19h
	je NotCollides
	cmp ax, 1Bh
	je NotCollides

	mov ax, 1
	jmp RetCheckIfCollides
	
	NotCollides:
		xor ax, ax
	
	RetCheckIfCollides:
		pop bp
		ret 2
endp CheckIfCollides

; CheckIfCanMine
; action: checks if the tile is mineable
; parameters:
tile_CheckIfCanMine equ [word ptr bp + 4] ; tile index
; returns: 1 if collides, 0 if not
proc CheckIfCanMine
	push bp
	mov bp, sp

	mov ax, tile_CheckIfCanMine
	cmp ax, 11h
	je CanMine
	cmp ax, 12h
	je CanMine
	cmp ax, 13h
	je CanMine
	cmp ax, 14h
	je CanMine

	xor ax, ax
	jmp RetCheckIfCanMine

	CanMine:
		mov ax, 1

	RetCheckIfCanMine:
		pop bp
		ret 2
endp CheckIfCanMine


; Collide
; action: if an x and y collide with something in front of them, cancel the movement
; parameters:
x_Collide equ [word ptr bp + 18] ; x
y_Collide equ [word ptr bp + 16] ; y
coordOffset_Collide equ [word ptr bp + 14] ; the coord to modify
firstX_Collide equ [word ptr bp + 12] ; x modifier for first tile
firstY_Collide equ [word ptr bp + 10] ; y modifier for first tile
secondX_Collide equ [word ptr bp + 8] ; x modifier for second tile
secondY_Collide equ [word ptr bp + 6] ; y modifier for second tile
changeCoord_Collide equ [word ptr bp + 4] ; modifier for coord if it collides
; returns: nothing
proc Collide
	push bp
	mov bp, sp
	pusha

	; first tile
	mov ax, x_Collide
	add ax, firstX_Collide
	push ax
	mov ax, y_Collide
	add ax, firstY_Collide
	push ax
	call GetTileFromCoords
	push ax
	call CheckIfCollides
	mov di, ax
	
	; second tile
	mov ax, x_Collide
	add ax, secondX_Collide
	push ax
	mov ax, y_Collide
	add ax, secondY_Collide
	push ax
	call GetTileFromCoords
	push ax
	call CheckIfCollides
	
	; if it collides with at least one of the tiles, then undo the movement
	or ax, di
	jz RetCollide

	mov ax, changeCoord_Collide
	mov bx, coordOffset_Collide
	add [word ptr bx], ax
	
	RetCollide:
		popa
		pop bp
		ret 16
endp Collide

; CheckCollision
; action: execute the collide function according to the direction
; parameters:
direction_CheckCollision equ [word ptr bp + 8] ; direction
xOffset_CheckCollision equ [word ptr bp + 6] ; x
yOffset_CheckCollision equ [word ptr bp + 4] ; y
; returns: nothing
proc CheckCollision
	push bp
	mov bp, sp
	pusha

	mov bx, xOffset_CheckCollision
	push [word ptr bx]
	mov bx, yOffset_CheckCollision
	push [word ptr bx]
	
	cmp direction_CheckCollision, 0
	je CollisionUpLabel
	cmp direction_CheckCollision, 2
	je CollisionDownLabel
	cmp direction_CheckCollision, 3
	je CollisionRightLabel
	jmp CollisionLeftLabel
	
	CollisionUpLabel:
		push yOffset_CheckCollision
		push 0
		push 0
		push 7
		push 0
		push 1
		call Collide
		jmp RetCheckCollision
	
	CollisionDownLabel:
		push yOffset_CheckCollision
		push 0
		push 7
		push 7
		push 7
		push -1
		call Collide
		jmp RetCheckCollision
	
	CollisionRightLabel:
		push xOffset_CheckCollision
		push 7
		push 0
		push 7
		push 7
		push -1
		call Collide
		jmp RetCheckCollision
	
	CollisionLeftLabel:
		push xOffset_CheckCollision
		push 0
		push 0
		push 0
		push 7
		push 1
		call Collide
	
	RetCheckCollision:
		popa
		pop bp
		ret 6
endp CheckCollision

; Move
; action: move the player according to direction
; parameters: none
; returns: nothing
proc Move
	pusha
	
	cmp [byte ptr isMoving], 1
	je CheckUp
	jmp EndMove
	
	; check if should move screen

	CheckUp:
		cmp [word ptr y], 1
		jne CheckDown
		cmp [byte ptr playerDirection], 0
		jne CheckDown
		call CheckScreenMovement
		jmp CmpPlayerDirection
	
	CheckDown:
		cmp [word ptr y], 111
		jne CheckRight
		cmp [byte ptr playerDirection], 2
		jne CheckRight
		call CheckScreenMovement
		jmp CmpPlayerDirection
	
	CheckRight:
		cmp [word ptr x], 311
		jne CheckLeft
		cmp [byte ptr playerDirection], 3
		jne CheckLeft
		call CheckScreenMovement
		jmp CmpPlayerDirection
	
	CheckLeft:
		cmp [word ptr x], 1
		jne CmpPlayerDirection
		cmp [byte ptr playerDirection], 1
		jne CmpPlayerDirection
		call CheckScreenMovement
	
	; move player according to direction

	CmpPlayerDirection:
		cmp [playerDirection], 0
		je MoveUp
		cmp [playerDirection], 2
		je MoveDown
		cmp [playerDirection], 3
		je MoveRight
		jne MoveLeft
	
	MoveUp:
		sub [word ptr y], 1
		jmp EndMove
	MoveDown:
		add [word ptr y], 1
		jmp EndMove
	MoveRight:
		add [word ptr x], 1
		jmp EndMove
	MoveLeft:
		sub [word ptr x], 1
	
	EndMove:
		; check if collides
		mov al, [byte ptr playerDirection]
		xor ah, ah
		push ax
		push offset x
		push offset y
		call CheckCollision

		; change animation timer and frame
		cmp [byte ptr frameTimer], 10
		jne RetMove
		xor [byte ptr playerFrame], 1
		mov [byte ptr frameTimer], 0

		call DrawUI
		
	RetMove:
		inc [byte ptr frameTimer]
		popa
		ret
endp Move

; Mine
; action: mine the tile in front of the player
; parameters:
offset_Mine equ [word ptr bp + 4] ; offset of tile in front of player
; returns: nothing
proc Mine
	push bp
	mov bp, sp
	pusha

	mov si, offset_Mine

	mov al, [byte ptr map + si]
	cmp al, 11h
	je MineGold
	cmp al, 12h
	je MineDiamond
	cmp al, 13h
	je MineRuby
	cmp al, 14h
	je MineApple

	MineGold:
		xor bx, bx
		mov [byte ptr map + si], 37h
		jmp ContinueMine
	
	MineDiamond:
		mov bx, 1
		mov [byte ptr map + si], 37h
		jmp ContinueMine
	
	MineRuby:
		mov bx, 2
		mov [byte ptr map + si], 37h
		jmp ContinueMine
	
	MineApple:
		mov bx, 3
		mov al, [byte ptr ringPoints]
		add [byte ptr health], al
		cmp [byte ptr health], 119
		jbe DeleteAppleTile
		sub [byte ptr health], al
		jmp EndMine

	DeleteAppleTile:
		mov [byte ptr map + si], 10h

	ContinueMine:
		mov al, [byte ptr map + si - 1]
		add [byte ptr gold + bx], al

	EndMine:
		push SCREEN
		call DrawWorld
		call DrawUI

	popa
	pop bp
	ret 2
endp Mine

; CheckMineInDirection
; action: if there's a mineable tile in front of player, mine it
; parameters:
coordOffset_CheckMineInDirection equ [word ptr bp + 12] ; offset of the important coord
xMod1_CheckMineInDirection equ [word ptr bp + 10] ; x modifier for first tile
yMod1_CheckMineInDirection equ [word ptr bp + 8] ; y modifier for first tile
xMod2_CheckMineInDirection equ [word ptr bp + 6] ; x modifier for second tile
yMod2_CheckMineInDirection equ [word ptr bp + 4] ; y modifier for second tile
; returns: nothing
proc CheckMineInDirection
	push bp
	mov bp, sp
	pusha

	mov bx, coordOffset_CheckMineInDirection
	mov ax, [word ptr bx]
	mov bl, 8
	div bl
	cmp ah, 0
	jne RetCheckMineInDirection

	mov ax, [word ptr x]
	add ax, xMod1_CheckMineInDirection
	push ax
	mov ax, [word ptr y]
	add ax, yMod1_CheckMineInDirection
	push ax
	call GetTileFromCoords
	mov dx, si

	push ax
	call CheckIfCanMine
	mov di, ax

	mov ax, [word ptr x]
	add ax, xMod2_CheckMineInDirection
	push ax
	mov ax, [word ptr y]
	add ax, yMod2_CheckMineInDirection
	push ax
	call GetTileFromCoords
	
	push ax
	call CheckIfCanMine

	cmp ax, 1
	je ContinueCheckMineInDirection
	mov si, dx

	ContinueCheckMineInDirection:
		or ax, di

		cmp ax, 0
		je RetCheckMineInDirection

		push si
		call Mine

	RetCheckMineInDirection:
		popa
		pop bp
		ret 10
endp CheckMineInDirection


; CheckMine
; action: check if can mine in player direction, and if yes then mine the tile
; parameters: none
; returns: nothing
proc CheckMine
	pusha

	cmp [byte ptr playerDirection], 0
	je MineUp
	cmp [byte ptr playerDirection], 2
	je MineDown
	cmp [byte ptr playerDirection], 3
	je MineRight
	jmp MineLeft

	MineUp:
		push offset y
		push 0
		push -8
		push 7
		push -8
		call CheckMineInDirection

		jmp RetMine

	MineDown:
		push offset y
		push 0
		push 8
		push 7
		push 8
		call CheckMineInDirection

		jmp RetMine
	
	MineRight:
		push offset x
		push 8
		push 0
		push 8
		push 7
		call CheckMineInDirection

		jmp RetMine
	
	MineLeft:
		push offset x
		push -8
		push 0
		push -8
		push 7
		call CheckMineInDirection

	RetMine:
		popa
		ret
endp CheckMine


; DrawPlayer
; action: draws player
; parameters: none
; returns: nothing
proc DrawPlayer
	pusha
	
	push SCREEN
	push [word ptr x]
	push [word ptr y]
	
	cmp [byte ptr isMoving], 0
	je DrawPlayerNotMoving
	
	; considering animation
	DrawPlayerMoving:
		mov ah, 0

		mov al, [byte ptr playerDirection]
		shl al, 2
		xor ah, ah
		add ax, 28h
		add al, [byte ptr playerFrame]
		jmp CheckPlayerHurt
	
	DrawPlayerNotMoving:
		mov al, [byte ptr playerDirection]
		shl al, 2
		xor ah, ah
		add ax, 27h
	
	; if player hurt and hurtTimer is odd, draw a white player
	CheckPlayerHurt:
		cmp [byte ptr isHurt], 1
		jne DrawPlayerTile

		inc [byte ptr hurtTimer]
		mov bl, [byte ptr hurtTimer]
		shr bl, 3
		and bl, 1
		jz DrawPlayerTile
		mov al, [byte ptr playerDirection]
		shl al, 2
		xor ah, ah
		add ax, 2Ah

	DrawPlayerTile:
		push ax
		call DrawTile
		mov [byte ptr isMoving], 0
	
	popa
	ret
endp DrawPlayer

; DrawSword
; action: draws sword
; parameters: none
; returns: nothing
proc DrawSword
	pusha

	mov ax, 0Ah
	add al, [byte ptr playerDirection]
	cmp ax, 0Ah
	je DrawSwordUp
	cmp ax, 0Bh
	je DrawSwordLeft
	cmp ax, 0Ch
	je DrawSwordDown

	mov bx, [word ptr x]
	add bx, 8
	mov cx, [word ptr y]
	jmp DrawSwordLabel

	DrawSwordUp:
		mov bx, [word ptr x]
		mov cx, [word ptr y]
		sub cx, 8
		jmp DrawSwordLabel
	
	DrawSwordLeft:
		mov bx, [word ptr x]
		sub bx, 8
		mov cx, [word ptr y]
		jmp DrawSwordLabel
	
	DrawSwordDown:
		mov bx, [word ptr x]
		mov cx, [word ptr y]
		add cx, 8

	DrawSwordLabel:
		mov [word ptr swordX], bx
		mov [word ptr swordY], cx
		cmp [byte ptr isAttacking], 0
		je RetDrawSword

		push SCREEN
		push bx
		push cx
		push ax
		call DrawTile

	RetDrawSword:
		popa
		ret
endp DrawSword

; UpgradeStats
; action: checks if can upgrade target stat, and if yes then upgrade
; parameters:
gold_UpgradeStats equ [word ptr bp + 10] ; gold cost
diamond_UpgradeStats equ [word ptr bp + 8] ; diamond cost
ruby_UpgradeStats equ [word ptr bp + 6] ; ruby cost
stat_UpgradeStats equ [word ptr bp + 4] ; stat to upgrade
; returns: nothing
proc UpgradeStats
	push bp
	mov bp, sp
	pusha

	mov ax, gold_UpgradeStats
	cmp al, [byte ptr gold]
	ja EndUpgradeStats
	mov ax, diamond_UpgradeStats
	cmp al, [byte ptr diamond]
	ja EndUpgradeStats
	mov ax, ruby_UpgradeStats
	cmp al, [byte ptr ruby]
	ja EndUpgradeStats
	
	mov ax, gold_UpgradeStats
	sub [byte ptr gold], al
	mov ax, diamond_UpgradeStats
	sub [byte ptr diamond], al
	mov ax, ruby_UpgradeStats
	sub [byte ptr ruby], al

	mov bx, stat_UpgradeStats
	inc [byte ptr bx]
	
	xor al, al
	out 60h, al
	
	call DrawUI
	
	EndUpgradeStats:
		popa
		pop bp
		ret 8
endp UpgradeStats

; CheckEnemyCollision
; action: checks if an x and y collide with an enemy
; parameters:
x_CheckEnemyCollision equ [word ptr bp + 8] ; x to check
y_CheckEnemyCollision equ [word ptr bp + 6] ; y to check
enemyOffset_CheckEnemyCollision equ [word ptr bp + 4] ; enemy offset
; returns: 1 if collides, 0 if not
proc CheckEnemyCollision
	push bp
	mov bp, sp
	push bx
	push cx

	xor cx, cx
	mov bx, enemyOffset_CheckEnemyCollision

	mov ax, x_CheckEnemyCollision
	sub ax, [word ptr bx + 0]
	push ax
	call Abs
	cmp ax, 8
	jae RetCheckEnemyCollision

	mov ax, y_CheckEnemyCollision
	sub ax, [word ptr bx + 2]
	push ax
	call Abs
	cmp ax, 8
	jae RetCheckEnemyCollision

	inc cx
	
	RetCheckEnemyCollision:
		mov ax, cx
		pop cx
		pop bx
		pop bp
		ret 6
endp CheckEnemyCollision

; MoveEnemy
; action: moves an enemy
; parameters:
enemyOffset_MoveEnemy equ [word ptr bp + 4] ; offset of enemy
; returns: nothing
proc MoveEnemy
	push bp
	mov bp, sp
	pusha

	mov si, enemyOffset_MoveEnemy

	CmpEnemyDirection:
		cmp [word ptr si + 4], 0
		je EnemyMoveUp
		cmp [word ptr si + 4], 2
		je EnemyMoveDown
		cmp [word ptr si + 4], 3
		je EnemyMoveRight
		jne EnemyMoveLeft
	
	EnemyMoveUp:
		dec [word ptr si + 2]
		cmp [word ptr si + 2], 1
		jg RetMoveEnemy
		inc [word ptr si + 2]
		jmp RetMoveEnemy
	EnemyMoveDown:
		inc [word ptr si + 2]
		cmp [word ptr si + 2], 111
		jb RetMoveEnemy
		dec [word ptr si + 2]
		jmp RetMoveEnemy
	EnemyMoveRight:
		inc [word ptr si + 0]
		cmp [word ptr si + 0], 311
		jb RetMoveEnemy
		dec [word ptr si + 0]
		jmp RetMoveEnemy
	EnemyMoveLeft:
		dec [word ptr si + 0]
		cmp [word ptr si + 0], 1
		jg RetMoveEnemy
		inc [word ptr si + 0]

	RetMoveEnemy:
		push [word ptr si + 4]
		push si
		add si, 2
		push si
		call CheckCollision
		popa
		pop bp
		ret 2
endp MoveEnemy

; UpdateEnemy
; action: moves the enemy, checks if collides with player or sword and if yes then does the right thing to do,
; and draw the enemy
; parameters:
enemyOffset_UpdateEnemy equ [word ptr bp + 4] ; offset of enemy
; returns: nothing
proc UpdateEnemy
	push bp
	mov bp, sp
	pusha

	mov si, enemyOffset_UpdateEnemy

	; check if enemy is dead
	cmp [word ptr si + 6], 0
	jg CheckUpdateEnemy
	; if not flagged as dead, then flag as dead
	cmp [word ptr si + 6], -100
	jne DecEnemiesAlive
	jmp RetUpdateEnemy

	DecEnemiesAlive:
		dec [byte ptr enemiesAlive]
		mov [word ptr si + 6], -100
		jmp RetUpdateEnemy


	CheckUpdateEnemy:
		cmp [word ptr si + 10], 0 ; check if enemy is hurt
		je MoveEnemyLabel
		cmp [word ptr si + 8], 50 ; check if hurt timer is over
		jb MoveEnemyLabel
		mov [word ptr si + 10], 0
		mov [word ptr si + 8], 0

	MoveEnemyLabel:
		push si
		call MoveEnemy

	; if player is hurt, skip colliding with enemy
	cmp [byte ptr isHurt], 1
	je CheckSwordEnemyCollision
	push [word ptr x]
	push [word ptr y]
	push si
	call CheckEnemyCollision
	cmp ax, 0
	je CheckSwordEnemyCollision

	; enemy deals 16 damage minus armor
	sub [byte ptr health], 16
	mov al, [byte ptr armorPoints]
	add [byte ptr health], al
	mov [byte ptr isHurt], 1
	call DrawUI

	CheckSwordEnemyCollision:
		cmp [byte ptr isAttacking], 0
		je DrawEnemy

		push [word ptr swordX]
		push [word ptr swordY]
		push si
		call CheckEnemyCollision
		cmp ax, 0
		je DrawEnemy

		cmp [word ptr si + 10], 1 ; if enemy is hurt, then skip hurting him
		je DrawEnemy

		mov [word ptr si + 10], 1 ; set isHurt to true
		mov [word ptr si + 8], 0 ; set hurtTimer to 0
		; remove from enemy health 5 plus sword
		sub [word ptr si + 6], 5
		mov al, [byte ptr swordPoints]
		xor ah, ah
		sub [word ptr si + 6], ax
	
	DrawEnemy:
		push SCREEN
		push [word ptr si + 0]
		push [word ptr si + 2]

		; sets tile according to if enemy is hurt
		mov ax, 1Dh
		cmp [word ptr si + 10], 0
		je DrawEnemyTile
		inc [word ptr si + 8]
		mov bx, [word ptr si + 8]
		shr bx, 3
		and bx, 1
		jz DrawEnemyTile
		inc ax

	DrawEnemyTile:
		push ax
		call DrawTile

	RetUpdateEnemy:
		popa
		pop bp
		ret 2
endp UpdateEnemy

; GetCurrentScreenEnemies
; action: returns the offset of the current screen's enemies and their count
; parameters: none
; returns: ax - offset, bx - count
proc GetCurrentScreenEnemies
	push cx
	push dx
	push si

	xor si, si
	xor ax, ax
	GetEnemyOffset:
		mov bl, [byte ptr enemiesCountPerScreen + si]
		xor bh, bh
		mov cl, [byte ptr currentScreen]
		xor ch, ch
		cmp si, cx
		je CalculateEnemyOffset
		add ax, bx
		inc si
		jmp GetEnemyOffset
	
	CalculateEnemyOffset:
		mov cx, 12
		mul cx
		add ax, offset enemies
	
	pop si
	pop dx
	pop cx
	ret
endp GetCurrentScreenEnemies


; ChangeEnemiesDirection
; action: changes the enemies' direction if a certain time has passed
; parameters: none
; returns: nothing
proc ChangeEnemiesDirection
	push bp
	mov bp, sp
	pusha

	cmp [byte ptr enemiesMovementCount], 10
	jb RetChangeEnemiesDirection

	call GetCurrentScreenEnemies
	mov si, ax
	ChangeEnemiesDirectionLoop:
		cmp bx, 0
		je EndChangeEnemiesDirection

		push 0
		push 4
		call Random
		mov [word ptr si + 4], ax

		add si, 12
		dec bx
		jmp ChangeEnemiesDirectionLoop

	EndChangeEnemiesDirection:
		mov [byte ptr enemiesMovementCount], 0

	RetChangeEnemiesDirection:
		popa
		pop bp
		ret
endp ChangeEnemiesDirection

; UpdateEnemies
; action: updates all enemies in current screen
; parameters: none
; returns: nothing
proc UpdateEnemies
	push bp
	mov bp, sp
	pusha

	call GetCurrentScreenEnemies
	UpdateEnemiesLoop:
		cmp bx, 0
		je RetUpdateEnemies
		
		push ax
		call UpdateEnemy
		add ax, 12
		dec bx
		jmp UpdateEnemiesLoop

	RetUpdateEnemies:
		inc [byte ptr enemiesMovementCount]
		call ChangeEnemiesDirection
		mov [byte ptr isAttacking], 0
		popa
		pop bp
		ret
endp UpdateEnemies

; EraseEnemies
; action: erases all enemies from screen
; parameters: none
; returns: nothing
proc EraseEnemies
	push bp
	mov bp, sp
	pusha

	call GetCurrentScreenEnemies
	mov si, ax
	EraseEnemiesLoop:
		cmp bx, 0
		je RetEraseEnemies
		push [word ptr si + 0]
		push [word ptr si + 2]
		call Erase
		add si, 12
		dec bx
		jmp EraseEnemiesLoop

	RetEraseEnemies:
		popa
		pop bp
		ret
endp EraseEnemies

; UpdateHurtTimer
; action: updates the hurt timer, and if it's over then set isHurt to false
; parameters: none
; returns: nothing
proc UpdateHurtTimer
	pusha

	cmp [byte ptr isHurt], 0
	je RetUpdateHurtTimer
	cmp [byte ptr hurtTimer], 100
	jb RetUpdateHurtTimer
	mov [byte ptr isHurt], 0
	mov [byte ptr hurtTimer], 0

	RetUpdateHurtTimer:
		popa
		ret
endp UpdateHurtTimer


; PlayNote
; action: playes the current note and increment note index
; parameters: none
; returns: nothing
proc PlayNote
	pusha

	add [word ptr currentNoteCount], 1
	mov ax, [word ptr noteCount]
	cmp [word ptr currentNoteCount], ax
	jl RetPlayNote

	mov ax, [word ptr noteIndex]
	mov bx, musicSize
	xor dx, dx
	div bx
	mov si, dx
	mov [word ptr noteIndex], si
	add [word ptr noteIndex], 4

	mov al, [byte ptr music + si + 0]
	push ax
	mov al, [byte ptr music + si + 1]
	push ax
	call WriteToOPL

	mov ax, [word ptr music + si + 2]
	mov [word ptr noteCount], ax
	mov [word ptr currentNoteCount], 0

	RetPlayNote:
		popa
		ret
endp PlayNote

; WriteToOPL
; action: writes a value to an OPL (music) register
; parameters:
register_WriteToOPL equ [word ptr bp + 6] ; the target register
value_WriteToOPL equ [word ptr bp + 4] ; the value
; returns: nothing
proc WriteToOPL
	push bp
	mov bp, sp
	pusha

	mov dx, 388h
	mov ax, register_WriteToOPL
	out dx, al

	mov dx, 389h
	mov ax, value_WriteToOPL
	out dx, al

	popa
	pop bp
	ret 4
endp WriteToOPL


; SetOPLRegisters
; action: sets a range of OPL registers to the same value
; parameters:
first_SetOPLRegisters equ [word ptr bp + 8] ; first register
last_SetOPLRegisters equ [word ptr bp + 6] ; last register
value_SetOPLRegisters equ [word ptr bp + 4] ; value to set
; returns: nothing
proc SetOPLRegisters
	push bp
	mov bp, sp
	pusha

	mov cx, first_SetOPLRegisters
	SetOPLRegistersLoop:
		push cx
		push value_SetOPLRegisters
		call WriteToOPL

		inc cx
		cmp cx, last_SetOPLRegisters
		jbe SetOPLRegistersLoop

	popa
	pop bp
	ret 6
endp SetOPLRegisters


; ResetOPL
; action: resets OPL (makes it not play any sounds)
; taken from here: https://github.com/stargo/resetopl/blob/master/resetopl.c
; parameters: none
; returns: nothing
proc ResetOPL
	pusha

	push 20h
	push 35h
	push 0
	call SetOPLRegisters

	push 0A0h
	push 0A8h
	push 0
	call SetOPLRegisters

	push 0B0h
	push 0B8h
	push 0
	call SetOPLRegisters

	push 0BDh
	push 0BDh
	push 0
	call SetOPLRegisters

	push 0C0h
	push 0C8h
	push 0
	call SetOPLRegisters

	push 0E0h
	push 0F5h
	push 0
	call SetOPLRegisters

	push 08h
	push 08h
	push 0
	call SetOPLRegisters

	push 01h
	push 01h
	push 0
	call SetOPLRegisters

	popa
	ret
endp ResetOPL

; SetDirectionAndMove
; action: sets direction according to key and move the player
; parameters:
key_SetDirectionAndMove equ [word ptr bp + 4] ; the key
; returns: nothing
proc SetDirectionAndMove
	push bp
	mov bp, sp
	pusha

	mov ax, key_SetDirectionAndMove
	cmp ax, 11h
	je OneOfMovementKeys
	cmp ax, 1Eh
	jb RetSetDirectionAndMove
	cmp ax, 20h
	ja RetSetDirectionAndMove

	OneOfMovementKeys:
		sub ax, 11h
		mov bx, 0Ch
		xor dx, dx
		div bx
		cmp dx, 3
		ja RetSetDirectionAndMove

	mov [byte ptr playerDirection], dl
	mov [byte ptr isMoving], 1

	RetSetDirectionAndMove:
		popa
		pop bp
		ret 2
endp SetDirectionAndMove

; MoveScreenUp
; action: moves the screen up
; parameters: none
; returns: nothing
proc MoveScreenUp
	pusha
	push ds
	push es

	sub [byte ptr currentScreen], 6
	push SCREEN
	call DrawWorld

	mov cx, 120
	MoveScreenUpLoop:
		push cx
		
		mov ax, cx
		mov bx, 320
		mul bx
		mov bx, ax

		mov si, 38080
		mov di, 38400

		mov cx, 119
		MoveScreenUpLoopInner:
			push cx

			mov ax, 0A000h
			mov ds, ax
			mov es, ax

			mov cx, 320
			std
			rep movsb

			pop cx
			loop MoveScreenUpLoopInner
		
		mov ax, SCREEN
		mov ds, ax

		mov cx, 320
		mov si, bx
		rep movsb

		pop cx

		pop es
		pop ds
		call PlayNote
		call Delay
		push ds
		push es

		loop MoveScreenUpLoop

	pop es
	pop ds
	
	call DrawScreen
	mov [word ptr y], 111

	popa
	ret
endp MoveScreenUp


; MoveScreenDown
; action: moves the screen down
; parameters: none
; returns: nothing
proc MoveScreenDown
	pusha
	push ds
	push es

	add [byte ptr currentScreen], 6
	push SCREEN
	call DrawWorld

	mov cx, 120
	MoveScreenDownLoop:
		push cx

		mov ax, cx
		neg ax
		add ax, 120
		mov bx, 320
		mul bx
		mov bx, ax

		mov si, 320
		xor di, di

		mov cx, 119
		MoveScreenDownLoopInner:
			push cx

			mov ax, 0A000h
			mov ds, ax
			mov es, ax

			mov cx, 320
			cld
			rep movsb

			pop cx
			loop MoveScreenDownLoopInner

		mov ax, SCREEN
		mov ds, ax

		mov cx, 320
		mov si, bx
		rep movsb
		
		pop cx

		pop es
		pop ds
		call PlayNote
		call Delay
		push ds
		push es

		loop MoveScreenDownLoop

	pop es
	pop ds

	call DrawScreen
	mov [word ptr y], 1

	popa
	ret
endp MoveScreenDown


; MoveScreenRight
; action: moves the screen right
; parameters: none
; returns: nothing
proc MoveScreenRight
	pusha
	push ds
	push es

	add [byte ptr currentScreen], 1
	push SCREEN
	call DrawWorld

	mov cx, 320
	MoveScreenRightLoop:
		push cx
		mov bx, cx

		mov si, 1
		xor di, di

		mov cx, 120
		MoveScreenRightLoopInner:
			push cx

			mov ax, 0A000h
			mov es, ax
			mov ds, ax

			mov cx, 319
			cld
			rep movsb

			mov ax, SCREEN
			mov ds, ax
			sub si, bx
			movsb
			add si, bx

			pop cx
			loop MoveScreenRightLoopInner

		pop cx

		pop es
		pop ds
		call PlayNote
		call Delay
		push ds
		push es

		loop MoveScreenRightLoop

	pop es
	pop ds

	call DrawScreen
	mov [word ptr x], 1

	popa
	ret
endp MoveScreenRight


; MoveScreenLeft
; action: moves the screen left
; parameters: none
; returns: nothing
proc MoveScreenLeft
	pusha
	push ds
	push es

	sub [byte ptr currentScreen], 1
	push SCREEN
	call DrawWorld

	mov cx, 320
	MoveScreenLeftLoop:
		push cx
		mov bx, cx
		neg bx
		add bx, 320

		mov si, 318
		mov di, 319

		mov cx, 120
		MoveScreenLeftLoopInner:
			push cx
			
			mov ax, 0A000h
			mov ds, ax
			mov es, ax

			mov cx, 319
			std
			rep movsb

			mov ax, SCREEN
			mov ds, ax
			
			add si, 320
			sub si, bx
			movsb
			add si, bx
			add si, 320
			add di, 640

			pop cx
			loop MoveScreenLeftLoopInner
		
		pop cx

		pop es
		pop ds
		call PlayNote
		call Delay
		push ds
		push es

		loop MoveScreenLeftLoop

	pop es
	pop ds

	call DrawScreen
	mov [word ptr x], 311

	popa
	ret
endp MoveScreenLeft


; ScreenWaitForESC
; action: shows a full screen (320x200) bmp, and waits for ESC to be pressed
; parameters:
filename_ScreenWaitForESC equ [word ptr bp + 4] ; the bmp filename
; returns: nothing
proc ScreenWaitForESC
	push bp
	mov bp, sp
	pusha

	push filename_ScreenWaitForESC
	call DrawBMP

	call ResetOPL

	ScreenWaitForESCLoop:
		xor ah, ah
		int 16h
		cmp ah, 01h
		jne ScreenWaitForESCLoop

	popa
	pop bp
	ret 2
endp ScreenWaitForESC

; MainMenu
; action: shows the main menu and all its sub-screens
; parameters: none
; returns: nothing
proc MainMenu

	DrawMainMenu:
		push offset mainMenuFilename
		call DrawBMP
	
	mov [word ptr noteIndex], 0
	call ResetOPL
	mov ax, 0C00h
	int 21h

	xor bx, bx

	MainMenuLoop:
		xor ah, ah
		int 16h

		cmp ah, 39h
		je RetMainMenu
		cmp ah, 1Ch
		je DrawStory
		cmp ah, 2Eh
		je DrawCredits
		cmp ah, 01h
		je StopMainMenu

		jmp MainMenuLoop
	
	DrawStory:
		push offset storyScreenFilename
		call ScreenWaitForESC
		jmp DrawMainMenu
	
	DrawCredits:
		push offset creditsScreenFilename
		call ScreenWaitForESC
		jmp DrawMainMenu
	
	StopMainMenu:
		mov bx, 1

	RetMainMenu:
		mov ax, bx
		ret
endp MainMenu


start:
	mov ax, @data
	mov ds, ax
	
	mov ax, 13h
	int 10h
	
	; load tileset
	push offset tilesetFilename
	push 128
	push 32
	push offset tileset
	call LoadBMP

	; load minimap
	push offset minimapFilename
	push 144
	push 48
	push offset minimap
	call LoadBMP


	call LoadMusic

	MainMenuLabel:
		call MainMenu
		cmp ax, 1
		jne StartGame
		jmp exit

	StartGame:
		push SCREEN
		call DrawWorld
		call DrawUI
	
	WaitForKey:
		in al, 64h
		cmp al, 10b
		je WaitForKey
		in al, 60h

		cmp al, 02h
		je UpgradeArmorLabel
		cmp al, 03h
		je UpgradeSwordLabel
		cmp al, 04h
		je UpgradeRingLabel

		cmp al, 39h
		je Mining

		cmp al, 25h
		je Attacking

		xor ah, ah
		push ax
		call SetDirectionAndMove

		cmp al, 01h
		jne GameLoop
		jmp MainMenuLabel
	
	Mining:
		call CheckMine
		jmp GameLoop
	
	Attacking:
		mov [byte ptr isAttacking], 1
		jmp GameLoop
	
	UpgradeArmorLabel:
		push 9
		push 0
		push 0
		push offset armorPoints
		call UpgradeStats
		jmp GameLoop

	UpgradeSwordLabel:
		push 2
		push 7
		push 1
		push offset swordPoints
		call UpgradeStats
		jmp GameLoop

	UpgradeRingLabel:
		push 0
		push 3
		push 8
		push offset ringPoints
		call UpgradeStats

	GameLoop:
		; erase stuff
		call EraseEnemies
		push [word ptr swordX]
		push [word ptr swordY]
		call Erase
		push [word ptr x]
		push [word ptr y]
		call Erase

		call Move

		call UpdateHurtTimer

		call DrawSword
		call UpdateEnemies
		call DrawPlayer

		call DrawScreen

		mov cx, 10 ; for EndFrameLoop

		cmp [byte ptr health], 0
		jg CheckEnemyCount
		push offset loseScreenFilename
		call ScreenWaitForESC
		jmp exit

		CheckEnemyCount:
			cmp [byte ptr enemiesAlive], 0
			jg EndFrameLoop
			push offset winScreenFilename
			call ScreenWaitForESC
			jmp exit
		
		EndFrameLoop:
			call Delay
			call PlayNote
			loop EndFrameLoop
		
		jmp WaitForKey
	
exit:
	call ResetOPL

	; text mode
	mov ax, 02h
	int 10h

	; exit program
	mov ax, 4C00h
	int 21h
END start