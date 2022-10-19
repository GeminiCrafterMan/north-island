; ---------------------------------------------------------------------------
; Animation script - Amy
; ---------------------------------------------------------------------------
; off_1B618:
AmyAniData:			offsetTable
; I'd like to get rid of these later. No real reason to have them.
; "These" being the pointers.
AmyAni_Walk_ptr:		offsetTableEntry.w AmyAni_Walk		;  0 ;   0
AmyAni_Run_ptr:			offsetTableEntry.w AmyAni_Run		;  1 ;   1
AmyAni_Roll_ptr:		offsetTableEntry.w AmyAni_Roll		;  2 ;   2
AmyAni_Roll2_ptr:		offsetTableEntry.w AmyAni_Roll2		;  3 ;   3
AmyAni_Push_ptr:		offsetTableEntry.w AmyAni_Push		;  4 ;   4
AmyAni_Wait_ptr:		offsetTableEntry.w AmyAni_Wait		;  5 ;   5
AmyAni_Balance_ptr:		offsetTableEntry.w AmyAni_Balance	;  6 ;   6
AmyAni_LookUp_ptr:		offsetTableEntry.w AmyAni_LookUp	;  7 ;   7
AmyAni_Duck_ptr:		offsetTableEntry.w AmyAni_Duck		;  8 ;   8
AmyAni_Spindash_ptr:		offsetTableEntry.w AmyAni_Spindash	;  9 ;   9
AmyAni_Blink_ptr:		offsetTableEntry.w AmyAni_Blink		; 10 ;  $A
						offsetTableEntry.w AmyAni_Dummy		; 11 ;  $B
AmyAni_Balance2_ptr:		offsetTableEntry.w AmyAni_Balance2	; 12 ;  $C
AmyAni_Stop_ptr:		offsetTableEntry.w AmyAni_Stop		; 13 ;  $D
AmyAni_Float_ptr:		offsetTableEntry.w AmyAni_Float		; 14 ;  $E
AmyAni_Float2_ptr:		offsetTableEntry.w AmyAni_Float2	; 15 ;  $F
AmyAni_Spring_ptr:		offsetTableEntry.w AmyAni_Spring	; 16 ; $10
AmyAni_Hang_ptr:		offsetTableEntry.w AmyAni_Hang		; 17 ; $11
AmyAni_Dash2_ptr:		offsetTableEntry.w AmyAni_Dash2		; 18 ; $12
AmyAni_Dash3_ptr:		offsetTableEntry.w AmyAni_Dash3		; 19 ; $13
AmyAni_Hang2_ptr:		offsetTableEntry.w AmyAni_Hang2		; 20 ; $14
AmyAni_Bubble_ptr:		offsetTableEntry.w AmyAni_Bubble	; 21 ; $15
AmyAni_DeathBW_ptr:		offsetTableEntry.w AmyAni_DeathBW	; 22 ; $16
AmyAni_Drown_ptr:		offsetTableEntry.w AmyAni_Drown		; 23 ; $17
AmyAni_Death_ptr:		offsetTableEntry.w AmyAni_Death		; 24 ; $18
AmyAni_Hurt_ptr:		offsetTableEntry.w AmyAni_Hurt		; 25 ; $19
AmyAni_Hurt2_ptr:		offsetTableEntry.w AmyAni_Hurt		; 26 ; $1A
AmyAni_Slide_ptr:		offsetTableEntry.w AmyAni_Slide		; 27 ; $1B
AmyAni_Blank_ptr:		offsetTableEntry.w AmyAni_Blank		; 28 ; $1C
AmyAni_Balance3_ptr:	offsetTableEntry.w AmyAni_Balance3	; 29 ; $1D
AmyAni_Balance4_ptr:	offsetTableEntry.w AmyAni_Balance4	; 30 ; $1E
AmyAni_Transform_ptr:	offsetTableEntry.w AmyAni_Transform	; 31 ; $1F
AmyAni_Lying_ptr:		offsetTableEntry.w AmyAni_Lying		; 32 ; $20
AmyAni_LieDown_ptr:		offsetTableEntry.w AmyAni_LieDown	; 33 ; $21
						offsetTableEntry.w AmyAni_Dummy
						offsetTableEntry.w AmyAni_Dummy
						offsetTableEntry.w AmyAni_Dummy
						offsetTableEntry.w AmyAni_Dummy
AmyAni_Fall_ptr:		offsetTableEntry.w AmyAni_Fall	; 34 ; $22
AmyAni_Victory_ptr:		offsetTableEntry.w AmyAni_Victory

AmyAni_Walk:	dc.b $FF, frA_Walk13,frA_Walk14,frA_Walk15,frA_Walk16,frA_Walk17,frA_Walk18, frA_Walk11, frA_Walk12,afEnd
	rev02even
AmyAni_Run:		dc.b $FF,frA_Run11,frA_Run12,frA_Run13,frA_Run14,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
AmyAni_Roll:	dc.b $FE,frA_Roll1,frA_Roll5,frA_Roll2,frA_Roll5,frA_Roll3,frA_Roll5,frA_Roll4,frA_Roll5,afEnd
	rev02even
AmyAni_Roll2:	dc.b $FE,frA_Roll1,frA_Roll5,frA_Roll2,frA_Roll5,frA_Roll3,frA_Roll5,frA_Roll4,frA_Roll5,afEnd
	rev02even
AmyAni_Push:	dc.b $FD,frA_Push1,frA_Push2,frA_Push3,frA_Push4,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
AmyAni_Wait:
	dc.b   11,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1
	dc.b   frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle1,  frA_Idle2
	dc.b   frA_Idle3,  frA_Idle3,  frA_Idle3,  frA_Idle3,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5
	dc.b   frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5
	dc.b   frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5
	dc.b   frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5
	dc.b   frA_Idle3,  frA_Idle4,  frA_Idle3,  frA_Idle5,  frA_Idle3,  frA_Idle6,  frA_Idle8,  frA_Idle8,  frA_Idle9,  frA_Idle8,  frA_Idle8,  frA_Idle8,  frA_Idle9,  frA_Idle7,  frA_Idle7,  frA_Idle7
	dc.b   frA_Idle8,  frA_Idle8,  frA_Idle8,  frA_Idle9,  frA_Idle6,  afEnd
	rev02even
AmyAni_Balance:	dc.b   9,frA_BalanceA1,frA_BalanceA2,frA_BalanceA3,frA_BalanceA2,afEnd
	rev02even
AmyAni_LookUp:	dc.b   5, frA_LookUp1, frA_LookUp2,afBack,  1
	rev02even
AmyAni_Duck:	dc.b   5,frA_Duck1,frA_Duck2,afBack,  1
	rev02even
AmyAni_Spindash:dc.b   0,frA_SpDsh1,frA_SpDsh2,frA_SpDsh1,frA_SpDsh3,frA_SpDsh1,frA_SpDsh4,frA_SpDsh1,frA_SpDsh5,frA_SpDsh1,frA_SpDsh6,afEnd
	rev02even
AmyAni_Blink:	dc.b   1,  frA_Idle2,afChange,  0
	rev02even
AmyAni_Balance2:dc.b   3,frA_BalanceB1,frA_BalanceB2,frA_BalanceB3,frA_BalanceB4,afEnd
	rev02even
AmyAni_Stop:	dc.b   5,frA_Skid1,frA_Skid2,frA_Skid3,frA_SkidT,afChange,  0 ; halt/skidding animation
	rev02even
AmyAni_Float:	dc.b   7,frA_Float1,frA_FloatB,afEnd
	rev02even
AmyAni_Float2:	dc.b   7,frA_Float1,frA_Float2,frA_Float3,frA_Float4,frA_Float5,afEnd
	rev02even
AmyAni_Spring:	dc.b   3,frA_Spring1,frA_Spring2,afEnd	; spring > falling via code in MdNormal
	rev02even
AmyAni_Hang:	dc.b   1,frA_Cling1,frA_Cling2,afEnd
	rev02even
AmyAni_Dash2:	dc.b  $F,frA_SpDsh2,frA_SpDsh2,frA_SpDsh2,afBack,  1
	rev02even
AmyAni_Dash3:	dc.b  $F,frA_SpDsh2,frA_SpDsh3,afBack,  1
	rev02even
AmyAni_Hang2:	dc.b $13,frA_Hang1,frA_Hang2,afEnd
	rev02even
AmyAni_Bubble:	dc.b  $B,frA_Bubble,frA_Bubble,frA_Walk15,frA_Walk16,afChange,  0 ; breathe
	rev02even
AmyAni_DeathBW:	dc.b $20,frA_Burnt,afEnd
	rev02even
AmyAni_Drown:	dc.b $20,frA_Drown,afEnd
	rev02even
AmyAni_Death:	dc.b $20,frA_Death,afEnd
	rev02even
AmyAni_Hurt:	dc.b $40,frA_Hurt,afEnd
	rev02even
AmyAni_Slide:	dc.b   9,frA_Hurt,frA_Slide,afEnd
	rev02even
AmyAni_Blank:	dc.b $77,  frA_Null,afChange,  0
	rev02even
AmyAni_Balance3:dc.b $13,frA_BalanceC1,frA_BalanceC2,afEnd
	rev02even
AmyAni_Balance4:dc.b   3,frA_BalanceT1,frA_BalanceB1,frA_BalanceB2,frA_BalanceB3,frA_BalanceB4,afBack,  4
	rev02even
AmyAni_Lying:	dc.b   9,  frA_Idle8,  frA_Idle9,afEnd
	rev02even
AmyAni_LieDown:	dc.b   3,  frA_Idle7,afChange,  0
	rev02even
AmyAni_Fall:	dc.b	2,	frA_Fall1, frA_Fall2,afEnd
	rev02even
AmyAni_Victory: dc.b	9,	frA_Win1, frA_Win2, frA_Win3, frA_Win2, frA_Win1, frA_Win2, frA_Win3, frA_Win2, frA_Win1, frA_Win2, frA_Win3, frA_Win2, frA_Win4, frA_Win4, frA_Win5, afBack, 1
	rev02even
AmyAni_Transform:	dc.b   2,frA_Transform1,frA_Transform1,frA_Transform2,frA_Transform2,frA_Transform3,frA_Transform4,frA_Transform6,frA_Transform5,frA_Transform6,frA_Transform5,frA_Transform6,frA_Transform5,frA_Transform6,afChange,  0
	rev02even
AmyAni_Dummy:	dc.b	$7F,frA_Derp,afChange,0
	even

; Frame IDs
	phase 0 ; Reset ds.b value to 0

frA_Null	ds.b 1	; 0

frA_Idle1	ds.b 1
frA_Idle2	ds.b 1
frA_Idle3	ds.b 1
frA_Idle4	ds.b 1
frA_Idle5	ds.b 1
frA_Idle6	ds.b 1
frA_Idle7	ds.b 1
frA_Idle8	ds.b 1
frA_Idle9	ds.b 1
; Look up
frA_LookUp1	ds.b 1
frA_LookUp2	ds.b 1
; Walk
frA_Walk11	ds.b 1
frA_Walk12	ds.b 1
frA_Walk13	ds.b 1
frA_Walk14	ds.b 1
frA_Walk15	ds.b 1
frA_Walk16	ds.b 1
frA_Walk17	ds.b 1
frA_Walk18	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frA_Walk2X	ds.b 8
frA_Walk3X	ds.b 8
frA_Walk4X	ds.b 8
; fest
frA_Run11	ds.b 1	; this,
frA_Run12	ds.b 1
frA_Run13	ds.b 1	; and this... are the same in Super
frA_Run14	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frA_Run2X	ds.b 4
frA_Run3X	ds.b 4
frA_Run4X	ds.b 4
; speeeeeeeeeeeeEEEEEEEEEEEN
frA_Roll1	ds.b 1
frA_Roll2	ds.b 1
frA_Roll3	ds.b 1
frA_Roll4	ds.b 1
frA_Roll5	ds.b 1
; dash
frA_SpDsh1	ds.b 1
frA_SpDsh2	ds.b 1
frA_SpDsh3	ds.b 1
frA_SpDsh4	ds.b 1
frA_SpDsh5	ds.b 1
frA_SpDsh6	ds.b 1
; poosh
frA_Push1	ds.b 1
frA_Push2	ds.b 1
frA_Push3	ds.b 1
frA_Push4	ds.b 1
; ducc
frA_Duck1	ds.b 1
frA_Duck2	ds.b 1
; hurt and slide
frA_Hurt	ds.b 1
frA_Slide	ds.b 1
; cling
frA_Cling1	ds.b 1
frA_Cling2	ds.b 1
; float
frA_Float1	ds.b 1
frA_Float2	ds.b 1
frA_Float3	ds.b 1
frA_Float4	ds.b 1
frA_Float5	ds.b 1
frA_FloatB	ds.b 1
; bubble bobble nes
frA_Bubble	ds.b 1
; boing
frA_Spring1	ds.b 1
frA_Spring2	ds.b 1
; ded
frA_Death	ds.b 1
frA_Drown	ds.b 1
frA_Burnt	ds.b 1
; tumble
frA_Tumble1	ds.b 1
frA_TumbleX	ds.b 11	; entirely unnecessary
; hang from vine/tails
frA_Hang1	ds.b 1
frA_Hang2	ds.b 1
; What a useless transformation. You changed your hair, so what?
frA_Transform1	ds.b 1
frA_Transform2	ds.b 1
frA_Transform3	ds.b 1
frA_Transform4	ds.b 1
frA_Transform5	ds.b 1
frA_Transform6	ds.b 1
; Balance B
frA_BalanceB1	ds.b 1
frA_BalanceB2	ds.b 1
frA_BalanceB3	ds.b 1
frA_BalanceB4	ds.b 1
; Balance A
frA_BalanceA1	ds.b 1
frA_BalanceA2	ds.b 1
frA_BalanceA3	ds.b 1
; Balance Turn
frA_BalanceT1	ds.b 1
; Balance C
frA_BalanceC1	ds.b 1
frA_BalanceC2	ds.b 1
; Skid and turn
frA_Skid1	ds.b 1
frA_Skid2	ds.b 1
frA_Skid3	ds.b 1
frA_SkidT	ds.b 1
; Placeholder
frA_Derp	ds.b 1
; Fall
frA_Fall1	ds.b 1
frA_Fall2	ds.b 1
; i win muahaha
frA_Win1	ds.b 1
frA_Win2	ds.b 1
frA_Win3	ds.b 1
frA_Win4	ds.b 1
frA_Win5	ds.b 1
	even
	dephase