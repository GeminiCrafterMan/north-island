; ---------------------------------------------------------------------------
; Animation script - Sonic
; ---------------------------------------------------------------------------
; off_1B618:
SonicAniData:			offsetTable
SonAni_Walk_ptr:		offsetTableEntry.w SonAni_Walk		;  0 ;   0
SonAni_Run_ptr:			offsetTableEntry.w SonAni_Run		;  1 ;   1
SonAni_Roll_ptr:		offsetTableEntry.w SonAni_Roll		;  2 ;   2
SonAni_Roll2_ptr:		offsetTableEntry.w SonAni_Roll2		;  3 ;   3
SonAni_Push_ptr:		offsetTableEntry.w SonAni_Push		;  4 ;   4
SonAni_Wait_ptr:		offsetTableEntry.w SonAni_Wait		;  5 ;   5
SonAni_Balance_ptr:		offsetTableEntry.w SonAni_Balance	;  6 ;   6
SonAni_LookUp_ptr:		offsetTableEntry.w SonAni_LookUp	;  7 ;   7
SonAni_Duck_ptr:		offsetTableEntry.w SonAni_Duck		;  8 ;   8
SonAni_Spindash_ptr:		offsetTableEntry.w SonAni_Spindash	;  9 ;   9
SonAni_Blink_ptr:		offsetTableEntry.w SonAni_Blink		; 10 ;  $A
SonAni_GetUp_ptr:		offsetTableEntry.w SonAni_GetUp		; 11 ;  $B
SonAni_Balance2_ptr:		offsetTableEntry.w SonAni_Balance2	; 12 ;  $C
SonAni_Stop_ptr:		offsetTableEntry.w SonAni_Stop		; 13 ;  $D
SonAni_Float_ptr:		offsetTableEntry.w SonAni_Float		; 14 ;  $E
SonAni_Float2_ptr:		offsetTableEntry.w SonAni_Float2	; 15 ;  $F
SonAni_Spring_ptr:		offsetTableEntry.w SonAni_Spring	; 16 ; $10
SonAni_Hang_ptr:		offsetTableEntry.w SonAni_Hang		; 17 ; $11
SonAni_Dash2_ptr:		offsetTableEntry.w SonAni_Dash2		; 18 ; $12
SonAni_Dash3_ptr:		offsetTableEntry.w SonAni_Dash3		; 19 ; $13
SonAni_Hang2_ptr:		offsetTableEntry.w SonAni_Hang2		; 20 ; $14
SonAni_Bubble_ptr:		offsetTableEntry.w SonAni_Bubble	; 21 ; $15
SonAni_DeathBW_ptr:		offsetTableEntry.w SonAni_DeathBW	; 22 ; $16
SonAni_Drown_ptr:		offsetTableEntry.w SonAni_Drown		; 23 ; $17
SonAni_Death_ptr:		offsetTableEntry.w SonAni_Death		; 24 ; $18
SonAni_Hurt_ptr:		offsetTableEntry.w SonAni_Hurt		; 25 ; $19
SonAni_Hurt2_ptr:		offsetTableEntry.w SonAni_Hurt		; 26 ; $1A
SonAni_Slide_ptr:		offsetTableEntry.w SonAni_Slide		; 27 ; $1B
SonAni_Blank_ptr:		offsetTableEntry.w SonAni_Blank		; 28 ; $1C
SonAni_Balance3_ptr:	offsetTableEntry.w SonAni_Balance3	; 29 ; $1D
SonAni_Balance4_ptr:	offsetTableEntry.w SonAni_Balance4	; 30 ; $1E
SupSonAni_Transform_ptr:offsetTableEntry.w SupSonAni_Transform	; 31 ; $1F
SonAni_Lying_ptr:		offsetTableEntry.w SonAni_Lying		; 32 ; $20
SonAni_LieDown_ptr:		offsetTableEntry.w SonAni_LieDown	; 33 ; $21
						offsetTableEntry.w SonAni_Dummy
						offsetTableEntry.w SonAni_Dummy
						offsetTableEntry.w SonAni_Dummy
SonAni_AirRoll_ptr:		offsetTableEntry.w SonAni_AirRoll	; 34 ; $22
SonAni_Fall_ptr:		offsetTableEntry.w SonAni_Fall	; 34 ; $22
SonAni_Victory_ptr:		offsetTableEntry.w SonAni_Victory

SonAni_Walk:	dc.b $FF, frS_Walk13,frS_Walk14,frS_Walk15,frS_Walk16,frS_Walk17,frS_Walk18, frS_Walk11, frS_Walk12,afEnd
	rev02even
SonAni_Run:		dc.b $FF,frS_Run11,frS_Run12,frS_Run13,frS_Run14,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
SonAni_Roll:	dc.b $FE,frS_Roll1,frS_Roll5,frS_Roll2,frS_Roll5,frS_Roll3,frS_Roll5,frS_Roll4,frS_Roll5,afEnd
	rev02even
SonAni_Roll2:	dc.b $FE,frS_Roll1,frS_Roll5,frS_Roll2,frS_Roll5,frS_Roll3,frS_Roll5,frS_Roll4,frS_Roll5,afEnd
	rev02even
SonAni_Push:	dc.b $FD,frS_Push1,frS_Push2,frS_Push3,frS_Push4,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
SonAni_Wait:
	dc.b   5,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1
	dc.b   frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle1,  frS_Idle2
	dc.b   frS_Idle3,  frS_Idle3,  frS_Idle3,  frS_Idle3,  frS_Idle3,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5
	dc.b   frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle6,  frS_Idle6,  frS_Idle6
	dc.b   frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4
	dc.b   frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle6
	dc.b   frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4
	dc.b   frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5
	dc.b   frS_Idle5,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5
	dc.b   frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4,  frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle4,  frS_Idle4,  frS_Idle4
	dc.b   frS_Idle5,  frS_Idle5,  frS_Idle5,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle6,  frS_Idle7,  frS_Idle8,  frS_Idle8
	dc.b   frS_Idle8,  frS_Idle9,  frS_Idle9,  frS_Idle9,afBack,  6
	rev02even
SonAni_Balance:	dc.b   9,frS_BalanceA1,frS_BalanceA2,frS_BalanceA3,frS_BalanceA2,afEnd
	rev02even
SonAni_LookUp:	dc.b   5, frS_LookUp1, frS_LookUp2,afBack,  1
	rev02even
SonAni_Duck:	dc.b   5,frS_Duck1,frS_Duck2,afBack,  1
	rev02even
SonAni_Spindash:dc.b   0,frS_SpDsh1,frS_SpDsh2,frS_SpDsh1,frS_SpDsh3,frS_SpDsh1,frS_SpDsh4,frS_SpDsh1,frS_SpDsh5,frS_SpDsh1,frS_SpDsh6,afEnd
	rev02even
SonAni_Blink:	dc.b   1,  frS_Idle2,afChange,  0
	rev02even
SonAni_GetUp:	dc.b   3, frS_IdleA,afChange,  0
	rev02even
SonAni_Balance2:dc.b   3,frS_BalanceB1,frS_BalanceB2,frS_BalanceB3,frS_BalanceB4,afEnd
	rev02even
SonAni_Stop:	dc.b   5,frS_Skid1,frS_Skid2,frS_Skid3,frS_SkidT,afChange,  0 ; halt/skidding animation
	rev02even
SonAni_Float:	dc.b   7,frS_Float1,frS_FloatB,afEnd
	rev02even
SonAni_Float2:	dc.b   7,frS_Float1,frS_Float2,frS_Float3,frS_Float4,frS_Float5,afEnd
	rev02even
SonAni_Spring:	dc.b $2F,frS_Spring,afEnd	; spring > falling via code in MdNormal
	rev02even
SonAni_Hang:	dc.b   1,frS_Cling1,frS_Cling2,afEnd
	rev02even
SonAni_Dash2:	dc.b  $F,frS_SpDsh2,frS_SpDsh2,frS_SpDsh2,afBack,  1
	rev02even
SonAni_Dash3:	dc.b  $F,frS_SpDsh2,frS_SpDsh3,afBack,  1
	rev02even
SonAni_Hang2:	dc.b $13,frS_Hang1,frS_Hang2,afEnd
	rev02even
SonAni_Bubble:	dc.b  $B,frS_Bubble,frS_Bubble,frS_Walk15,frS_Walk16,afChange,  0 ; breathe
	rev02even
SonAni_DeathBW:	dc.b $20,frS_Burnt,afEnd
	rev02even
SonAni_Drown:	dc.b $20,frS_Drown,afEnd
	rev02even
SonAni_Death:	dc.b $20,frS_Death,afEnd
	rev02even
SonAni_Hurt:	dc.b $40,frS_Hurt,afEnd
	rev02even
SonAni_Slide:	dc.b   9,frS_Hurt,frS_Slide,afEnd
	rev02even
SonAni_Blank:	dc.b $77,  frS_Null,afChange,  0
	rev02even
SonAni_Balance3:dc.b $13,frS_BalanceC1,frS_BalanceC2,afEnd
	rev02even
SonAni_Balance4:dc.b   3,frS_BalanceT1,frS_BalanceB1,frS_BalanceB2,frS_BalanceB3,frS_BalanceB4,afBack,  4
	rev02even
SonAni_Lying:	dc.b   9,  frS_Idle8,  frS_Idle9,afEnd
	rev02even
SonAni_LieDown:	dc.b   3,  frS_Idle7,afChange,  0
	rev02even
SonAni_AirRoll:	dc.b   5,  frS_AirRoll,afChange, 2	; transition to rolling
	rev02even
SonAni_Fall:	dc.b	2,	frS_Fall1, frS_Fall2,afEnd
	rev02even
SonAni_Victory: dc.b	5,	frS_Win1, frS_Win2, frS_Win3, frS_Win4, afBack, 2
	rev02even
SonAni_Dummy:	dc.b	$7F,frS_Derp,afChange,0
	even

; ---------------------------------------------------------------------------
; Animation script - Super Sonic
; (many of these point to the data above this)
; ---------------------------------------------------------------------------
SuperSonicAniData: offsetTable
	offsetTableEntry.w SonAni_Walk	;  0 ;   0
	offsetTableEntry.w SonAni_Run	;  1 ;   1
	offsetTableEntry.w SonAni_Roll		;  2 ;   2
	offsetTableEntry.w SonAni_Roll2		;  3 ;   3
	offsetTableEntry.w SonAni_Push	;  4 ;   4
	offsetTableEntry.w SupSonAni_Stand	;  5 ;   5
	offsetTableEntry.w SonAni_Balance	;  6 ;   6
	offsetTableEntry.w SonAni_LookUp	;  7 ;   7
	offsetTableEntry.w SonAni_Duck	;  8 ;   8
	offsetTableEntry.w SonAni_Spindash	;  9 ;   9
	offsetTableEntry.w SonAni_Blink		; 10 ;  $A
	offsetTableEntry.w SonAni_GetUp		; 11 ;  $B
	offsetTableEntry.w SonAni_Balance2	; 12 ;  $C
	offsetTableEntry.w SonAni_Stop		; 13 ;  $D
	offsetTableEntry.w SonAni_Float		; 14 ;  $E
	offsetTableEntry.w SonAni_Float2	; 15 ;  $F
	offsetTableEntry.w SonAni_Spring	; 16 ; $10
	offsetTableEntry.w SonAni_Hang		; 17 ; $11
	offsetTableEntry.w SonAni_Dash2		; 18 ; $12
	offsetTableEntry.w SonAni_Dash3		; 19 ; $13
	offsetTableEntry.w SonAni_Hang2		; 20 ; $14
	offsetTableEntry.w SonAni_Bubble	; 21 ; $15
	offsetTableEntry.w SonAni_DeathBW	; 22 ; $16
	offsetTableEntry.w SonAni_Drown		; 23 ; $17
	offsetTableEntry.w SonAni_Death		; 24 ; $18
	offsetTableEntry.w SonAni_Hurt		; 25 ; $19
	offsetTableEntry.w SonAni_Hurt		; 26 ; $1A
	offsetTableEntry.w SonAni_Slide		; 27 ; $1B
	offsetTableEntry.w SonAni_Blank		; 28 ; $1C
	offsetTableEntry.w SonAni_Balance3	; 29 ; $1D
	offsetTableEntry.w SonAni_Balance4	; 30 ; $1E
	offsetTableEntry.w SupSonAni_Transform	; 31 ; $1F
	offsetTableEntry.w SonAni_Lying		; 32 ; $20
	offsetTableEntry.w SonAni_LieDown	; 33 ; $21
	offsetTableEntry.w SonAni_Dummy
	offsetTableEntry.w SonAni_Dummy
	offsetTableEntry.w SonAni_Dummy
	offsetTableEntry.w SonAni_AirRoll	; 34 ; $22
	offsetTableEntry.w SupSonAni_Fall	; 34 ; $22
	offsetTableEntry.w SonAni_Victory

SupSonAni_Stand:	dc.b   7,	frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle4,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle4
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle4,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle4
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle1,	frS_Idle2,	frS_Idle3,	frS_Idle2
					dc.b		frS_Idle4,	frS_Idle5,	frS_Idle6,	frS_Idle7,	frS_Idle8,	frS_Idle5,	frS_Idle6,	frS_Idle7,	frS_Idle8,	frS_Idle5,	frS_Idle6,	frS_Idle5,	frS_Idle4,afEnd
	rev02even
SupSonAni_Fall:		dc.b	2,	frS_Fall1, frS_Fall2,afBack, 1	; Alternate falling animation because I couldn't find a copy of the other in a Super state.
	even
SupSonAni_Transform:	dc.b   2,frS_Transform1,frS_Transform1,frS_Transform2,frS_Transform2,frS_Transform3,frS_Transform4,frS_Transform6,frS_Transform5,frS_Transform6,frS_Transform5,frS_Transform6,frS_Transform5,frS_Transform6,afChange,  0
	even

; Frame IDs
	phase 0 ; Reset ds.b value to 0

frS_Null	ds.b 1	; 0

frS_Idle1	ds.b 1
frS_Idle2	ds.b 1
frS_Idle3	ds.b 1
frS_Idle4	ds.b 1
frS_Idle5	ds.b 1
frS_Idle6	ds.b 1
frS_Idle7	ds.b 1
frS_Idle8	ds.b 1
frS_Idle9	ds.b 1
frS_IdleA	ds.b 1
; Look up
frS_LookUp1	ds.b 1
frS_LookUp2	ds.b 1
; Walk
frS_Walk11	ds.b 1
frS_Walk12	ds.b 1
frS_Walk13	ds.b 1
frS_Walk14	ds.b 1
frS_Walk15	ds.b 1
frS_Walk16	ds.b 1
frS_Walk17	ds.b 1
frS_Walk18	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frS_Walk2X	ds.b 8
frS_Walk3X	ds.b 8
frS_Walk4X	ds.b 8
; fest
frS_Run11	ds.b 1	; this,
frS_Run12	ds.b 1
frS_Run13	ds.b 1	; and this... are the same in Super
frS_Run14	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frS_Run2X	ds.b 4
frS_Run3X	ds.b 4
frS_Run4X	ds.b 4
; speeeeeeeeeeeeEEEEEEEEEEEN
frS_Roll1	ds.b 1
frS_Roll2	ds.b 1
frS_Roll3	ds.b 1
frS_Roll4	ds.b 1
frS_Roll5	ds.b 1
; dash
frS_SpDsh1	ds.b 1
frS_SpDsh2	ds.b 1
frS_SpDsh3	ds.b 1
frS_SpDsh4	ds.b 1
frS_SpDsh5	ds.b 1
frS_SpDsh6	ds.b 1
; poosh
frS_Push1	ds.b 1
frS_Push2	ds.b 1
frS_Push3	ds.b 1
frS_Push4	ds.b 1
; ducc
frS_Duck1	ds.b 1
frS_Duck2	ds.b 1
; hurt and slide
frS_Hurt	ds.b 1
frS_Slide	ds.b 1
; cling
frS_Cling1	ds.b 1
frS_Cling2	ds.b 1
; float
frS_Float1	ds.b 1
frS_Float2	ds.b 1
frS_Float3	ds.b 1
frS_Float4	ds.b 1
frS_Float5	ds.b 1
frS_FloatB	ds.b 1
; bubble bobble nes
frS_Bubble	ds.b 1
; boing
frS_Spring	ds.b 1
; ded
frS_Death	ds.b 1
frS_Drown	ds.b 1
frS_Burnt	ds.b 1
; tumble
frS_Tumble1	ds.b 1
frS_TumbleX	ds.b 11	; entirely unnecessary
; hang from vine/tails
frS_Hang1	ds.b 1
frS_Hang2	ds.b 1
; What a useless transformation. You changed your hair, so what?
frS_Transform1	ds.b 1
frS_Transform2	ds.b 1
frS_Transform3	ds.b 1
frS_Transform4	ds.b 1
frS_Transform5	ds.b 1
frS_Transform6	ds.b 1
; Balance B
frS_BalanceB1	ds.b 1
frS_BalanceB2	ds.b 1
frS_BalanceB3	ds.b 1
frS_BalanceB4	ds.b 1
; Balance A
frS_BalanceA1	ds.b 1
frS_BalanceA2	ds.b 1
frS_BalanceA3	ds.b 1
; Balance Turn
frS_BalanceT1	ds.b 1
; Balance C
frS_BalanceC1	ds.b 1
frS_BalanceC2	ds.b 1
; Skid and turn
frS_Skid1	ds.b 1
frS_Skid2	ds.b 1
frS_Skid3	ds.b 1
frS_SkidT	ds.b 1
; Placeholder
frS_Derp	ds.b 1
; Air roll (singular frame)
frS_AirRoll	ds.b 1
; Fall
frS_Fall1	ds.b 1
frS_Fall2	ds.b 1
; i win muahaha
frS_Win1	ds.b 1
frS_Win2	ds.b 1
frS_Win3	ds.b 1
frS_Win4	ds.b 1
; tumble roll
frS_TumbleRoll1	ds.b 1
frS_TumbleRollX	ds.b 11
	even
	dephase