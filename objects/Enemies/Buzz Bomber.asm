Obj_BuzzBomber:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Buzz_Index(pc,d0.w),d1
		jsr	Buzz_Index(pc,d1.w)
		jmp	(MarkObjGone).l
; ===========================================================================
Buzz_Index:	offsetTable
		offsetTableEntry.w Buzz_Main
		offsetTableEntry.w Buzz_Action
		offsetTableEntry.w Buzz_Delete

buzz_parent = objoff_2A		; long
buzz_timedelay = objoff_2E	; word for some ungodly reason
buzz_buzzstatus = objoff_30	; byte
; ===========================================================================

Buzz_Main:	; Routine 0
		addq.b	#2,routine(a0)
		move.l	#Obj_BuzzBomber_MapUnc,mappings(a0)
		move.w	#make_art_tile(ArtTile_ArtNem_BuzzBomber,0,0),art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#prio(3),priority(a0)
		move.b	#$C,collision_flags(a0)
		move.b	#$18,width_pixels(a0)

Buzz_Action:	; Routine 2
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Buzz_2ndIndex(pc,d0.w),d1
		jsr	Buzz_2ndIndex(pc,d1.w)
		lea	(Ani_Buzz).l,a1
		jmp	AnimateSprite
; ===========================================================================
Buzz_2ndIndex:	offsetTable
		offsetTableEntry.w Buzz_Move
		offsetTableEntry.w Buzz_ChkNear
; ===========================================================================

Buzz_Move:
		subq.w	#1,buzz_timedelay(a0) ; subtract 1 from time delay
		bpl.s	.noflip		; if time remains, branch
		btst	#1,buzz_buzzstatus(a0) ; is Buzz Bomber near Sonic?
		bne.s	.fire		; if yes, branch
		addq.b	#2,routine_secondary(a0)
		move.w	#127,buzz_timedelay(a0) ; set time delay to just over 2 seconds
		move.w	#$400,x_vel(a0) ; move Buzz Bomber to the right
		move.b	#1,anim(a0)	; use "flying" animation
		btst	#0,status(a0)	; is Buzz Bomber facing	left?
		bne.s	.noflip		; if not, branch
		neg.w	x_vel(a0)	; move Buzz Bomber to the left

.noflip:
		rts	
; ===========================================================================

.fire:
		jsr		(SingleObjLoad).l
		bne.s	.fail
		_move.l	#Obj_BuzzMissile,id(a1) ; load missile object
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#20,y_pos(a1)
		move.w	#$200,y_vel(a1) ; move missile downwards
		move.w	#$200,x_vel(a1) ; move missile to the right
		move.w	#5,d0
		btst	#0,status(a0)	; is Buzz Bomber facing	left?
		bne.s	.noflip2	; if not, branch
		neg.w	d0
		neg.w	x_vel(a1)	; move missile to the left

.noflip2:
		add.w	d0,x_pos(a1)
		move.b	status(a0),status(a1)
		move.w	#$E,buzz_timedelay(a1)
		move.l	a0,buzz_parent(a1)
		move.b	#1,buzz_buzzstatus(a0) ; set to "already fired" to prevent refiring
		move.w	#59,buzz_timedelay(a0)
		move.b	#3,anim(a0)	; use "firing" animation

.fail:
		rts	
; ===========================================================================

Buzz_ChkNear:
		subq.w	#1,buzz_timedelay(a0) ; subtract 1 from time delay
		bmi.s	.chgdirection
		jsr	ObjectMove
		tst.b	buzz_buzzstatus(a0)
		bne.s	.keepgoing
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bpl.s	.isleft
		neg.w	d0

.isleft:
		cmpi.w	#$60,d0		; is Buzz Bomber within	$60 pixels of Sonic?
		bcc.s	.keepgoing	; if not, branch
		tst.b	render_flags(a0)
		bpl.s	.keepgoing
		move.b	#2,buzz_buzzstatus(a0) ; set Buzz Bomber to "near Sonic"
		move.w	#29,buzz_timedelay(a0) ; set time delay to half a second
		move.b	#0,anim(a0)	; use "hovering" animation
		bra.s	.stop
; ===========================================================================

.chgdirection:
		move.b	#0,buzz_buzzstatus(a0) ; set Buzz Bomber to "normal"
		move.b	#2,anim(a0)
		bchg	#0,status(a0)	; change direction
		move.w	#59,buzz_timedelay(a0)

.stop:
		subq.b	#2,routine_secondary(a0)
		move.w	#0,x_vel(a0)	; stop Buzz Bomber moving

.keepgoing:
		rts	
; ===========================================================================

Buzz_Delete:	; Routine 4
		jmp		DeleteObject

; ---------------------------------------------------------------------------
; Object N/A - missile that Buzz	Bomber throws
; ---------------------------------------------------------------------------

Obj_BuzzMissile:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Msl_Index(pc,d0.w),d1
		jmp	Msl_Index(pc,d1.w)
; ===========================================================================
Msl_Index:	dc.w Msl_Main-Msl_Index
		dc.w Msl_Animate-Msl_Index
		dc.w Msl_FromBuzz-Msl_Index
		dc.l DeleteObject-Msl_Index
; ===========================================================================

Msl_Main:	; Routine 0
		subq.w	#1,buzz_timedelay(a0)
		bpl.s	Msl_ChkCancel
		addq.b	#2,routine(a0)
		move.l	#Obj_BuzzBomber_MapUnc,mappings(a0)
		move.w	#make_art_tile(ArtTile_ArtNem_BuzzBomber,0,0),art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#prio(3),priority(a0)
		move.b	#8,width_pixels(a0)
		andi.b	#3,status(a0)
		move.b	#4,anim(a0)
; ===========================================================================

Msl_Animate:	; Routine 2
		bsr.s	Msl_ChkCancel
		lea	(Ani_Buzz).l,a1
		jsr	AnimateSprite
		jmp	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, then cancel	the missile
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Msl_ChkCancel:
		movea.l	buzz_parent(a0),a1
		_cmpi.l	#Obj_Explosion,id(a1) ; has Buzz Bomber been destroyed?
		jeq		DeleteObject	; if yes, branch
		rts
; End of function Msl_ChkCancel

; ===========================================================================

Msl_FromBuzz:	; Routine 4
		btst	#7,status(a0)
		bne.s	.explode
		move.b	#$87,collision_flags(a0)
		move.b	#5,anim(a0)
		jsr	ObjectMove
		lea	(Ani_Buzz).l,a1
		jsr	AnimateSprite
		jsr	DisplaySprite
	; Check if it hit the floor, and if it did, set that bit
		jsr		(ObjCheckFloorDist).l
		tst.w	d1
		bpl.s	.nah
		bset	#7,status(a0)
	; Continue
	.nah:
		move.w	(Camera_Max_Y_pos).w,d0
		addi.w	#$E0,d0
		cmp.w	y_pos(a0),d0	; has object moved below the level boundary?
		jcs		DeleteObject	; if yes, branch
		rts
; ===========================================================================

.explode:
		_move.l	#Obj_Explosion,id(a0) ; change object to an explosion (Obj24)
		move.b	#2,routine(a0)
		jmp		Obj_Explosion
; ===========================================================================

Ani_Buzz:
		dc.w .fly1-Ani_Buzz
		dc.w .fly2-Ani_Buzz
		dc.w .turn-Ani_Buzz
		dc.w .fires-Ani_Buzz
	; missile
		dc.w .flare-Ani_Buzz
		dc.w .missile-Ani_Buzz

.fly1:		dc.b 5,	0, 1, afEnd
	rev02even
.fly2:		dc.b 1,	0, 1, afEnd
	rev02even
.turn:		dc.b 2,	2, 3, afChange, 0
	rev02even
.fires:		dc.b 3,	4, 5, afEnd
	rev02even
.flare:		dc.b 7,	6, 7, afRoutine
	rev02even
.missile:	dc.b 1,	8, 9, afEnd
	even

Obj_BuzzBomber_MapUnc:	BINCLUDE "mappings/sprite/Obj_BuzzBomber.bin"