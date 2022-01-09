; ---------------------------------------------------------------------------
; Animation script - Tails
; ---------------------------------------------------------------------------
; off_1D038:
TailsAniData:		offsetTable
TailsAni_Walk_ptr:	offsetTableEntry.w TailsAni_Walk	;  0 ;   0
TailsAni_Run_ptr:	offsetTableEntry.w TailsAni_Run		;  1 ;   1
TailsAni_Roll_ptr:	offsetTableEntry.w TailsAni_Roll	;  2 ;   2
TailsAni_Roll2_ptr:	offsetTableEntry.w TailsAni_Roll2	;  3 ;   3
TailsAni_Push_ptr:	offsetTableEntry.w TailsAni_Push	;  4 ;   4
TailsAni_Wait_ptr:	offsetTableEntry.w TailsAni_Wait	;  5 ;   5
TailsAni_Balance_ptr:	offsetTableEntry.w TailsAni_Balance	;  6 ;   6
TailsAni_LookUp_ptr:	offsetTableEntry.w TailsAni_LookUp	;  7 ;   7
TailsAni_Duck_ptr:	offsetTableEntry.w TailsAni_Duck	;  8 ;   8
TailsAni_Spindash_ptr:	offsetTableEntry.w TailsAni_Spindash	;  9 ;   9
TailsAni_Dummy1_ptr:	offsetTableEntry.w TailsAni_Dummy1	; 10 ;  $A
TailsAni_Dummy2_ptr:	offsetTableEntry.w TailsAni_Dummy2	; 11 ;  $B
TailsAni_Dummy3_ptr:	offsetTableEntry.w TailsAni_Dummy3	; 12 ;  $C
TailsAni_Stop_ptr:	offsetTableEntry.w TailsAni_Stop	; 13 ;  $D
TailsAni_Float_ptr:	offsetTableEntry.w TailsAni_Float	; 14 ;  $E
TailsAni_Float2_ptr:	offsetTableEntry.w TailsAni_Float2	; 15 ;  $F
TailsAni_Spring_ptr:	offsetTableEntry.w TailsAni_Spring	; 16 ; $10
TailsAni_Hang_ptr:	offsetTableEntry.w TailsAni_Hang	; 17 ; $11
TailsAni_Blink_ptr:	offsetTableEntry.w TailsAni_Blink	; 18 ; $12
TailsAni_Blink2_ptr:	offsetTableEntry.w TailsAni_Blink2	; 19 ; $13
TailsAni_Hang2_ptr:	offsetTableEntry.w TailsAni_Hang2	; 20 ; $14
TailsAni_Bubble_ptr:	offsetTableEntry.w TailsAni_Bubble	; 21 ; $15
TailsAni_DeathBW_ptr:	offsetTableEntry.w TailsAni_DeathBW	; 22 ; $16
TailsAni_Drown_ptr:	offsetTableEntry.w TailsAni_Drown	; 23 ; $17
TailsAni_Death_ptr:	offsetTableEntry.w TailsAni_Death	; 24 ; $18
TailsAni_Hurt_ptr:	offsetTableEntry.w TailsAni_Hurt	; 25 ; $19
TailsAni_Hurt2_ptr:	offsetTableEntry.w TailsAni_Hurt2	; 26 ; $1A
TailsAni_Slide_ptr:	offsetTableEntry.w TailsAni_Slide	; 27 ; $1B
TailsAni_Blank_ptr:	offsetTableEntry.w TailsAni_Blank	; 28 ; $1C
TailsAni_Dummy4_ptr:	offsetTableEntry.w TailsAni_Dummy4	; 29 ; $1D
TailsAni_Dummy5_ptr:	offsetTableEntry.w TailsAni_Dummy5	; 30 ; $1E
TailsAni_HaulAss_ptr:	offsetTableEntry.w TailsAni_HaulAss	; 31 ; $1F
TailsAni_Fly_ptr:	offsetTableEntry.w TailsAni_Fly		; 32 ; $20

TailsAni_Walk:	dc.b $FF,$10,$11,$12,$13,$14,$15, $E, $F,$FF
	rev02even
TailsAni_Run:	dc.b $FF,$2E,$2F,$30,$31,$FF,$FF,$FF,$FF,$FF
	rev02even
TailsAni_Roll:	dc.b   1,$48,$47,$46,$FF
	rev02even
TailsAni_Roll2:	dc.b   1,$48,$47,$46,$FF
	rev02even
TailsAni_Push:	dc.b $FD,$63,$64,$65,$66,$FF,$FF,$FF,$FF,$FF
	rev02even
TailsAni_Wait:	dc.b   7,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  2,  1,  1,  1
		dc.b   1,  1,  1,  1,  1,  3,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1
		dc.b   5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5
		dc.b   6,  7,  8,  7,  8,  7,  8,  7,  8,  7,  8,  6,$FE,$1C
	rev02even
TailsAni_Balance:	dc.b   9,$69,$69,$6A,$6A,$69,$69,$6A,$6A,$69,$69,$6A,$6A,$69,$69,$6A
			dc.b $6A,$69,$69,$6A,$6A,$69,$6A,$FF
	rev02even
TailsAni_LookUp:	dc.b $3F,  4,$FF
	rev02even
TailsAni_Duck:		dc.b $3F,$5B,$FF
	rev02even
TailsAni_Spindash:	dc.b   0,$60,$61,$62,$FF
	rev02even
TailsAni_Dummy1:	dc.b $3F,$82,$FF
	rev02even
TailsAni_Dummy2:	dc.b   7,  8,  8,  9,$FD,  5
	rev02even
TailsAni_Dummy3:	dc.b   7,  9,$FD,  5
	rev02even
TailsAni_Stop:		dc.b   7,$67,$68,$67,$68,$FD,  0
	rev02even
TailsAni_Float:		dc.b   9,$6E,$73,$FF
	rev02even
TailsAni_Float2:	dc.b   9,$6E,$6F,$70,$71,$72,$FF
	rev02even
TailsAni_Spring:	dc.b   3,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$FD,  0
	rev02even
TailsAni_Hang:		dc.b   5,$6C,$6D,$FF
	rev02even
TailsAni_Blink:		dc.b  $F,  1,  2,  3,$FE,  1
	rev02even
TailsAni_Blink2:	dc.b  $F,  1,  2,$FE,  1
	rev02even
TailsAni_Hang2:		dc.b $13,$85,$86,$FF
	rev02even
TailsAni_Bubble:	dc.b  $B,$74,$74,$12,$13,$FD,  0
	rev02even
TailsAni_DeathBW:	dc.b $20,$5D,$FF
	rev02even
TailsAni_Drown:		dc.b $2F,$5D,$FF
	rev02even
TailsAni_Death:		dc.b   3,$5D,$FF
	rev02even
TailsAni_Hurt:		dc.b   3,$5D,$FF
	rev02even
TailsAni_Hurt2:		dc.b   3,$5C,$FF
	rev02even
TailsAni_Slide:		dc.b   9,$6B,$5C,$FF
	rev02even
TailsAni_Blank:		dc.b $77,  0,$FD,  0
	rev02even
TailsAni_Dummy4:	dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,$FF
	rev02even
TailsAni_Dummy5:	dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,$FF
	rev02even
TailsAni_HaulAss:	dc.b $FF,$32,$33,$FF
			dc.b $FF,$FF,$FF,$FF,$FF,$FF
	rev02even
TailsAni_Fly:		dc.b   1,$5E,$5F,$FF
	even