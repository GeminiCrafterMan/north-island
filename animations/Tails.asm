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
TailsAni_Dummy1_ptr:	offsetTableEntry.w TailsAni_Dummy	; 10 ;  $A
TailsAni_Dummy2_ptr:	offsetTableEntry.w TailsAni_Dummy	; 11 ;  $B
TailsAni_Dummy3_ptr:	offsetTableEntry.w TailsAni_Dummy	; 12 ;  $C
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
TailsAni_Dummy4_ptr:	offsetTableEntry.w TailsAni_Dummy	; 29 ; $1D
TailsAni_Dummy5_ptr:	offsetTableEntry.w TailsAni_Dummy	; 30 ; $1E
TailsAni_HaulAss_ptr:	offsetTableEntry.w TailsAni_HaulAss	; 31 ; $1F
TailsAni_Fly_ptr:	offsetTableEntry.w TailsAni_Fly		; 32 ; $20
TailsAni_Fly2_ptr:	offsetTableEntry.w TailsAni_Fly2	; 33 ; $21
TailsAni_Tired_ptr:	offsetTableEntry.w TailsAni_Tired	; 34 ; $22
TailsAni_Carry_ptr:	offsetTableEntry.w TailsAni_Carry	; 35 ; $23
TailsAni_CarryUp_ptr:	offsetTableEntry.w TailsAni_CarryUp	; 36 ; $24
TailsAni_AirRoll_ptr:	offsetTableEntry.w TailsAni_AirRoll	; 37 ; $25
TailsAni_Fall_ptr:	offsetTableEntry.w TailsAni_Fall	; 38 ; $26
TailsAni_Victory_ptr:	offsetTableEntry.w TailsAni_Victory	; 39 ; $27
TailsAni_CarryTired_ptr:	offsetTableEntry.w TailsAni_CarryTired	; 40 ; $28
TailsAni_Swim_ptr:	offsetTableEntry.w TailsAni_Swim	; 41 ; $29
TailsAni_Swim2_ptr:	offsetTableEntry.w TailsAni_Swim2	; 42 ; $2A
TailsAni_SwimTired_ptr:	offsetTableEntry.w TailsAni_SwimTired	; 43 ; $2B
TailsAni_SwimCarry_ptr:	offsetTableEntry.w TailsAni_SwimCarry		; 44 ; $2C

TailsAni_Walk:	dc.b $FF,frT_Walk13,frT_Walk14,frT_Walk15,frT_Walk16,frT_Walk17,frT_Walk18, frT_Walk11, frT_Walk12,afEnd
	rev02even
TailsAni_Run:	dc.b $FF,frT_Run11,frT_Run12,frT_Run13,frT_Run14,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
TailsAni_Roll:	dc.b   1,frT_Roll3,frT_Roll2,frT_Roll1,afEnd
	rev02even
TailsAni_Roll2:	dc.b   1,frT_Roll3,frT_Roll2,frT_Roll1,afEnd
	rev02even
TailsAni_Push:	dc.b $FD,frT_Push1,frT_Push2,frT_Push3,frT_Push4,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
TailsAni_Wait:	dc.b   7,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle3,  frT_Idle2,  frT_Idle1,  frT_Idle1,  frT_Idle1
		dc.b   frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle3,  frT_Idle2,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1,  frT_Idle1
		dc.b   frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4,  frT_Idle4
		dc.b   frT_Idle5,  frT_Idle6,  frT_Idle7,  frT_Idle6,  frT_Idle7,  frT_Idle6,  frT_Idle7,  frT_Idle6,  frT_Idle7,  frT_Idle6,  frT_Idle7,  frT_Idle5,afBack,$1C
	rev02even
TailsAni_Balance:	dc.b   13,frT_Balance1,frT_Balance2,afEnd
	rev02even
TailsAni_LookUp:	dc.b 5, frT_LookUp1, frT_LookUp2,afBack,  1
	rev02even
TailsAni_Duck:		dc.b 5,frT_Duck1,frT_Duck2,afBack,  1
	rev02even
TailsAni_Spindash:	dc.b   0,frT_SpDsh1,frT_SpDsh2,frT_SpDsh3,afEnd
	rev02even
TailsAni_Dummy:		dc.b $3F,frT_Choke,afEnd
	rev02even
TailsAni_Stop:		dc.b   7,frT_Skid1,frT_Skid2,frT_Skid1,frT_Skid2,afChange,  0
	rev02even
TailsAni_Float:		dc.b   9,frT_Float1,frT_FloatB,afEnd
	rev02even
TailsAni_Float2:	dc.b   9,frT_Float1,frT_Float2,frT_Float3,frT_Float4,frT_Float5,afEnd
	rev02even
TailsAni_Spring:	dc.b   3,frT_Spring1,frT_Spring2,afEnd
	rev02even
TailsAni_Hang:		dc.b   5,frT_Cling1,frT_Cling2,afEnd
	rev02even
TailsAni_Blink:		dc.b  $F,  frT_Idle1,  frT_Idle2,  frT_Idle3,afBack,  1
	rev02even
TailsAni_Blink2:	dc.b  $F,  frT_Idle1,  frT_Idle2,afBack,  1
	rev02even
TailsAni_Hang2:		dc.b $13,frT_Hang1,frT_Hang2,afEnd
	rev02even
TailsAni_Bubble:	dc.b  $B,frT_Bubble,frT_Bubble,frT_Walk15,frT_Walk16,afChange,  0 ; breathe
	rev02even
TailsAni_DeathBW:	dc.b $20,frT_Burnt,afEnd
	rev02even
TailsAni_Drown:		dc.b $2F,frT_Drown,afEnd
	rev02even
TailsAni_Death:		dc.b   3,frT_Death,afEnd
	rev02even
TailsAni_Hurt:		dc.b   3,frT_Death,afEnd
	rev02even
TailsAni_Hurt2:		dc.b   3,frT_Hurt,afEnd
	rev02even
TailsAni_Slide:		dc.b   9,frT_Slide,frT_Hurt,afEnd
	rev02even
TailsAni_Blank:		dc.b $77,  frT_Null,afChange,  0
	rev02even
TailsAni_HaulAss:	dc.b $FF,frT_Mach11,frT_Mach12,afEnd,afEnd,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
TailsAni_Fly:		dc.b   1,frT_Fly1,afEnd
	rev02even
TailsAni_AirRoll:	dc.b   1,  frT_AirRoll1,  frT_AirRoll2,  frT_AirRoll3,afChange, 2	; transition to rolling
	rev02even
TailsAni_Fall:	dc.b	2,	frT_FallT,	frT_Fall1, frT_Fall2,afBack, 2
	rev02even
TailsAni_Victory:	dc.b	4, frT_Win1, frT_Win2, frT_Win3, frT_Win4, frT_Win5, frT_Win6, frT_Win7, frT_Win8, afBack, 1
	rev02even
TailsAni_Fly2:		dc.b   $1F,frT_Fly1,$FF
	rev02even
TailsAni_Tired:		dc.b   $B,frT_FlyT1,frT_FlyT2,$FF
	rev02even
TailsAni_Carry:		dc.b   $1F,frT_FlyC1,$FF
	rev02even
TailsAni_CarryUp:		dc.b   $1F,frT_FlyC2,$FF
	rev02even
TailsAni_CarryTired:	dc.b   $B,frT_FlyCT1,frT_FlyCT2,$FF
	rev02even
TailsAni_Swim:		dc.b   7, frT_Swim1, frT_Swim2, frT_Swim3, frT_Swim4, frT_Swim5, $FF
	rev02even
TailsAni_Swim2:		dc.b   3, frT_Swim1, frT_Swim2, frT_Swim3, frT_Swim4, frT_Swim5, $FF
	rev02even
TailsAni_SwimTired:		dc.b   $B, frT_SwimT1, frT_SwimT2, frT_SwimT3, $FF
	rev02even
TailsAni_SwimCarry:		dc.b   4, frT_SwimC1, frT_SwimC2,$FF
	even

; Frame IDs
	phase 0 ; Reset ds.b value to 0

frT_Null	ds.b 1	; 0

frT_Idle1	ds.b 1
frT_Idle2	ds.b 1
frT_Idle3	ds.b 1
frT_Idle4	ds.b 1
frT_Idle5	ds.b 1
frT_Idle6	ds.b 1
frT_Idle7	ds.b 1
; Look up
frT_LookUp1	ds.b 1
frT_LookUp2	ds.b 1
; Walk
frT_Walk11	ds.b 1
frT_Walk12	ds.b 1
frT_Walk13	ds.b 1
frT_Walk14	ds.b 1
frT_Walk15	ds.b 1
frT_Walk16	ds.b 1
frT_Walk17	ds.b 1
frT_Walk18	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frT_Walk2X	ds.b 8
frT_Walk3X	ds.b 8
frT_Walk4X	ds.b 8
; fest
frT_Run11	ds.b 1
frT_Run12	ds.b 1
frT_Run13	ds.b 1
frT_Run14	ds.b 1
frT_Mach11	ds.b 1
frT_Mach12	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frT_Run2X	ds.b 4
frT_Mach2X	ds.b 2
frT_Run3X	ds.b 4
frT_Mach3X	ds.b 2
frT_Run4X	ds.b 4
frT_Mach4X	ds.b 2
; speeeeeeeeeeeeEEEEEEEEEEEN
frT_Roll1	ds.b 1
frT_Roll2	ds.b 1
frT_Roll3	ds.b 1
; boing
frT_Spring1	ds.b 1
frT_Spring2	ds.b 1
; ducc
frT_Duck1	ds.b 1
frT_Duck2	ds.b 1
; hurt and slide
frT_Hurt	ds.b 1
frT_Slide	ds.b 1
; ded
frT_Death	ds.b 1
frT_Drown	ds.b 1
frT_Burnt	ds.b 1
; flight
frT_Fly1	ds.b 1
; dash
frT_SpDsh1	ds.b 1
frT_SpDsh2	ds.b 1
frT_SpDsh3	ds.b 1
; poosh
frT_Push1	ds.b 1
frT_Push2	ds.b 1
frT_Push3	ds.b 1
frT_Push4	ds.b 1
; Skid and turn
frT_Skid1	ds.b 1
frT_Skid2	ds.b 1
; Balance
frT_Balance1	ds.b 1
frT_Balance2	ds.b 1
; cling
frT_Cling1	ds.b 1
frT_Cling2	ds.b 1
; float
frT_Float1	ds.b 1
frT_Float2	ds.b 1
frT_Float3	ds.b 1
frT_Float4	ds.b 1
frT_Float5	ds.b 1
frT_FloatB	ds.b 1
; bubble bobble nes
frT_Bubble	ds.b 1
; tumble
frT_Tumble1	ds.b 1
frT_TumbleX	ds.b 11	; entirely unnecessary
; hang from vine
frT_Hang1	ds.b 1
frT_Hang2	ds.b 1
; Placeholder
frT_Choke	ds.b 1
; Air roll
frT_AirRoll1	ds.b 1
frT_AirRoll2	ds.b 1
frT_AirRoll3	ds.b 1
; Fall
frT_FallT	ds.b 1
frT_Fall1	ds.b 1
frT_Fall2	ds.b 1
; victory
frT_Win1	ds.b 1
frT_Win2	ds.b 1
frT_Win3	ds.b 1
frT_Win4	ds.b 1
frT_Win5	ds.b 1
frT_Win6	ds.b 1
frT_Win7	ds.b 1
frT_Win8	ds.b 1
; flight Tired
frT_FlyT1	ds.b 1
frT_FlyT2	ds.b 1
; flight Carry
frT_FlyC1	ds.b 1
frT_FlyC2	ds.b 1
; flight Carry Tired
frT_FlyCT1	ds.b 1
frT_FlyCT2	ds.b 1
; swimming
frT_Swim1	ds.b 1
frT_Swim2	ds.b 1
frT_Swim3	ds.b 1
frT_Swim4	ds.b 1
frT_Swim5	ds.b 1
; swimming Tired
frT_SwimT1	ds.b 1
frT_SwimT2	ds.b 1
frT_SwimT3	ds.b 1
; swimming Carry
frT_SwimC1	ds.b 1
frT_SwimC2	ds.b 1
	even
	even
	dephase