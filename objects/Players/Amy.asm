Obj_Amy:
	; a0=character
	cmpa.w	#MainCharacter,a0
	bne.s	Obj_Amy_Normal
	tst.w	(Debug_placement_mode).w	; is debug mode being used?
	beq.s	Obj_Amy_Normal			; if not, branch
	jmp	(DebugMode).l
; ---------------------------------------------------------------------------
; loc_19F5C:
Obj_Amy_Normal:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj_Amy_Index(pc,d0.w),d1
	jmp	Obj_Amy_Index(pc,d1.w)
; ===========================================================================
; off_19F6A: Obj_Amy_States:
Obj_Amy_Index:	offsetTable
		offsetTableEntry.w Obj_Amy_Init		;  0
		offsetTableEntry.w Obj_Amy_Control	;  2
		offsetTableEntry.w Obj_Amy_Hurt		;  4
		offsetTableEntry.w Obj_Amy_Dead		;  6
		offsetTableEntry.w Obj_Amy_Gone		;  8
		offsetTableEntry.w Obj_Amy_Respawning	; $A
; ===========================================================================
; loc_19F76: Obj_01_Sub_0: Obj_Amy_Main:
Obj_Amy_Init:
	addq.b	#2,routine(a0)	; => Obj_Amy_Control
	jsr		ResetHeight_a0
	move.l	#MapUnc_Amy,mappings(a0)
	move.w	#prio(2),priority(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#4,render_flags(a0)
	move.w	#$600,(Sonic_top_speed).w	; set Amy's top speed
	move.w	#$C,(Sonic_acceleration).w	; set Amy's acceleration
	move.w	#$80,(Sonic_deceleration).w	; set Amy's deceleration
	jsr		ResetArtTile_a0
	tst.b	(Last_star_pole_hit).w
	bne.s	Obj_Amy_Init_Continued
	; only happens when not starting at a checkpoint:
	move.b	#$C,top_solid_bit(a0)
	move.b	#$D,lrb_solid_bit(a0)
	move.w	x_pos(a0),(Saved_x_pos).w
	move.w	y_pos(a0),(Saved_y_pos).w
	move.w	art_tile(a0),(Saved_art_tile).w
	move.w	top_solid_bit(a0),(Saved_Solid_bits).w

Obj_Amy_Init_Continued:
	move.b	#0,flips_remaining(a0)
	move.b	#4,flip_speed(a0)
	move.b	#0,(Super_Sonic_flag).w
	move.b	#$1E,air_left(a0)
	subi.w	#$20,x_pos(a0)
	addi_.w	#4,y_pos(a0)
	cmpa.w	#MainCharacter,a0
	bne.s	.p2
	move.w	#0,(Sonic_Pos_Record_Index).w
	bra.s	.cont
.p2:
	move.w	#0,(Tails_Pos_Record_Index).w
.cont:
	move.w	#$3F,d2
-	bsr.w	P1_RecordPos
	subq.w	#4,a1
	move.l	#0,(a1)
	dbf	d2,-

	addi.w	#$20,x_pos(a0)
	subi_.w	#4,y_pos(a0)

; ---------------------------------------------------------------------------
; Normal state for Amy
; ---------------------------------------------------------------------------
; loc_1A030: Obj_01_Sub_2:
Obj_Amy_Control:
	cmpa.w	#MainCharacter,a0
	bne.s	+
	tst.w	(Debug_mode_flag).w	; is debug cheat enabled?
	beq.s	+			; if not, branch
	btst	#button_B,(Ctrl_1_Press).w	; is button B pressed?
	beq.s	+			; if not, branch
	move.w	#1,(Debug_placement_mode).w	; change Amy into a ring/item
	clr.b	(Control_Locked).w		; unlock control
	rts
; -----------------------------------------------------------------------
+
	cmpa.w	#MainCharacter,a0
	bne.s	.p2
	tst.b	(Control_Locked).w	; are controls locked?
	bne.s	.doneController			; if yes, branch
	move.w	(Ctrl_1).w,(Ctrl_1_Logical).w	; copy new held buttons, to enable joypad control
	bra.s	.doneController
.p2:
	tst.b	(Control_Locked_P2).w
	bne.s	.cpu
	move.w	(Ctrl_2).w,(Ctrl_2_Logical).w
.cpu:
	bsr.w	TailsCPU_Control
.doneController:
	btst	#0,obj_control(a0)	; is Amy interacting with another object that holds him in place or controls his movement somehow?
	bne.s	+			; if yes, branch to skip Amy's control
	moveq	#0,d0
	move.b	status(a0),d0
	andi.w	#6,d0	; %0000 %0110
	move.w	Obj_Amy_Modes(pc,d0.w),d1
	jsr	Obj_Amy_Modes(pc,d1.w)	; run Amy's movement control code
+
	cmpi.w	#-$100,(Camera_Min_Y_pos).w	; is vertical wrapping enabled?
	bne.s	+				; if not, branch
	andi.w	#$7FF,y_pos(a0) 		; perform wrapping of Amy's y position
+
	bsr.w	Player_Display
	bsr.w	Player_SuperHyper
	bsr.w	P1_RecordPos
	bsr.w	Sonic_Water
	move.b	(Primary_Angle).w,next_tilt(a0)
	move.b	(Secondary_Angle).w,tilt(a0)
	tst.b	(WindTunnel_flag).w
	beq.s	+
	tst.b	anim(a0)
	bne.s	+
	move.b	next_anim(a0),anim(a0)
+
	bsr.w	Amy_Animate
	tst.b	obj_control(a0)
	bmi.s	+
	jsr	(TouchResponse).l
+
	bra.w	LoadAmyDynPLC

; ===========================================================================
; secondary states under state Obj_Amy_Control
; off_1A0BE:
Obj_Amy_Modes:	offsetTable
		offsetTableEntry.w Obj_Amy_MdNormal     	; 0 - not airborne or rolling
		offsetTableEntry.w Obj_Amy_MdAir			; 2 - airborne
		offsetTableEntry.w Obj_Amy_MdRoll			; 4 - rolling
		offsetTableEntry.w Obj_Amy_MdJump			; 6 - jumping
; ===========================================================================
; loc_1A2B8:
Obj_Amy_MdNormal:
	bsr.w	Amy_CheckSpindash
	bsr.w	Sonic_Jump
	bsr.w	Sonic_SlopeResist
	bsr.w	Sonic_Move
	bsr.w	Player_Roll
	bsr.w	Sonic_LevelBound
	jsr	    (ObjectMove).l
	bsr.w	AnglePos
	bsr.w	Player_SlopeRepel
+	rts
; End of subroutine Obj_Amy_MdNormal
; ===========================================================================
; Start of subroutine Obj_Amy_MdAir
; Called if Amy is airborne, but not in a ball (thus, probably not jumping)
; loc_1A2E0: Obj_Amy_MdJump
Obj_Amy_MdAir:
	cmpi.b	#AniIDSonAni_Spring,anim(a0)
	bne.s	+
	tst.b	y_vel(a0)
	blt.s	+
	move.b	#AniIDSonAni_Fall,anim(a0)
+
;	bsr.w	Player_AirRoll  ; Likely will not have this.
	bsr.w	Player_JumpHeight
	bsr.w	Sonic_ChgJumpDir
	bsr.w	Sonic_LevelBound
	jsr	(ObjectMoveAndFall).l
	btst	#6,status(a0)	; is Amy underwater?
	beq.s	+		; if not, branch
	subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)
+
	bsr.w	Sonic_JumpAngle
	bsr.w	Sonic_DoLevelCollision
	rts
; End of subroutine Obj_Amy_MdAir
; ===========================================================================
; Start of subroutine Obj_Amy_MdRoll
; Called if Amy is in a ball, but not airborne (thus, probably rolling)
; loc_1A30A:
Obj_Amy_MdRoll:
	tst.b	pinball_mode(a0)
	bne.s	+
	bsr.w	Sonic_Jump
+
	bsr.w	Player_RollRepel
	bsr.w	Sonic_RollSpeed
	bsr.w	Sonic_LevelBound
	jsr	(ObjectMove).l
	bsr.w	AnglePos
	bsr.w	Player_SlopeRepel
	rts
; End of subroutine Obj_Amy_MdRoll
; ===========================================================================
; Start of subroutine Obj_Amy_MdJump
; Called if Amy is in a ball and airborne (he could be jumping but not necessarily)
; Notes: This is identical to Obj_Amy_MdAir, at least at this outer level.
;        Why they gave it a separate copy of the code, I don't know.
; loc_1A330: Obj_Amy_MdJump2:
Obj_Amy_MdJump:
	bsr.w	Player_JumpHeight
	bsr.w	Sonic_ChgJumpDir
	bsr.w	Sonic_LevelBound
	jsr	(ObjectMoveAndFall).l
	btst	#6,status(a0)	; is Amy underwater?
	beq.s	+		; if not, branch
	subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)
+
	bsr.w	Sonic_JumpAngle
	bsr.w	Sonic_DoLevelCollision
	rts
; End of subroutine Obj_Amy_MdJump

Obj_Amy_Hurt:		jmp	Obj_Sonic_Hurt
Obj_Amy_Dead:		jmp	Obj_Sonic_Dead
Obj_Amy_Gone:		jmp	Obj_Sonic_Gone
Obj_Amy_Respawning:	jmp	Obj_Sonic_Respawning

; ---------------------------------------------------------------------------
; Subroutine to check for starting to charge a spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1AC3E:
Amy_CheckSpindash:
	btst	#0,spindash_flag(a0)
	bne.s	.update
	cmpi.b	#AniIDSonAni_Duck,anim(a0)
	bne.s	.return
	jsr		GetCtrlPressLogical
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	.return
	move.b	#AniIDSonAni_Spindash,anim(a0)
;	sfx 	sfx_Charge		; These are if you use AMPS
	sfx     sfx_Spindash
	addq.l	#4,sp
	bset	#0,spindash_flag(a0)
	move.w	#$16,inertia(a0)

	clr.w	inertia(a0)
	cmpi.b	#$C,air_left(a0)	; if she's drowning, branch to not make dust
	blo.s	.cont
	jsr		PutDustIntoA1
	move.b	#2,anim(a1)
.cont:
	bsr.w	Sonic_LevelBound
	jsr 	AnglePos

.return:
	rts
; ---------------------------------------------------------------------------

.update:
	jsr		GetCtrlHeldLogical
	btst	#button_down,d0
	bne.w	.charge

	bclr	#0,spindash_flag(a0)	; stop Dashing
	cmpi.b	#$2D,spindash_counter(a0)	; have we been charging long enough?
	bne.w	.stop	; if not, branch
	move.b	#$E,y_radius(a0)
	move.b	#7,x_radius(a0)
	addq.w	#5,y_pos(a0)
	move.b	#AniIDSonAni_Roll,anim(a0)
	bset	#2,status(a0)	; set rolling bit
	move.w	#1,x_vel(a0)	; force X speed to nonzero for camera lag's benefit
	move.w	inertia(a0),d0
	subi.w	#$800,d0
	add.w	d0,d0
	andi.w	#$1F00,d0
	neg.w	d0
	addi.w	#$2000,d0
	;move.w	d0,(v_cameralag).w
	btst	#0,status(a0)
	beq.s	.dontflip
	neg.w	inertia(a0)

.dontflip:
	bclr	#7,status(a0)
;	sfx 	sfx_ChargeRelease
	sfx     sfx_Dash
	jmp     Obj_Sonic_Spindash_ResetScr
; ---------------------------------------------------------------------------

.charge:				; If still charging the dash...
	move.w	(Sonic_top_speed).w,d1	; get top spindash speed
	move.w	d1,d2
	add.w	d1,d1
	btst	#status_sec_hasSpeedShoes,status_secondary(a0) 		; test for speed shoes
	beq.s	.noshoes
	asr.w	#1,d2
	sub.w	d2,d1

.noshoes:
	addi.w	#$64,inertia(a0)		; increment speed
	cmp.w	inertia(a0),d1
	bgt.s	.inctimer
	move.w	d1,inertia(a0)

.inctimer:
	addq.b	#1,spindash_counter(a0)		; increment timer
	cmpi.b	#$2D,spindash_counter(a0)
	jcs 	Obj_Sonic_Spindash_ResetScr
	move.b	#$2D,spindash_counter(a0)
	jmp 	Obj_Sonic_Spindash_ResetScr

.stop:
;	sfx 	sfx_ChargeStop
	clr.w	inertia(a0)
	jsr		ResetHeight_a0
	move.b	#AniIDSonAni_Wait,anim(a0)		; use "standing" animation
	jmp     Obj_Sonic_Spindash_ResetScr

; ---------------------------------------------------------------------------
; Subroutine to animate Amy's sprites
; See also: AnimateSprite
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1B350:
Amy_Animate:
	lea	(AmyAniData).l,a1
	moveq	#0,d0
	move.b	anim(a0),d0
	cmp.b	next_anim(a0),d0	; has animation changed?
	beq.s	AAnim_Do		; if not, branch
	move.b	d0,next_anim(a0)	; set to next animation
	move.b	#0,anim_frame(a0)	; reset animation frame
	move.b	#0,anim_frame_duration(a0)	; reset frame duration
	bclr	#5,status(a0)
; loc_1B384:
AAnim_Do:
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),d0
	bmi.s	AAnim_WalkRun	; if animation is walk/run/roll/jump, branch
	move.b	status(a0),d1
	andi.b	#1,d1
	andi.b	#$FC,render_flags(a0)
	or.b	d1,render_flags(a0)
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	AAnim_Delay			; if time remains, branch
	move.b	d0,anim_frame_duration(a0)	; load frame duration
; loc_1B3AA:
AAnim_Do2:
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	cmpi.b	#$F0,d0
	bhs.s	AAnim_End_FF		; if animation is complete, branch
; loc_1B3BA:
AAnim_Next:
	move.b	d0,mapping_frame(a0)	; load sprite number
	addq.b	#1,anim_frame(a0)	; go to next frame
; return_1B3C2:
AAnim_Delay:
	rts
; ===========================================================================
; loc_1B3C4:
AAnim_End_FF:
	addq.b	#1,d0		; is the end flag = $FF ?
	bne.s	AAnim_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bra.s	AAnim_Next
; ===========================================================================
; loc_1B3D4:
AAnim_End_FE:
	addq.b	#1,d0		; is the end flag = $FE ?
	bne.s	AAnim_End_FD	; if not, branch
	move.b	2(a1,d1.w),d0	; read the next byte in the script
	sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
	sub.b	d0,d1
	move.b	1(a1,d1.w),d0	; read sprite number
	bra.s	AAnim_Next
; ===========================================================================
; loc_1B3E8:
AAnim_End_FD:
	addq.b	#1,d0			; is the end flag = $FD ?
	bne.s	AAnim_End		; if not, branch
	move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
; return_1B3F2:
AAnim_End:
	rts
; ===========================================================================
; loc_1B3F4:
AAnim_WalkRun:
	addq.b	#1,d0		; is the start flag = $FF ?
	bne.w	AAnim_Roll	; if not, branch
	moveq	#0,d0		; is animation walking/running?
	move.b	flip_angle(a0),d0	; if not, branch
	bne.w	AAnim_Tumble
	moveq	#0,d1
	move.b	angle(a0),d0	; get Amy's angle
	bmi.s	+
	beq.s	+
	subq.b	#1,d0
+
	move.b	status(a0),d2
	andi.b	#1,d2		; is Amy mirrored horizontally?
	bne.s	+		; if yes, branch
	not.b	d0		; reverse angle
+
	addi.b	#$10,d0		; add $10 to angle
	bpl.s	+		; if angle is $0-$7F, branch
	moveq	#3,d1
+
	andi.b	#$FC,render_flags(a0)
	eor.b	d1,d2
	or.b	d2,render_flags(a0)
	btst	#5,status(a0)
	bne.w	AAnim_Push
	lsr.b	#4,d0		; divide angle by 16
	andi.b	#6,d0		; angle must be 0, 2, 4 or 6
	mvabs.w	inertia(a0),d2	; get Amy's "speed" for animation purposes
	if status_sec_isSliding = 7
	tst.b	status_secondary(a0)
	bpl.w	+
	else
	btst	#status_sec_isSliding,status_secondary(a0)
	beq.w	+
	endif
	add.w	d2,d2
+
	lea	(AmyAni_Run).l,a1	; use running animation
	cmpi.w	#$600,d2		; is Amy at running speed?
	bhs.s	+			; use running animation
	lea	(AmyAni_Walk).l,a1	; if yes, branch
	add.b	d0,d0
+
	add.b	d0,d0
	move.b	d0,d3
	moveq	#0,d1
	move.b	anim_frame(a0),d1
	move.b	1(a1,d1.w),d0
	cmpi.b	#-1,d0
	bne.s	+
	move.b	#0,anim_frame(a0)
	move.b	1(a1),d0
+
	move.b	d0,mapping_frame(a0)
	add.b	d3,mapping_frame(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	.ret
	neg.w	d2
	addi.w	#$800,d2
	bpl.s	.cont
	moveq	#0,d2
.cont:
	lsr.w	#8,d2
	move.b	d2,anim_frame_duration(a0)	; modify frame duration
	addq.b	#1,anim_frame(a0)		; modify frame number

.ret:
	rts
; ===========================================================================
; loc_1B520:
AAnim_Tumble:
	move.b	flip_angle(a0),d0
	moveq	#0,d1
	move.b	status(a0),d2
	andi.b	#1,d2						; Get the player's direction
	bne.s	AAnim_Tumble_Left			; If they're facing left, go that way
AAnim_Tumble_Right:
	andi.b	#$FC,render_flags(a0)		; Mask out horizontal and vertical flip render flags
	addi.b	#$B,d0						; Add 12 to player's angle
	divu.w	#$16,d0						; Divide by 22 (Makes it round to nearest tumble frame)
	addi.b	#frA_Tumble1,d0				; Add the first tumble frame to the result
	move.b	d0,mapping_frame(a0)		; Display the result
	move.b	#0,anim_frame_duration(a0)	; Dunno why they do this, they modify the frame directly, not via animations
	rts
; ===========================================================================
; loc_1B54E:
AAnim_Tumble_Left:
	andi.b	#$FC,render_flags(a0)		; Mask out HV flags (same as )
	tst.b	flip_turned(a0)				; Check if you've turned while tumbling
	beq.s	+							; loc_1B566
	ori.b	#1,render_flags(a0)			; Make the player face left
	addi.b	#$B,d0						; Do the same rounding math
	bra.s	++							; loc_1B572
; ===========================================================================
; loc_1B566
+	ori.b	#3,render_flags(a0)			; Set both HV flags
	neg.b	d0							; Invert... *something*.
	addi.b	#$8F,d0						; Play the animation in reverse
; loc_1B572
+	divu.w	#$16,d0						; Divide by 22 (Makes it round to nearest tumble frame)
	addi.b	#frA_Tumble1,d0				; Add the first tumble frame to the result
	move.b	d0,mapping_frame(a0)		; Display the result
	move.b	#0,anim_frame_duration(a0)	; Dunno why they do this, they modify the frame directly, not via animations
	rts
; ===========================================================================
; loc_1B586:
AAnim_Roll:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.w	AAnim_Delay			; if time remains, branch
	addq.b	#1,d0		; is the start flag = $FE ?
	bne.s	AAnim_Push	; if not, branch
	mvabs.w	inertia(a0),d2
	lea	(AmyAni_Roll2).l,a1
	cmpi.w	#$600,d2
	bhs.s	+
	lea	(AmyAni_Roll).l,a1
+
	neg.w	d2
	addi.w	#$400,d2
	bpl.s	+
	moveq	#0,d2
+
	lsr.w	#8,d2
	move.b	d2,anim_frame_duration(a0)
	move.b	status(a0),d1
	andi.b	#1,d1
	andi.b	#$FC,render_flags(a0)
	or.b	d1,render_flags(a0)
	bra.w	AAnim_Do2
; ===========================================================================

AAnim_Push:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.w	AAnim_Delay			; if time remains, branch
	move.w	inertia(a0),d2
	bmi.s	+
	neg.w	d2
+
	addi.w	#$800,d2
	bpl.s	+
	moveq	#0,d2
+
	lsr.w	#6,d2
	move.b	d2,anim_frame_duration(a0)
	lea	(AmyAni_Push).l,a1
+
	move.b	status(a0),d1
	andi.b	#1,d1
	andi.b	#$FC,render_flags(a0)
	or.b	d1,render_flags(a0)
	bra.w	AAnim_Do2
; ===========================================================================

	include	"animations/Amy.asm"

; ---------------------------------------------------------------------------
; Amy	graphics loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadAmyDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0	; load frame number
		bsr.w	LoadAmyMap

LoadAmyDynPLC_Part2:
		cmp.b	dplc_prev_frame(a0),d0
		beq.s	.nochange
		move.b	d0,dplc_prev_frame(a0)
		lea	(MapRUnc_Amy).l,a2
	.cont:
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	.nochange
		jsr		DPLC_ArtTileSet
		move.l	#ArtUnc_Amy,d6
	.readentry:
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1
		add.l	d6,d1
		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(QueueDMATransfer).l
		dbf	d5,.readentry	; repeat for number of entries

	.nochange:
		rts	
; End of function LoadAmyDynPLC

LoadAmyMap:
		cmpi.l	#MapUnc_Amy,mappings(a0)
		beq.s	.skip
		move.l	#MapUnc_Amy,mappings(a0)
	.skip:
		rts