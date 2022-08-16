; ---------------------------------------------------------------------------
; Animation script - Knuckles
; ---------------------------------------------------------------------------

KnucklesAniData:
		dc.w KnucklesAni_Walk-KnucklesAniData
		dc.w KnucklesAni_Run-KnucklesAniData; 1
		dc.w KnucklesAni_Roll-KnucklesAniData; 2
		dc.w KnucklesAni_Roll2-KnucklesAniData;	3
		dc.w KnucklesAni_Push-KnucklesAniData; 4
		dc.w KnucklesAni_Wait-KnucklesAniData; 5
		dc.w KnucklesAni_Balance-KnucklesAniData; 6
		dc.w KnucklesAni_LookUp-KnucklesAniData; 7
		dc.w KnucklesAni_Duck-KnucklesAniData; 8
		dc.w KnucklesAni_Spindash-KnucklesAniData; 9
		dc.w KnucklesAni_Dummy-KnucklesAniData; 10
		dc.w KnucklesAni_Dummy-KnucklesAniData; 11
		dc.w KnucklesAni_Balance2-KnucklesAniData; 12
		dc.w KnucklesAni_Stop-KnucklesAniData; 13
		dc.w KnucklesAni_Float-KnucklesAniData;	14
		dc.w KnucklesAni_Float2-KnucklesAniData; 15
		dc.w KnucklesAni_Spring-KnucklesAniData; 16
		dc.w KnucklesAni_Hang-KnucklesAniData; 17
		dc.w KnucklesAni_Dummy-KnucklesAniData; 18
		dc.w KnucklesAni_Dummy-KnucklesAniData; 19
		dc.w KnucklesAni_WFZHang-KnucklesAniData; 20
		dc.w KnucklesAni_Bubble-KnucklesAniData; 21
		dc.w KnucklesAni_DeathBW-KnucklesAniData; 22
		dc.w KnucklesAni_Drown-KnucklesAniData;	23
		dc.w KnucklesAni_Death-KnucklesAniData;	24
		dc.w KnucklesAni_Hurt-KnucklesAniData; 25
		dc.w KnucklesAni_Hurt-KnucklesAniData; 26
		dc.w KnucklesAni_Slide-KnucklesAniData; 27
		dc.w KnucklesAni_Blank-KnucklesAniData;	28
		dc.w KnucklesAni_Dummy-KnucklesAniData; 29
		dc.w KnucklesAni_Dummy-KnucklesAniData; 30
		dc.w KnucklesAni_Transform-KnucklesAniData; 31
		dc.w KnucklesAni_Gliding-KnucklesAniData; 32
		dc.w KnucklesAni_FallFromGlide-KnucklesAniData;	33
		dc.w KnucklesAni_GetUp-KnucklesAniData;	34
		dc.w KnucklesAni_HardFall-KnucklesAniData; 35
		dc.w KnucklesAni_Badass-KnucklesAniData; 36
KnucklesAni_Walk:dc.b $FF,  frK_Walk17,	frK_Walk18,  frK_Walk11,	frK_Walk12,  frK_Walk13,	frK_Walk14,  frK_Walk15,	frK_Walk16,afEnd
	rev02even
KnucklesAni_Run:dc.b $FF,frK_Run11,frK_Run12,frK_Run13,frK_Run14,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
KnucklesAni_Roll:dc.b $FE,frK_Roll5,frK_Roll1,frK_Roll5,frK_Roll2,frK_Roll5,frK_Roll3,frK_Roll5,frK_Roll4,afEnd
	rev02even
KnucklesAni_Roll2:dc.b $FE,frK_Roll5,frK_Roll1,frK_Roll5,frK_Roll2,frK_Roll5,frK_Roll3,frK_Roll5,frK_Roll4,afEnd
	rev02even
KnucklesAni_Push:dc.b $FD,frK_Push1,frK_Push2,frK_Push3,frK_Push4,afEnd,afEnd,afEnd,afEnd,afEnd
	rev02even
KnucklesAni_Wait:dc.b	5,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1
		dc.b frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1
		dc.b frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1
		dc.b frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle1,frK_Idle2
		dc.b frK_Idle2,frK_Idle2,frK_Idle3,frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2,frK_Idle2,frK_Idle3,frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2
		dc.b frK_Idle2,frK_Idle3,frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2,frK_Idle2,frK_Idle3,frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2,frK_Idle2
		dc.b frK_Idle3,frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2,frK_Idle2,frK_Idle3,frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2,frK_Idle2,frK_Idle3
		dc.b frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2,frK_Idle2,frK_Idle3,frK_Idle3,frK_Idle3,frK_Idle2,frK_Idle2,frK_Idle2,frK_Idle3,frK_Idle3
		dc.b frK_Idle3,frK_Idle4,frK_Idle4,frK_Idle4,frK_Idle4,frK_Idle4,frK_Idle5,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7
		dc.b frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8
		dc.b frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9
		dc.b frK_Idle10,frK_Idle11,frK_Idle10,frK_Idle11,frK_Idle12,frK_Idle12,frK_Idle6,frK_Idle5,afEnd
	rev02even
KnucklesAni_Balance:dc.b   3,frK_Balance1,frK_Balance1,frK_Balance2,frK_Balance2,frK_Balance3,frK_Balance3,frK_Balance4,frK_Balance4,frK_Balance5,frK_Balance5,frK_Balance6,frK_Balance6
		dc.b frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7
		dc.b frK_Balance7,frK_Balance7,frK_Balance8,frK_Balance8,frK_Balance8,frK_Balance9,frK_Balance9,frK_Balance9,frK_Balance10,frK_Balance10,frK_Balance11,frK_Balance11,frK_Balance12
		dc.b frK_Balance12,afBack,  6
	rev02even
KnucklesAni_LookUp:dc.b	  5,frK_LookUp1,frK_LookUp2,afBack,  1
	rev02even
KnucklesAni_Duck:dc.b	5,frK_Duck1,frK_Duck2,afBack,	1
	rev02even
KnucklesAni_Spindash:dc.b   0,frK_SpDsh1,frK_SpDsh2,frK_SpDsh1,frK_SpDsh3,frK_SpDsh1,frK_SpDsh4,frK_SpDsh1,frK_SpDsh5,frK_SpDsh1,frK_SpDsh6,afEnd
	rev02even
KnucklesAni_Balance2:dc.b   3,frK_Balance3,frK_Balance3,frK_Balance4,frK_Balance4,frK_Balance5,frK_Balance5,frK_Balance6,frK_Balance6,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7
		dc.b frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance7,frK_Balance8,frK_Balance8
		dc.b frK_Balance8,frK_Balance9,frK_Balance9,frK_Balance9,frK_Balance10,frK_Balance10,frK_Balance11,frK_Balance11,frK_Balance12,frK_Balance12,afBack, 6
	rev02even
KnucklesAni_Stop:dc.b	3,frK_Skid1,frK_Skid2,frK_Balance1,frK_Balance2,afChange,	0
	rev02even
KnucklesAni_Float:dc.b	 7,frK_Glide1,afEnd
	rev02even
KnucklesAni_Float2:dc.b	  5,frK_Glide1,frK_Glide2,frK_Glide3,frK_Glide4,frK_Glide5,frK_Glide6,frK_Glide7,frK_Glide8,frK_Glide9,frK_Glide10,afEnd
	rev02even
KnucklesAni_Spring:dc.b	$2F,frK_Spring,afEnd
	rev02even
KnucklesAni_Hang:dc.b	1,frK_Cling1,frK_Cling2,afEnd
	rev02even
KnucklesAni_WFZHang:dc.b $13,frK_Hang2,afEnd
	rev02even
KnucklesAni_Bubble:dc.b	 $B,frK_Bubble,frK_Bubble,  frK_Walk13,  frK_Walk14,afChange,  0
	rev02even
KnucklesAni_DeathBW:dc.b $20,frK_Burnt,afEnd
	rev02even
KnucklesAni_Drown:dc.b $20,frK_Drown,afEnd
	rev02even
KnucklesAni_Death:dc.b $20,frK_Death,afEnd
	rev02even
KnucklesAni_Slide:dc.b   9,frK_Slide,afEnd
	rev02even
KnucklesAni_Hurt:dc.b $40,frK_Hurt,afEnd
	rev02even
KnucklesAni_Blank:dc.b $77,  frK_Null,afEnd
	rev02even
KnucklesAni_Gliding:dc.b $1F,frK_Glide1,afEnd
	rev02even
KnucklesAni_FallFromGlide:dc.b	 7,frK_GlideX1,frK_GlideX2,afBack,	 1
	rev02even
KnucklesAni_GetUp:dc.b	$F,frK_GlideL2,afChange,  0
	rev02even
KnucklesAni_HardFall:dc.b  $F,frK_Duck2,afChange,	0
	rev02even
KnucklesAni_Badass:dc.b	  5,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9
		dc.b frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6
		dc.b frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle6,frK_Idle7,frK_Idle8,frK_Idle9,frK_Idle10,frK_Idle11,frK_Idle10,frK_Idle11,frK_Idle12,frK_Idle12
		dc.b afEnd
	rev02even
KnucklesAni_Transform:dc.b   2,frK_Transf1,frK_Transf1,frK_Transf2,frK_Transf3,frK_Transf4,frK_Transf3,frK_Transf4,frK_Transf3,frK_Transf4,frK_Transf3,frK_Transf2, afChange,  0
	rev02even
KnucklesAni_Dummy:dc.b	  $7F, frK_PHold, afEnd
	rev02even

; Frame IDs
	phase 0 ; Reset ds.b value to 0

frK_Null	ds.b 1	; 0

; standing still
frK_Idle1	ds.b 1
frK_Idle2	ds.b 1
frK_Idle3	ds.b 1
frK_Idle4	ds.b 1
frK_Idle5	ds.b 1
frK_Idle6	ds.b 1
frK_Idle7	ds.b 1
frK_Idle8	ds.b 1
frK_Idle9	ds.b 1
frK_Idle10	ds.b 1
frK_Idle11	ds.b 1
frK_Idle12	ds.b 1
; Look up
frK_LookUp1	ds.b 1
frK_LookUp2	ds.b 1
; Walk
frK_Walk11	ds.b 1
frK_Walk12	ds.b 1
frK_Walk13	ds.b 1
frK_Walk14	ds.b 1
frK_Walk15	ds.b 1
frK_Walk16	ds.b 1
frK_Walk17	ds.b 1
frK_Walk18	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frK_Walk2X	ds.b 8
frK_Walk3X	ds.b 8
frK_Walk4X	ds.b 8
; fest
frK_Run11	ds.b 1
frK_Run12	ds.b 1
frK_Run13	ds.b 1
frK_Run14	ds.b 1
; don't care about these, define them for the sake of keeping the number up
frK_Run2X	ds.b 4
frK_Run3X	ds.b 4
frK_Run4X	ds.b 4
; tumble
frK_Tumble1	ds.b 1
frK_TumbleX	ds.b 11	; entirely unnecessary
; spindash
frK_SpDsh1	ds.b 1
frK_SpDsh2	ds.b 1
frK_SpDsh3	ds.b 1
frK_SpDsh4	ds.b 1
frK_SpDsh5	ds.b 1
frK_SpDsh6	ds.b 1
; slide and hurt
frK_Slide	ds.b 1
frK_Hurt	ds.b 1
; boing
frK_Spring	ds.b 1
; hang from vine/wfz thing
frK_Hang1	ds.b 1
frK_Hang2	ds.b 1
frK_Hang3	ds.b 1
frK_Hang4	ds.b 1
; speeeeeeeeeeeeEEEEEEEEEEEN
frK_Roll1	ds.b 1
frK_Roll2	ds.b 1
frK_Roll3	ds.b 1
frK_Roll4	ds.b 1
frK_Roll5	ds.b 1
; ducc
frK_Duck1	ds.b 1
frK_Duck2	ds.b 1
; Skid
frK_Skid1	ds.b 1
frK_Skid2	ds.b 1
; Balance
frK_Balance1	ds.b 1
frK_Balance2	ds.b 1
frK_Balance3	ds.b 1
frK_Balance4	ds.b 1
frK_Balance5	ds.b 1
frK_Balance6	ds.b 1
frK_Balance7	ds.b 1
frK_Balance8	ds.b 1
frK_Balance9	ds.b 1
frK_Balance10	ds.b 1
frK_Balance11	ds.b 1
frK_Balance12	ds.b 1
; ded
frK_Death	ds.b 1
frK_Burnt	ds.b 1
frK_Drown	ds.b 1
; cling
frK_Cling1	ds.b 1
frK_Cling2	ds.b 1
; bubble bobble nes
frK_Bubble	ds.b 1
; victory screech
frK_Win1	ds.b 1
frK_Win2	ds.b 1
frK_Win3	ds.b 1
frK_Win4	ds.b 1
; climbing
frK_Climb1	ds.b 1
frK_Climb2	ds.b 1
frK_Climb3	ds.b 1
frK_Climb4	ds.b 1
frK_Climb5	ds.b 1
frK_Climb6	ds.b 1
; climbing onto ledge
frK_ClimbU1	ds.b 1
frK_ClimbU2 ds.b 1
frK_ClimbU3 ds.b 1
; float / glide
frK_Glide1	ds.b 1
frK_Glide2	ds.b 1
frK_Glide3	ds.b 1
frK_Glide4	ds.b 1
frK_Glide5	ds.b 1
frK_Glide6	ds.b 1
frK_Glide7	ds.b 1
frK_Glide8	ds.b 1
frK_Glide9	ds.b 1
frK_Glide10	ds.b 1
; exiting from glide
frK_GlideX1 ds.b 1
frK_GlideX2 ds.b 1
; landing from glide
frK_GlideL1 ds.b 1
frK_GlideL2 ds.b 1
; poosh
frK_Push1	ds.b 1
frK_Push2	ds.b 1
frK_Push3	ds.b 1
frK_Push4	ds.b 1
; transform
frK_Transf1	ds.b 1
frK_Transf2	ds.b 1
frK_Transf3	ds.b 1
frK_Transf4	ds.b 1
; Placeholder
frK_PHold	ds.b 1
; climb down
frK_ClimbD1	ds.b 1
frK_ClimbD2	ds.b 1
	even
	dephase