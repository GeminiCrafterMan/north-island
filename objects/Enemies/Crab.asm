Obj_Crab:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Crab_Index(pc,d0.w),d1
	jsr		Crab_Index(pc,d1.w)
	jmp		(MarkObjGone).l
; ===========================================================================
Crab_Index:	offsetTable
		offsetTableEntry.w	Crab_Main
		offsetTableEntry.w	Crab_2ndRout
		offsetTableEntry.w	Crab_Delete
	; This stuff was copied from Crabmeat, but I don't care.
		offsetTableEntry.w	Crab_BallMain
		offsetTableEntry.w	Crab_BallMove

Crab_Timer	=	objoff_30	; Originally used as a word, but I don't see the purpose of that.
; Bit 2 of status tells whether it shot on this cycle.
; ===========================================================================

Crab_Main:	; Initialize stuff...
	move.l	#Obj_Crab_MapUnc,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Crab,0,0),art_tile(a0)
	move.b	#30,Crab_Timer(a0)
	ori.b	#4,render_flags(a0)
	move.w	#prio(4),priority(a0)
	move.b	#16,width_pixels(a0)
	move.b	#15,y_radius(a0)
	move.b	#6,x_radius(a0)

Crab_SetValues:
	move.b	#$C,collision_flags(a0)
	jsr		(ObjectMoveAndFall).l		; Movement stuff.
	jsr		(ObjCheckFloorDist).l	; Are we on the floor?
	tst.w	d1
	bpl.s	.floornotfound		; What ~~pumpkin~~ floor?
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	addq.b	#2,routine(a0)	; Go to Crab_2ndRout.
	bchg	#0,status(a0)		; Turn around.
.floornotfound:
	rts

Crab_2ndRout:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Crab_2ndIndex(pc,d0.w),d1
	jsr		Crab_2ndIndex(pc,d1.w)
	lea		(Ani_Crab).l,a1
	jmp		(AnimateSprite).l
; ===========================================================================
Crab_2ndIndex:
	dc.w	Crab_OpenClose-Crab_2ndIndex
	dc.w	Crab_CheckFloor-Crab_2ndIndex	; Fuck it.
	dc.w	Crab_Shoot-Crab_2ndIndex
	dc.w	Crab_ShootWait-Crab_2ndIndex
; ===========================================================================

Crab_OpenClose:
	subq.b	#1,Crab_Timer(a0)
	cmpi.b	#30,Crab_Timer(a0)	; If it's
	bgt.s	.ret						; *above* 30, return
	btst	#2,status(a0)				; Have we shot already?
	bne.s	.cont						; if so, don't shoot again
; This is where we check where the player is.
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	jsr		Obj_GetOrientationToPlayer
	move.w	d2,d4
	move.w	d3,d5
	bsr.w	Crab_TestCharPos			; is the player close enough to attack?
	beq.s	.cont						; If not, continue walking.
	move.b	#4,routine_secondary(a0)			; Shoot.
	bra.w	Crab_Shoot

.cont:
	addq.b	#2,routine_secondary(a0)
	cmpi.b	#1,anim(a0)
	beq.s	.close
	move.b	#1,anim(a0)
	move.w	#-$10,x_vel(a0)	; Stupid Sonic 2. $FFF0 = -$10
	bchg	#0,status(a0)
	bne.s	.ret
	neg.w	x_vel(a0)
.ret:
	rts
.close:
	move.b	#3,anim(a0)
	clr.w	x_vel(a0)
	rts

Crab_TestCharPos:
	addq.w	#8,d3			; Add 8px to test box Y position
	cmpi.w	#$68,d3			; is distance greater than $68 (104px)?
	bhs.s	.noShoot		; if yes, branch
	tst.w	d2				; is character to the left?
	bmi.s	.testLeft		; if yes, branch
	btst	#0,status(a0)	; is object facing left, towards character?
	bne.s	.noShoot		; if not, branch
	bra.w	.testHorizDist

.testLeft:
	btst	#0,status(a0)	; is object facing right, towards character?
	beq.s	.noShoot		; if not, branch
	neg.w	d2				; get absolute value

.testHorizDist:
	tst.w	d2				; is distance less than 0? (is player behind Crab?)
	blo.s	.noShoot		; if yes, don't attack
	cmpi.w	#$40,d2			; is distance less than $40 (64px)?
	blo.s	.inRange		; if yes, attack

.noShoot:
	moveq	#0,d2			; -> don't shoot at player
	rts

.inRange:
	moveq	#1,d2			; -> shoot at player
	rts

Crab_CheckFloor:
	jsr		(ObjectMove).l
	jsr		(ObjCheckFloorDist).l
	cmpi.w	#-$8,d1	; Stupid Sonic 2, again! $FFF8 = -8
	blt.s	.hitSide
	cmpi.w	#$C,d1
	bge.s	.hitSide
	add.w	d1,y_pos(a0)
	rts
.hitSide:
	subq.b	#2,routine_secondary(a0)
	move.b	#59,Crab_Timer(a0)
	bclr	#2,status(a0)	; Allow to shoot again.
	clr.w	x_vel(a0)
	move.b	#3,anim(a0)
	rts

Crab_Shoot:
	jsr		(SingleObjLoad).l
	bne.s	.fail
	_move.l	#Obj_Crab,id(a1)
	move.b	#6,routine(a1)	; It's a ball. (SPHERICAL)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#-$100,x_vel(a1)	; Move to the left.
	btst	#0,status(a0)
	beq.s	.noFlip
	neg.w	x_vel(a1)			; Nevermind, move to the right.
.noFlip:
	sfx		sfx_Dash
	move.b	#2,anim(a0)		; Shoot animation.
	addq.b	#2,routine_secondary(a0)
.fail:
	rts
	; Wait until you're done shooting...
Crab_ShootWait:
	tst.b	anim_frame_duration(a0)
	bne.s	.notYet

	bset	#2,status(a0)		; We shot.
	subq.b	#6,routine_secondary(a0)

.notYet:
	rts

Crab_Delete:
	jmp		(DeleteObject).l
; ===========================================================================

; ---------------------------------------------------------------------------
; Sub-object - missile that the	Crab throws
; ---------------------------------------------------------------------------

Crab_BallMain:	; Routine 6
;	bclr	#0,obShieldDeflect(a0)	; Not deflectable
	addq.b	#2,routine(a0)
	move.l	#Obj_Crab_MapUnc,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Crab,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.w	#prio(3),priority(a0)
	move.b	#$87,collision_flags(a0)
	move.b	#16,width_pixels(a0)
	move.w	#-$400,y_vel(a0)
	move.b	#4,mapping_frame(a0)

Crab_BallMove:	; Routine 8
	btst	#7,status(a0)
	bne.s	.explode
	jsr		(ObjectMoveAndFall).l
	jsr		(DisplaySprite).l
; Check if it hit the floor, and if it did, set that bit
	jsr		(CheckFloorDist).l
	tst.w	d1
	bpl.s	.nah
	bset	#7,status(a0)
; Continue
.nah:
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0	; has object moved below the level boundary?
	jcs		DeleteObject		; if yes, branch
	rts

.explode:
	move.l	#0,x_vel(a0)	; Clears both X and Y speeds, since they're right next to eachother
	sfx		sfx_Explode		; Play explosion SFX.
	_move.l	#Obj_Explosion,id(a0) ; change object to an explosion (Obj24)
	move.b	#2,routine(a0)
	jmp		(Obj_Explosion).l

Obj_Crab_MapUnc:	BINCLUDE "mappings/sprite/Obj_Crab.bin"

Ani_Crab:	offsetTable
		offsetTableEntry.w	Ani_Crab_Idle
		offsetTableEntry.w	Ani_Crab_Open
		offsetTableEntry.w	Ani_Crab_Move
		offsetTableEntry.w	Ani_Crab_Close
		offsetTableEntry.w	Ani_Crab_Bullet

Ani_Crab_Idle:	dc.b	$7F, 0, afEnd
	rev02even
Ani_Crab_Open:	dc.b	5, 0, 1, 0, 1, 0, 1, 1, 1, 2, 3, 4, afBack, 1
	rev02even
Ani_Crab_Move:	dc.b	9, 4, 5, 4, 6, afEnd
	rev02even
Ani_Crab_Close:	dc.b	5, 4, 3, 2, 1, 1, 1, afChange, 0
	rev02even
Ani_Crab_Bullet:dc.b	1, 7, 8, afEnd
	even