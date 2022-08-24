
; ---------------------------------------------------------------------------
; Animation script - Tails' tails
; ---------------------------------------------------------------------------
; off_1D2C0:
Obj_TailsTailsAniData:	offsetTable
		offsetTableEntry.w Obj_TailsTailsAni_Blank	;  0
		offsetTableEntry.w Obj_TailsTailsAni_Swish	;  1
		offsetTableEntry.w Obj_TailsTailsAni_Flick	;  2
		offsetTableEntry.w Obj_TailsTailsAni_Directional	;  3
		offsetTableEntry.w Obj_TailsTailsAni_DownLeft	;  4
		offsetTableEntry.w Obj_TailsTailsAni_Down	;  5
		offsetTableEntry.w Obj_TailsTailsAni_DownRight	;  6
		offsetTableEntry.w Obj_TailsTailsAni_Spindash	;  7
		offsetTableEntry.w Obj_TailsTailsAni_Skidding	;  8
		offsetTableEntry.w Obj_TailsTailsAni_Pushing	;  9
		offsetTableEntry.w Obj_TailsTailsAni_Hanging	; $A
		offsetTableEntry.w Obj_TailsTailsAni_Fly		; $B

Obj_TailsTailsAni_Blank:		dc.b $20,  frTT_Null,$FF
	rev02even
Obj_TailsTailsAni_Swish:		dc.b   7,  frTT_Idle1, frTT_Idle2, frTT_Idle3, frTT_Idle4, frTT_Idle5,$FF
	rev02even
Obj_TailsTailsAni_Flick:		dc.b   3,  frTT_Idle1, frTT_Idle2, frTT_Idle3, frTT_Idle4, frTT_Idle5,$FD,  1
	rev02even
Obj_TailsTailsAni_Directional:	dc.b $FC,frTT_Roll11,frTT_Roll12,frTT_Roll13,frTT_Roll14,$FF ; Tails is moving right
	rev02even
Obj_TailsTailsAni_DownLeft:	dc.b   3,frTT_Roll21,frTT_Roll22,frTT_Roll23,frTT_Roll24,$FF ; Tails is moving up-right
	rev02even
Obj_TailsTailsAni_Down:		dc.b   3,frTT_Roll31,frTT_Roll32,frTT_Roll33,frTT_Roll34,$FF ; Tails is moving up
	rev02even
Obj_TailsTailsAni_DownRight:	dc.b   3,frTT_Roll41,frTT_Roll42,frTT_Roll43,frTT_Roll44,$FF ; Tails is moving up-left
	rev02even
Obj_TailsTailsAni_Spindash:	dc.b   2,frTT_Spindash1,frTT_Spindash2,frTT_Spindash3,frTT_Spindash4,$FF
	rev02even
Obj_TailsTailsAni_Skidding:	dc.b   2,frTT_Pushing1,frTT_Pushing2,frTT_Pushing3,frTT_Pushing4,$FF
	rev02even
Obj_TailsTailsAni_Pushing:	dc.b   9,frTT_Pushing1,frTT_Pushing2,frTT_Pushing3,frTT_Pushing4,$FF
	rev02even
Obj_TailsTailsAni_Hanging:	dc.b   9,frTT_Spindash1,frTT_Spindash2,frTT_Spindash3,frTT_Spindash4,$FF
	rev02even
Obj_TailsTailsAni_Fly:	dc.b   1,frTT_Fly1,frTT_Fly2,$FF
	even

; Frame IDs
	phase 0 ; Reset ds.b value to 0

frTT_Null	ds.b 1	; 0

frTT_Idle1	ds.b 1
frTT_Idle2	ds.b 1
frTT_Idle3	ds.b 1
frTT_Idle4	ds.b 1
frTT_Idle5	ds.b 1

frTT_Roll11	ds.b 1
frTT_Roll12	ds.b 1
frTT_Roll13	ds.b 1
frTT_Roll14	ds.b 1
frTT_Roll21	ds.b 1
frTT_Roll22	ds.b 1
frTT_Roll23	ds.b 1
frTT_Roll24	ds.b 1
frTT_Roll31	ds.b 1
frTT_Roll32	ds.b 1
frTT_Roll33	ds.b 1
frTT_Roll34	ds.b 1
frTT_Roll41	ds.b 1
frTT_Roll42	ds.b 1
frTT_Roll43	ds.b 1
frTT_Roll44	ds.b 1

frTT_Spindash1	ds.b 1
frTT_Spindash2	ds.b 1
frTT_Spindash3	ds.b 1
frTT_Spindash4	ds.b 1

frTT_Pushing1	ds.b 1
frTT_Pushing2	ds.b 1
frTT_Pushing3	ds.b 1
frTT_Pushing4	ds.b 1

frTT_Fly1	ds.b 1
frTT_Fly2	ds.b 1
	even
	dephase