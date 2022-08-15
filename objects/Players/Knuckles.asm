Obj_Knuckles:

; FUNCTION CHUNK AT 0033A066 SIZE 0000000E BYTES

		tst.w	(Debug_placement_mode).w
		beq.s	Obj_Knuckles_Normal
		jmp	DebugMode
; ---------------------------------------------------------------------------

Obj_Knuckles_Normal:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Knuckles_Index(pc,d0.w),d1
		jmp	Obj_Knuckles_Index(pc,d1.w)
; End of function Obj_Knuckles

; ---------------------------------------------------------------------------
Obj_Knuckles_Index:	dc.w Obj_Knuckles_Init-Obj_Knuckles_Index	  ; 0 ;	...
		dc.w Obj_Knuckles_Control-Obj_Knuckles_Index	  ; 1
		dc.w Obj_Knuckles_Hurt-Obj_Knuckles_Index	  ; 2
		dc.w Obj_Knuckles_Dead-Obj_Knuckles_Index	  ; 3
		dc.w Obj_Knuckles_Gone-Obj_Knuckles_Index	  ; 4
		dc.w Obj_Knuckles_Respawning-Obj_Knuckles_Index ; 5
; ---------------------------------------------------------------------------

Obj_Knuckles_Init:
		addq.b	#2,routine(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.l	#MapUnc_Knuckles,mappings(a0)	  ; SK_Map_Knuckles
		move.w  #prio(2),priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#4,render_flags(a0)
		move.w	#$600,(Sonic_top_speed).w
		move.w	#$C,(Sonic_acceleration).w
		move.w	#$80,(Sonic_deceleration).w
		tst.b	(Last_star_pole_hit).w
		bne.s	Obj_Knuckles_Init_Continued
		; only happens when not starting at a checkpoint:
		move.w	#make_art_tile(ArtTile_ArtUnc_Sonic,0,0),art_tile(a0)
		move.b	#$C,top_solid_bit(a0)
		move.b	#$D,lrb_solid_bit(a0)
		move.w	x_pos(a0),(Saved_x_pos).w
		move.w	y_pos(a0),(Saved_y_pos).w
		move.w	art_tile(a0),(Saved_art_tile).w
		move.w	top_solid_bit(a0),(Saved_Solid_bits).w

Obj_Knuckles_Init_Continued:
		move.b	#0,flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		move.b	#0,(Super_Sonic_flag).w
		move.b	#$1E,air_left(a0)
		subi.w	#$20,x_pos(a0)
		addi_.w	#4,y_pos(a0)
		move.w	#0,(Sonic_Pos_Record_Index).w

		move.w	#$3F,d2
-		jsr	Sonic_RecordPos
		subq.w	#4,a1
		move.l	#0,(a1)
		dbf	d2,-

		addi.w	#$20,x_pos(a0)
		subi_.w	#4,y_pos(a0)

Obj_Knuckles_Control:
		tst.w	(Debug_mode_flag).w
		beq.s	loc_315422
		btst	#4,(Ctrl_1_Press).w
		beq.s	loc_315422
		move.w	#1,(Debug_placement_mode).w
		clr.b	(Control_Locked).w
		rts
; ---------------------------------------------------------------------------

loc_315422:
		tst.b	(Control_Locked).w
		bne.s	loc_31542E
		move.w	(Ctrl_1).w,(Ctrl_1_Logical).w

loc_31542E:
		btst	#0,obj_control(a0)
		beq.s	loc_31543E
		move.b	#0,double_jump_flag(a0)
		bra.s	loc_315450
; ---------------------------------------------------------------------------

loc_31543E:
		moveq	#0,d0
		move.b	status(a0),d0
		and.w	#6,d0
		move.w	Obj_Knuckles_Modes(pc,d0.w),d1
		jsr	Obj_Knuckles_Modes(pc,d1.w)

loc_315450:
		cmp.w	#-$100,(Camera_Min_Y_pos).w
		bne.s	loc_31545E
		and.w	#$7FF,y_pos(a0)

loc_31545E:
		jsr		Sonic_Display
		jsr		Sonic_Super
		jsr	Sonic_RecordPos
		jsr		Sonic_Water
		move.b	(Primary_Angle).w,next_tilt(a0)
		move.b	(Secondary_Angle).w,tilt(a0)
		tst.b	(WindTunnel_flag).w
		beq.s	loc_31548A
		tst.b	anim(a0)
		bne.s	loc_31548A
		move.b	next_anim(a0),anim(a0)

loc_31548A:
		bsr.w	Knuckles_Animate
		tst.b	obj_control(a0)
		bmi.s	loc_31549A
		jsr	TouchResponse

loc_31549A:
		bra.w	LoadKnucklesDynPLC
; ---------------------------------------------------------------------------
Obj_Knuckles_Modes:	dc.w Obj_Knuckles_MdNormal-Obj_Knuckles_Modes	  ; 0 ;	...
		dc.w Obj_Knuckles_MdAir-Obj_Knuckles_Modes	  ; 1
		dc.w Obj_Knuckles_MdRoll-Obj_Knuckles_Modes	  ; 2
		dc.w Obj_Knuckles_MdJump-Obj_Knuckles_Modes	  ; 3

; =============== S U B	R O U T	I N E =======================================


Obj_Knuckles_MdNormal:
		jsr		Sonic_CheckSpindash
		bsr.w	Knuckles_Jump
		jsr	Sonic_SlopeResist
		bsr.w	Knuckles_Move
		jsr	Sonic_Roll
		jsr	Sonic_LevelBound
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		jsr	AnglePos
		jsr	Player_SlopeRepel
		rts
; End of function Obj_Knuckles_MdNormal


; =============== S U B	R O U T	I N E =======================================


Obj_Knuckles_MdAir:
		tst.b	double_jump_flag(a0)
		bne.s	Obj_Knuckles_MdAir_Gliding
		cmpi.b	#AniIDSonAni_Spring,anim(a0)
		bne.s	+
		tst.b	y_vel(a0)
		blt.s	+
		move.b	#AniIDSonAni_Fall,anim(a0)
+
		jsr		SonicKnux_AirRoll
		bsr.w	Knuckles_JumpHeight
		bsr.w	Knuckles_ChgJumpDir
		jsr	Sonic_LevelBound
		jsr	ObjectMoveAndFall
		btst	#6,status(a0)
		beq.s	loc_31569C
		sub.w	#$28,y_vel(a0)

loc_31569C:
		jsr	Sonic_JumpAngle
		bsr.w	Knuckles_DoLevelCollision
		rts
; ---------------------------------------------------------------------------

Obj_Knuckles_MdAir_Gliding:
		bsr.w	Knuckles_GlideSpeedControl
		jsr	Sonic_LevelBound
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		bsr.w	Knuckles_GlideControl

return_3156B8:
		rts
; End of function Obj_Knuckles_MdAir


; =============== S U B	R O U T	I N E =======================================


Knuckles_GlideControl:

; FUNCTION CHUNK AT 00315C40 SIZE 0000003C BYTES

		move.b	double_jump_flag(a0),d0
		beq.s	return_3156B8
		cmp.b	#2,d0
		beq.w	Knuckles_FallingFromGlide
		cmp.b	#3,d0
		beq.w	Knuckles_Sliding
		cmp.b	#4,d0
		beq.w	Knuckles_Climbing_Wall
		cmp.b	#5,d0
		beq.w	Knuckles_Climbing_Up

Knuckles_NormalGlide:
		move.b	#$A,y_radius(a0)
		move.b	#$A,x_radius(a0)
		bsr.w	Knuckles_DoLevelCollision2
		btst	#5,(Gliding_collision_flags).w
		bne.w	Knuckles_BeginClimb
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		btst	#1,(Gliding_collision_flags).w
		beq.s	Knuckles_BeginSlide
		move.b	(Ctrl_1_Logical).w,d0
		and.b	#$70,d0
		bne.s	loc_31574C
		move.b	#2,double_jump_flag(a0)
		move.b	#33,anim(a0)
		bclr	#0,status(a0)
		tst.w	x_vel(a0)
		bpl.s	loc_315736
		bset	#0,status(a0)

loc_315736:
		asr	x_vel(a0)
		asr	x_vel(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		rts
; ---------------------------------------------------------------------------

loc_31574C:
		bra.w	sub_315C7C
; ---------------------------------------------------------------------------

Knuckles_BeginSlide:
		bclr	#0,status(a0)
		tst.w	x_vel(a0)
		bpl.s	loc_315762
		bset	#0,status(a0)

loc_315762:
		move.b	angle(a0),d0
		add.b	#$20,d0
		and.b	#$C0,d0
		beq.s	loc_315780
		move.w	inertia(a0),x_vel(a0)
		move.w	#0,y_vel(a0)
		bra.w	Knuckles_ResetOnFloor_Part2
; ---------------------------------------------------------------------------

loc_315780:
		move.b	#3,double_jump_flag(a0)
		move.b	#frK_GlideL1,mapping_frame(a0)
		move.b	#$7F,anim_frame_duration(a0)
		move.b	#0,anim_frame(a0)
		cmp.b	#$C,air_left(a0)
		bcs.s	return_3157AC
		move.b	#6,(Sonic_Dust+routine).w
		move.b	#$15,(Sonic_Dust+mapping_frame).w

return_3157AC:
		rts
; ---------------------------------------------------------------------------

Knuckles_BeginClimb:
		tst.b	(Disable_wall_grab).w
		bmi.w	loc_31587A
		move.b	lrb_solid_bit(a0),d5
		move.b	double_jump_property(a0),d0
		add.b	#$40,d0
		bpl.s	loc_3157D8
		bset	#0,status(a0)
		jsr	CheckLeftCeilingDist
		or.w	d0,d1
		bne.s	Knuckles_FallFromGlide
		addq.w	#1,x_pos(a0)
		bra.s	loc_3157E8
; ---------------------------------------------------------------------------

loc_3157D8:
		bclr	#0,status(a0)
		jsr	CheckRightCeilingDist
		or.w	d0,d1
		bne.w	loc_31586A

loc_3157E8:
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		tst.b	(Super_Sonic_flag).w
		beq.s	loc_315804
		cmp.w	#$480,inertia(a0)
		bcs.s	loc_315804
		nop

loc_315804:
		move.w	#0,inertia(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,y_vel(a0)
		move.b	#4,double_jump_flag(a0)
		move.b	#frK_Climb1,mapping_frame(a0)
		move.b	#$7F,anim_frame_duration(a0)
		move.b	#0,anim_frame(a0)
		move.b	#3,double_jump_property(a0)
		move.w	x_pos(a0),x_sub(a0)
		sfx		sfx_Grab
		rts
; ---------------------------------------------------------------------------

Knuckles_FallFromGlide:
		move.w	x_pos(a0),d3
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		subq.w	#1,d3

loc_31584A:
		move.w	y_pos(a0),d2
		sub.w	#$B,d2
		jsr	ChkFloorEdge_Part2
		tst.w	d1
		bmi.s	loc_31587A
		cmp.w	#$C,d1
		bcc.s	loc_31587A
		add.w	d1,y_pos(a0)
		bra.w	loc_3157E8
; ---------------------------------------------------------------------------

loc_31586A:
		move.w	x_pos(a0),d3
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		addq.w	#1,d3

		bra.s	loc_31584A
; ---------------------------------------------------------------------------

loc_31587A:
		move.b	#2,double_jump_flag(a0)
		move.b	#33,anim(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		bset	#1,(Gliding_collision_flags).w
		rts
; ---------------------------------------------------------------------------

Knuckles_FallingFromGlide:
		bsr.w	Knuckles_ChgJumpDir
		add.w	#$38,y_vel(a0)
		btst	#6,status(a0)
		beq.s	loc_3158B2
		sub.w	#$28,y_vel(a0)

loc_3158B2:
		bsr.w	Knuckles_DoLevelCollision2
		btst	#1,(Gliding_collision_flags).w
		bne.s	return_315900
		move.w	#0,inertia(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,y_vel(a0)
		move.b	y_radius(a0),d0
		sub.b	#$13,d0
		ext.w	d0
		add.w	d0,y_pos(a0)
		move.b	angle(a0),d0
		add.b	#$20,d0
		and.b	#$C0,d0
		beq.s	loc_3158F0
		bra.w	Knuckles_ResetOnFloor_Part2
; ---------------------------------------------------------------------------

loc_3158F0:
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.w	#$F,move_lock(a0)
		move.b	#35,anim(a0)
		sfx		sfx_GlideLand

return_315900:
		rts
; ---------------------------------------------------------------------------

Knuckles_Sliding:
		move.b	(Ctrl_1_Logical).w,d0
		and.b	#$70,d0
		beq.s	loc_315926
		tst.w	x_vel(a0)
		bpl.s	loc_31591E
		add.w	#$20,x_vel(a0)
		bmi.s	loc_31591C
		bra.s	loc_315926
; ---------------------------------------------------------------------------

loc_31591C:
		bra.s	loc_315958
; ---------------------------------------------------------------------------

loc_31591E:
		sub.w	#$20,x_vel(a0)
		bpl.s	loc_315958

loc_315926:
		move.w	#0,inertia(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,y_vel(a0)
		move.b	y_radius(a0),d0
		sub.b	#$13,d0
		ext.w	d0
		add.w	d0,y_pos(a0)
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.w	#$F,move_lock(a0)
		move.b	#34,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_315958:
		move.b	#$A,y_radius(a0)
		move.b	#$A,x_radius(a0)
		bsr.w	Knuckles_DoLevelCollision2
		jsr	Player_CheckFloor
		cmp.w	#$E,d1
		bge.s	loc_315988
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		; play slide sfx
		move.b	(Timer_frames+1).w,d0
		andi.b	#7,d0
		bne.s	+
		sfx		sfx_GroundSlide
+		rts
; ---------------------------------------------------------------------------

loc_315988:
		move.b	#2,double_jump_flag(a0)
		move.b	#33,anim(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		bset	#1,(Gliding_collision_flags).w
		rts
; ---------------------------------------------------------------------------

Knuckles_Climbing_Wall:
		tst.b	(Disable_wall_grab).w
		bmi.w	loc_315BAE
		move.w	x_pos(a0),d0
		cmp.w	x_sub(a0),d0
		bne.w	loc_315BAE
		btst	#3,status(a0)
		bne.w	loc_315BAE
		move.w	#0,inertia(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,y_vel(a0)
		move.l	#Primary_Collision,(Collision_addr).w
		cmp.b	#$D,lrb_solid_bit(a0)
		beq.s	loc_3159F0
		move.l	#Secondary_Collision,(Collision_addr).w

loc_3159F0:
		move.b	lrb_solid_bit(a0),d5
		move.b	#$A,y_radius(a0)
		move.b	#$A,x_radius(a0)
		moveq	#0,d1
		btst	#0,(Ctrl_1_Logical).w
		beq.w	loc_315A76
		move.w	y_pos(a0),d2
		sub.w	#$B,d2
		bsr.w	sub_315C22
		cmp.w	#4,d1
		bge.w	Knuckles_ClimbUp	  ; Climb onto the floor above you
		tst.w	d1
		bne.w	loc_315B30
		move.b	lrb_solid_bit(a0),d5
		move.w	y_pos(a0),d2
		subq.w	#8,d2
		move.w	x_pos(a0),d3
		bsr.w	sub_3192E6		  ; Doesn't exist in S2
		tst.w	d1
		bpl.s	loc_315A46
		sub.w	d1,y_pos(a0)
		moveq	#1,d1
		bra.w	loc_315B04
; ---------------------------------------------------------------------------

loc_315A46:
		subq.w	#1,y_pos(a0)
		tst.b	(Super_Sonic_flag).w
		beq.s	loc_315A54
		subq.w	#1,y_pos(a0)

loc_315A54:
		moveq	#1,d1
		move.w	(Camera_Min_Y_pos).w,d0
		cmp.w	#-$100,d0
		beq.w	loc_315B04
		add.w	#$10,d0
		cmp.w	y_pos(a0),d0
		ble.w	loc_315B04
		move.w	d0,y_pos(a0)
		bra.w	loc_315B04
; ---------------------------------------------------------------------------

loc_315A76:
		btst	#1,(Ctrl_1_Logical).w
		beq.w	loc_315B04
		cmp.b	#frK_Climb6,mapping_frame(a0)
		bne.s	loc_315AA2
		move.b	#frK_Climb1,mapping_frame(a0)
		addq.w	#3,y_pos(a0)
		subq.w	#3,x_pos(a0)
		btst	#0,status(a0)
		beq.s	loc_315AA2
		addq.w	#6,x_pos(a0)

loc_315AA2:
		move.w	y_pos(a0),d2
		add.w	#$B,d2
		bsr.w	sub_315C22
		tst.w	d1
		bne.w	loc_315BAE
		move.b	top_solid_bit(a0),d5
		move.w	y_pos(a0),d2
		add.w	#9,d2
		move.w	x_pos(a0),d3
		bsr.w	sub_318FF6
		tst.w	d1
		bpl.s	loc_315AF4
		add.w	d1,y_pos(a0)
		move.b	(Primary_Angle).w,angle(a0)
		move.w	#0,inertia(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,y_vel(a0)
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.b	#AniIDSonAni_Wait,anim(a0)
		rts
; ---------------------------------------------------------------------------

loc_315AF4:
		addq.w	#1,y_pos(a0)
		tst.b	(Super_Sonic_flag).w
		beq.s	loc_315B02
		addq.w	#1,y_pos(a0)

loc_315B02:
		moveq	#-1,d1

loc_315B04:
		tst.w	d1
		beq.s	loc_315B30
		subq.b	#1,double_jump_property(a0)
		bpl.s	loc_315B30
		move.b	#3,double_jump_property(a0)
		add.b	mapping_frame(a0),d1
		cmp.b	#frK_Climb1,d1
		bcc.s	loc_315B22
		move.b	#frK_Climb6,d1

loc_315B22:
		cmp.b	#frK_Climb6,d1
		bls.s	loc_315B2C
		move.b	#frK_Climb1,d1

loc_315B2C:
		move.b	d1,mapping_frame(a0)

loc_315B30:
		move.b	#$20,anim_frame_duration(a0)
		move.b	#0,anim_frame(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.w	(Ctrl_1_Logical).w,d0
		and.w	#$70,d0
		beq.s	return_315B94
		move.w	#$FC80,y_vel(a0)
		move.w	#$400,x_vel(a0)
		bchg	#0,status(a0)
		bne.s	loc_315B6A
		neg.w	x_vel(a0)

loc_315B6A:
		bset	#1,status(a0)
		move.b	#1,jumping(a0)
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#AniIDSonAni_Roll,anim(a0)
		bset	#2,status(a0)
		move.b	#0,double_jump_flag(a0)

return_315B94:
		rts
; ---------------------------------------------------------------------------

Knuckles_ClimbUp:
		move.b	#5,double_jump_flag(a0)		  ; Climb up to	the floor above	you
		cmp.b	#frK_Climb6,mapping_frame(a0)
		beq.s	return_315BAC
		move.b	#0,double_jump_property(a0)
		bsr.s	Knuckles_DoLedgeClimbingAnimation

return_315BAC:
		rts
; ---------------------------------------------------------------------------

loc_315BAE:
		move.b	#2,double_jump_flag(a0)
		move.b	#33,anim(a0)
		move.b	#33,next_anim(a0)
		move.b	#frK_GlideX2,mapping_frame(a0)
		move.b	#7,anim_frame_duration(a0)
		move.b	#1,anim_frame(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		rts
; End of function Knuckles_GlideControl


; =============== S U B	R O U T	I N E =======================================


Knuckles_DoLedgeClimbingAnimation:
		moveq	#0,d0
		move.b	double_jump_property(a0),d0
		lea	Knuckles_ClimbLedge_Frames(pc,d0.w),a1
		move.b	(a1)+,mapping_frame(a0)
		move.b	(a1)+,d0
		ext.w	d0
		btst	#0,status(a0)
		beq.s	loc_315BF6
		neg.w	d0

loc_315BF6:
		add.w	d0,x_pos(a0)
		move.b	(a1)+,d1
		ext.w	d1
		add.w	d1,y_pos(a0)
		move.b	(a1)+,anim_frame_duration(a0)
		addq.b	#4,double_jump_property(a0)
		move.b	#0,anim_frame(a0)
		rts
; End of function Knuckles_DoLedgeClimbingAnimation

; ---------------------------------------------------------------------------
; Strangely, the last frame uses frame frK_Idle2. It will never be seen, however,
; because it is immediately overwritten by Knuckles' waiting animation.

Knuckles_ClimbLedge_Frames:
	; mapping_frame, x_pos, y_pos, anim_frame_timer
	dc.b  frK_ClimbU1,    3,   -3,    6
	dc.b  frK_ClimbU2,    8,  -10,    6
	dc.b  frK_ClimbU3,   -8,  -12,    6
	dc.b  frK_Idle2,    8,   -5,    6
Knuckles_ClimbLedge_Frames_End:

; =============== S U B	R O U T	I N E =======================================


sub_315C22:

; FUNCTION CHUNK AT 00319208 SIZE 00000020 BYTES
; FUNCTION CHUNK AT 003193D2 SIZE 00000024 BYTES

		move.b	lrb_solid_bit(a0),d5
		btst	#0,status(a0)
		bne.s	loc_315C36
		move.w	x_pos(a0),d3
		bra.w	loc_319208
; ---------------------------------------------------------------------------

loc_315C36:
		move.w	x_pos(a0),d3
		subq.w	#1,d3
		bra.w	loc_3193D2
; End of function sub_315C22

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR Knuckles_GlideControl

Knuckles_Climbing_Up:
		tst.b	anim_frame_duration(a0)
		bne.s	return_315C7A

		bsr.w	Knuckles_DoLedgeClimbingAnimation

		cmp.b	#Knuckles_ClimbLedge_Frames_End-Knuckles_ClimbLedge_Frames,double_jump_property(a0)
		bne.s	return_315C7A

		move.w	#0,inertia(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,y_vel(a0)

		btst	#0,status(a0)
		beq.s	loc_315C70
		subq.w	#1,x_pos(a0)

loc_315C70:
		bsr.w	Knuckles_ResetOnFloor_Part2
		move.b	#AniIDSonAni_Wait,anim(a0)

return_315C7A:
		rts
; END OF FUNCTION CHUNK	FOR Knuckles_GlideControl

; =============== S U B	R O U T	I N E =======================================


sub_315C7C:
		move.b	#$20,anim_frame_duration(a0)
		move.b	#0,anim_frame(a0)
		move.b	#32,anim(a0)
		move.b	#32,next_anim(a0)
		bclr	#5,status(a0)
		bclr	#0,status(a0)
		moveq	#0,d0
		move.b	double_jump_property(a0),d0
		add.b	#$10,d0
		lsr.w	#5,d0
		move.b	RawAni_Knuckles_GlideTurn(pc,d0.w),d1
		move.b	d1,mapping_frame(a0)
		cmp.b	#frK_Glide5,d1
		bne.s	return_315CC0
		bset	#0,status(a0)
		move.b	#frK_Glide1,mapping_frame(a0)

return_315CC0:
		rts
; End of function sub_315C7C

; ---------------------------------------------------------------------------
RawAni_Knuckles_GlideTurn:
		dc.b frK_Glide1
		dc.b frK_Glide2
		dc.b frK_Glide3
		dc.b frK_Glide4
		dc.b frK_Glide5
		dc.b frK_Glide4
		dc.b frK_Glide3
		dc.b frK_Glide2

; =============== S U B	R O U T	I N E =======================================


Knuckles_GlideSpeedControl:
		cmp.b	#1,double_jump_flag(a0)
		bne.w	loc_315D88
		move.w	inertia(a0),d0
		cmp.w	#$400,d0
		bcc.s	loc_315CE2
		addq.w	#8,d0
		bra.s	loc_315CFC
; ---------------------------------------------------------------------------

loc_315CE2:
		cmp.w	#$1800,d0
		bcc.s	loc_315CFC
		move.b	double_jump_property(a0),d1
		and.b	#$7F,d1
		bne.s	loc_315CFC
		addq.w	#4,d0
		tst.b	(Super_Sonic_flag).w
		beq.s	loc_315CFC
		addq.w	#8,d0

loc_315CFC:
		move.w	d0,inertia(a0)
		move.b	double_jump_property(a0),d0
		btst	#2,(Ctrl_1_Logical).w
		beq.s	loc_315D1C
		cmp.b	#$80,d0
		beq.s	loc_315D1C
		tst.b	d0
		bpl.s	loc_315D18
		neg.b	d0

loc_315D18:
		addq.b	#2,d0
		bra.s	loc_315D3A
; ---------------------------------------------------------------------------

loc_315D1C:
		btst	#3,(Ctrl_1_Logical).w
		beq.s	loc_315D30
		tst.b	d0
		beq.s	loc_315D30
		bmi.s	loc_315D2C
		neg.b	d0

loc_315D2C:
		addq.b	#2,d0
		bra.s	loc_315D3A
; ---------------------------------------------------------------------------

loc_315D30:
		move.b	d0,d1
		and.b	#$7F,d1
		beq.s	loc_315D3A
		addq.b	#2,d0

loc_315D3A:
		move.b	d0,double_jump_property(a0)
		move.b	double_jump_property(a0),d0
		jsr	CalcSine
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		cmp.w	#$80,y_vel(a0)
		blt.s	loc_315D62
		sub.w	#$20,y_vel(a0)
		bra.s	loc_315D68
; ---------------------------------------------------------------------------

loc_315D62:
		add.w	#$20,y_vel(a0)

loc_315D68:
		move.w	(Camera_Min_Y_pos).w,d0
		cmp.w	#-$100,d0
		beq.w	loc_315D88
		add.w	#$10,d0
		cmp.w	y_pos(a0),d0
		ble.w	loc_315D88
		asr	x_vel(a0)
		asr	inertia(a0)

loc_315D88:
		cmp.w	#$60,(Camera_Y_pos_bias).w
		beq.s	return_315D9A
		bcc.s	loc_315D96
		addq.w	#4,(Camera_Y_pos_bias).w

loc_315D96:
		subq.w	#2,(Camera_Y_pos_bias).w

return_315D9A:
		rts
; End of function Knuckles_GlideSpeedControl

; ---------------------------------------------------------------------------

Obj_Knuckles_MdRoll:
		tst.b	pinball_mode(a0)
		bne.s	loc_315DA6
		bsr.w	Knuckles_Jump

loc_315DA6:
		jsr	Sonic_RollRepel
		jsr	Sonic_RollSpeed
		jsr	Sonic_LevelBound
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		jsr	AnglePos
		jsr	Player_SlopeRepel
		rts
; ---------------------------------------------------------------------------

Obj_Knuckles_MdJump:
		bsr.w	Knuckles_JumpHeight
		bsr.w	Knuckles_ChgJumpDir
		jsr	Sonic_LevelBound
		jsr	ObjectMoveAndFall
		btst	#6,status(a0)
		beq.s	loc_315DE2
		sub.w	#$28,y_vel(a0)

loc_315DE2:
		jsr	Sonic_JumpAngle
		bsr.w	Knuckles_DoLevelCollision
		rts

; =============== S U B	R O U T	I N E =======================================


Knuckles_Move:
		move.w	(Sonic_top_speed).w,d6
		move.w	(Sonic_acceleration).w,d5
		move.w	(Sonic_deceleration).w,d4
		tst.b	status_secondary(a0)
		bmi.w	Obj_Knuckles_Traction
		tst.w	move_lock(a0)
		bne.w	Obj_Knuckles_ResetScreen
		btst	#2,(Ctrl_1_Logical).w
		beq.s	Obj_Knuckles_NotLeft
		bsr.w	Knuckles_MoveLeft

Obj_Knuckles_NotLeft:
		btst	#3,(Ctrl_1_Logical).w
		beq.s	Obj_Knuckles_NotRight
		bsr.w	Knuckles_MoveRight

Obj_Knuckles_NotRight:
		move.b	angle(a0),d0
		add.b	#$20,d0
		and.b	#$C0,d0
		bne.w	Obj_Knuckles_ResetScreen
		tst.w	inertia(a0)
		bne.w	Obj_Knuckles_ResetScreen
		bclr	#5,status(a0)
		move.b	#AniIDSonAni_Wait,anim(a0)
		btst	#3,status(a0)
		beq.w	Knuckles_Balance
		moveq	#0,d0
		move.w	interact(a0),d0
		tst.b	status(a1)
		bmi.w	Knuckles_LookUp
		moveq	#0,d1
		move.b	width_pixels(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#2,d2
		add.w	x_pos(a0),d1
		sub.w	x_pos(a1),d1
		cmp.w	#2,d1
		blt.s	Knuckles_BalanceOnObjLeft
		cmp.w	d2,d1
		bge.s	Knuckles_BalanceOnObjRight
		bra.w	Knuckles_LookUp
; ---------------------------------------------------------------------------

Knuckles_BalanceOnObjRight:
		btst	#0,status(a0)
		bne.s	loc_315E9A
		move.b	#AniIDSonAni_Balance,anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

loc_315E9A:
		bclr	#0,status(a0)
		move.b	#0,anim_frame_duration(a0)
		move.b	#4,anim_frame(a0)
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.b	#AniIDSonAni_Balance,next_anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_BalanceOnObjLeft:
		btst	#0,status(a0)
		beq.s	loc_315EC8
		move.b	#AniIDSonAni_Balance,anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

loc_315EC8:
		bset	#0,status(a0)
		move.b	#0,anim_frame_duration(a0)
		move.b	#4,anim_frame(a0)
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.b	#AniIDSonAni_Balance,next_anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_Balance:
		jsr	ChkFloorEdge
		cmp.w	#$C,d1
		blt.w	Knuckles_LookUp
		cmp.b	#3,next_tilt(a0)
		bne.s	Knuckles_BalanceLeft
		btst	#0,status(a0)
		bne.s	loc_315F0C
		move.b	#AniIDSonAni_Balance,anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

loc_315F0C:
		bclr	#0,status(a0)
		move.b	#0,anim_frame_duration(a0)
		move.b	#4,anim_frame(a0)
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.b	#AniIDSonAni_Balance,next_anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_BalanceLeft:
		cmp.b	#3,tilt(a0)
		bne.s	Knuckles_LookUp
		btst	#0,status(a0)
		beq.s	loc_315F42
		move.b	#AniIDSonAni_Balance,anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

loc_315F42:
		bset	#0,status(a0)
		move.b	#0,anim_frame_duration(a0)
		move.b	#4,anim_frame(a0)
		move.b	#AniIDSonAni_Balance,anim(a0)
		move.b	#AniIDSonAni_Balance,next_anim(a0)
		bra.w	Obj_Knuckles_ResetScreen
; ---------------------------------------------------------------------------

Knuckles_LookUp:
		btst	#0,(Ctrl_1_Logical).w
		beq.s	Knuckles_Duck
		move.b	#AniIDSonAni_LookUp,anim(a0)
		addq.w	#1,(Sonic_Look_delay_counter).w
		cmp.w	#$78,(Sonic_Look_delay_counter).w
		bcs.s	Obj_Knuckles_ResetScreen_Part2
		move.w	#$78,(Sonic_Look_delay_counter).w
		cmp.w	#$C8,(Camera_Y_pos_bias).w
		beq.s	Obj_Knuckles_UpdateSpeedOnGround
		addq.w	#2,(Camera_Y_pos_bias).w
		bra.s	Obj_Knuckles_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

Knuckles_Duck:
		btst	#1,(Ctrl_1_Logical).w
		beq.s	Obj_Knuckles_ResetScreen
		move.b	#AniIDSonAni_Duck,anim(a0)
		addq.w	#1,(Sonic_Look_delay_counter).w
		cmp.w	#$78,(Sonic_Look_delay_counter).w
		bcs.s	Obj_Knuckles_ResetScreen_Part2
		move.w	#$78,(Sonic_Look_delay_counter).w
		cmp.w	#8,(Camera_Y_pos_bias).w
		beq.s	Obj_Knuckles_UpdateSpeedOnGround
		subq.w	#2,(Camera_Y_pos_bias).w
		bra.s	Obj_Knuckles_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

Obj_Knuckles_ResetScreen:
		move.w	#0,(Sonic_Look_delay_counter).w

Obj_Knuckles_ResetScreen_Part2:
		cmp.w	#$60,(Camera_Y_pos_bias).w
		beq.s	Obj_Knuckles_UpdateSpeedOnGround
		bcc.s	loc_315FCE
		addq.w	#4,(Camera_Y_pos_bias).w

loc_315FCE:
		subq.w	#2,(Camera_Y_pos_bias).w

Obj_Knuckles_UpdateSpeedOnGround:
		tst.b	(Super_Sonic_flag).w
		beq.s	loc_315FDC
		move.w	#$C,d5

loc_315FDC:
		move.b	(Ctrl_1_Logical).w,d0
		and.b	#$C,d0
		bne.s	Obj_Knuckles_Traction
		move.w	inertia(a0),d0
		beq.s	Obj_Knuckles_Traction
		bmi.s	Obj_Knuckles_SettleLeft
		sub.w	d5,d0
		bcc.s	loc_315FF6
		move.w	#0,d0

loc_315FF6:
		move.w	d0,inertia(a0)
		bra.s	Obj_Knuckles_Traction
; ---------------------------------------------------------------------------

Obj_Knuckles_SettleLeft:
		add.w	d5,d0
		bcc.s	loc_316004
		move.w	#0,d0

loc_316004:
		move.w	d0,inertia(a0)

Obj_Knuckles_Traction:
		move.b	angle(a0),d0
		jsr	CalcSine
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

Obj_Knuckles_CheckWallsOnGround:
		move.b	angle(a0),d0
		add.b	#$40,d0
		bmi.s	return_3160A6
		move.b	#$40,d1
		tst.w	inertia(a0)
		beq.s	return_3160A6
		bmi.s	loc_31603E
		neg.w	d1

loc_31603E:
		move.b	angle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		jsr	CalcRoomInFront		  ; Also known as Sonic_WalkSpeed in Sonic 1
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	return_3160A6
		asl.w	#8,d1
		add.b	#$20,d0
		and.b	#$C0,d0
		beq.s	loc_3160A2
		cmp.b	#$40,d0
		beq.s	loc_316088
		cmp.b	#$80,d0
		beq.s	loc_316082
		add.w	d1,x_vel(a0)
		move.w	#0,inertia(a0)
		btst	#0,status(a0)
		bne.s	return_316080
		bset	#5,status(a0)

return_316080:
		rts
; ---------------------------------------------------------------------------

loc_316082:
		sub.w	d1,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_316088:
		sub.w	d1,x_vel(a0)
		move.w	#0,inertia(a0)
		btst	#0,status(a0)
		beq.s	return_316080
		bset	#5,status(a0)
		rts
; ---------------------------------------------------------------------------

loc_3160A2:
		add.w	d1,y_vel(a0)

return_3160A6:
		rts
; End of function Knuckles_Move


; =============== S U B	R O U T	I N E =======================================


Knuckles_MoveLeft:
		move.w	inertia(a0),d0
		beq.s	loc_3160B0
		bpl.s	Knuckles_TurnLeft

loc_3160B0:
		bset	#0,status(a0)
		bne.s	loc_3160C4
		bclr	#5,status(a0)
		move.b	#1,next_anim(a0)

loc_3160C4:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_3160D6
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s	loc_3160D6
		move.w	d1,d0

loc_3160D6:
		move.w	d0,inertia(a0)
		move.b	#AniIDSonAni_Walk,anim(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_TurnLeft:
		sub.w	d4,d0
		bcc.s	loc_3160EA
		move.w	#-$80,d0

loc_3160EA:
		move.w	d0,inertia(a0)
		move.b	angle(a0),d1
		add.b	#$20,d1
		and.b	#$C0,d1
		bne.s	return_31612C
		cmp.w	#$400,d0
		blt.s	return_31612C
		move.b	#AniIDSonAni_Stop,anim(a0)
		bclr	#0,status(a0)
		sfx	sfx_Skid
		cmp.b	#$C,air_left(a0)
		bcs.s	return_31612C
		move.b	#6,(Sonic_Dust+routine).w
		move.b	#$15,(Sonic_Dust+mapping_frame).w

return_31612C:
		rts
; End of function Knuckles_MoveLeft


; =============== S U B	R O U T	I N E =======================================


Knuckles_MoveRight:
		move.w	inertia(a0),d0
		bmi.s	Knuckles_TurnRight
		bclr	#0,status(a0)
		beq.s	loc_316148
		bclr	#5,status(a0)
		move.b	#1,next_anim(a0)

loc_316148:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_316156
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	loc_316156
		move.w	d6,d0

loc_316156:
		move.w	d0,inertia(a0)
		move.b	#AniIDSonAni_Walk,anim(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_TurnRight:
		add.w	d4,d0
		bcc.s	loc_31616A
		move.w	#$80,d0

loc_31616A:
		move.w	d0,inertia(a0)
		move.b	angle(a0),d1
		add.b	#$20,d1
		and.b	#$C0,d1
		bne.s	return_3161AC
		cmp.w	#$FC00,d0
		bgt.s	return_3161AC
		move.b	#AniIDSonAni_Stop,anim(a0)
		bset	#0,status(a0)
		sfx	sfx_Skid
		cmp.b	#$C,air_left(a0)
		bcs.s	return_3161AC
		move.b	#6,(Sonic_Dust+routine).w
		move.b	#$15,(Sonic_Dust+mapping_frame).w

return_3161AC:
		rts
; End of function Knuckles_MoveRight

; ---------------------------------------------------------------------------
; Subroutine for moving	Knuckles left or right when he's in the air
; ---------------------------------------------------------------------------

; =============== S U B	R O U T	I N E =======================================


Knuckles_ChgJumpDir:
		move.w	(Sonic_top_speed).w,d6
		move.w	(Sonic_acceleration).w,d5
		asl.w	#1,d5
		btst	#4,status(a0)
		bne.s	Obj_Knuckles_Jump_ResetScreen
		move.w	x_vel(a0),d0
		btst	#2,(Ctrl_1_Logical).w
		beq.s	loc_31630E

		bset	#0,status(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_31630E
		cmpi.b	#GameModeID_Demo,(Game_Mode).w	; Demo Mode?
		beq.w	loc_31630C
		add.w	d5,d0
		cmp.w	d1,d0
		ble.s	loc_31630E

loc_31630C:
		move.w	d1,d0

loc_31630E:
		btst	#3,(Ctrl_1_Logical).w
		beq.s	loc_316332
		bclr	#0,status(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_316332
		cmpi.b	#GameModeID_Demo,(Game_Mode).w	; Demo Mode?
		beq.w	loc_316330
		sub.w	d5,d0
		cmp.w	d6,d0
		bge.s	loc_316332

loc_316330:
		move.w	d6,d0

loc_316332:
		move.w	d0,x_vel(a0)

Obj_Knuckles_Jump_ResetScreen:
		cmp.w	#$60,(Camera_Y_pos_bias).w
		beq.s	Knuckles_JumpPeakDecelerate
		bcc.s	loc_316344
		addq.w	#4,(Camera_Y_pos_bias).w

loc_316344:
		subq.w	#2,(Camera_Y_pos_bias).w

Knuckles_JumpPeakDecelerate:
		cmp.w	#-$400,y_vel(a0)
		bcs.s	return_316376
		move.w	x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	return_316376
		bmi.s	Knuckles_JumpPeakDecelerateLeft
		sub.w	d1,d0
		bcc.s	loc_316364
		move.w	#0,d0

loc_316364:
		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_JumpPeakDecelerateLeft:
		sub.w	d1,d0
		bcs.s	loc_316372
		move.w	#0,d0

loc_316372:
		move.w	d0,x_vel(a0)

return_316376:
		rts
; End of function Knuckles_ChgJumpDir

; =============== S U B	R O U T	I N E =======================================


Knuckles_Jump:
		move.b	(Ctrl_1_Press_Logical).w,d0
		and.b	#$70,d0
		beq.w	return_3164EC
		moveq	#0,d0
		move.b	angle(a0),d0
		add.b	#$80,d0
		jsr	CalcRoomOverHead
		cmp.w	#6,d1
		blt.w	return_3164EC
		move.w	#$600,d2
		btst	#6,status(a0)
		beq.s	loc_316470
		move.w	#$300,d2

loc_316470:
		cmpi.b	#GameModeID_Demo,(Game_Mode).w	; Demo Mode?
		bne.s	loc_31647A
		add.w	#$80,d2			  ; Set	the jump height	to Sonic's height in Demo mode because Sonic Team were too lazy to record new demos for S2&K.

loc_31647A:
		moveq	#0,d0
		move.b	angle(a0),d0
		sub.b	#$40,d0
		jsr	CalcSine
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,y_vel(a0)
		bset	#1,status(a0)
		bclr	#5,status(a0)
		addq.l	#4,sp
		move.b	#1,jumping(a0)
		clr.b	stick_to_convex(a0)

loc_3164B2:
		sfx	sfx_Jump	; play jumping sound
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		btst	#2,status(a0)
		bne.s	Knuckles_RollJump
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#AniIDSonAni_Roll,anim(a0)
		bset	#2,status(a0)
		addq.w	#5,y_pos(a0)

return_3164EC:
		rts
; ---------------------------------------------------------------------------

Knuckles_RollJump:
		bset	#4,status(a0)
		rts
; End of function Knuckles_Jump


; =============== S U B	R O U T	I N E =======================================


Knuckles_JumpHeight:
		tst.b	jumping(a0)
		beq.s	Knuckles_UpwardsVelocityCap
		move.w	#-$400,d1
		btst	#6,status(a0)
		beq.s	loc_31650C
		move.w	#-$200,d1

loc_31650C:
		cmp.w	y_vel(a0),d1
		ble.w	Knuckles_CheckGlide	  ; Check if Knuckles should begin a glide
		move.b	(Ctrl_1_Logical).w,d0
		and.b	#$70,d0
		bne.s	return_316522
		move.w	d1,y_vel(a0)

return_316522:
		rts
; ---------------------------------------------------------------------------

Knuckles_UpwardsVelocityCap:
		tst.b	pinball_mode(a0)
		bne.s	return_316538
		cmp.w	#-$FC0,y_vel(a0)
		bge.s	return_316538
		move.w	#-$FC0,y_vel(a0)

return_316538:
		rts
; ---------------------------------------------------------------------------

Knuckles_CheckGlide:
		cmpi.b	#GameModeID_Demo,(Game_Mode).w		  ; Don't glide on demos
		beq.w	return_3165D2
		tst.b	double_jump_flag(a0)
		bne.w	return_3165D2
		move.b	(Ctrl_1_Press_Logical).w,d0
		and.b	#$70,d0
		beq.w	return_3165D2
		tst.b	(Super_Sonic_flag).w
		bne.s	Knuckles_BeginGlide
		cmp.b	#7,(Emerald_count).w
		bcs.s	Knuckles_BeginGlide
		cmp.w	#50,(Ring_count).w
		bcs.s	Knuckles_BeginGlide
		tst.b	(Update_HUD_timer).w
		jne		Sonic_TurnSuper

Knuckles_BeginGlide:
		bclr	#2,status(a0)
		move.b	#$A,y_radius(a0)
		move.b	#$A,x_radius(a0)
		bclr	#4,status(a0)
		move.b	#1,double_jump_flag(a0)
		add.w	#$200,y_vel(a0)
		bpl.s	loc_31659E
		move.w	#0,y_vel(a0)

loc_31659E:
		moveq	#0,d1
		move.w	#$400,d0
		move.w	d0,inertia(a0)
		btst	#0,status(a0)
		beq.s	loc_3165B4
		neg.w	d0
		moveq	#-$80,d1

loc_3165B4:
		move.w	d0,x_vel(a0)
		move.b	d1,double_jump_property(a0)
		move.w	#0,angle(a0)
		move.b	#0,(Gliding_collision_flags).w
		bset	#1,(Gliding_collision_flags).w
		bsr.w	sub_315C7C

return_3165D2:
		rts
; End of function Knuckles_JumpHeight


; =============== S U B	R O U T	I N E =======================================


Knuckles_DoLevelCollision2:
		move.l	#Primary_Collision,(Collision_addr).w
		cmp.b	#$C,top_solid_bit(a0)
		beq.s	loc_31694E
		move.l	#Secondary_Collision,(Collision_addr).w

loc_31694E:
		move.b	lrb_solid_bit(a0),d5
		move.w	x_vel(a0),d1
		move.w	y_vel(a0),d2
		jsr	CalcAngle
		sub.b	#$20,d0
		and.b	#$C0,d0
		cmp.b	#$40,d0
		beq.w	Knuckles_HitLeftWall2
		cmp.b	#$80,d0
		beq.w	Knuckles_HitCeilingAndWalls2
		cmp.b	#$C0,d0
		beq.w	Knuckles_HitRightWall2
		jsr	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_316998
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		bset	#5,(Gliding_collision_flags).w

loc_316998:
		jsr	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_3169B0
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		bset	#5,(Gliding_collision_flags).w

loc_3169B0:
		jsr	Player_CheckFloor
		tst.w	d1
		bpl.s	return_3169CC
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		move.w	#0,y_vel(a0)
		bclr	#1,(Gliding_collision_flags).w

return_3169CC:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitLeftWall2:
		jsr	CheckLeftWallDist
		tst.w	d1
		bpl.s	Knuckles_HitCeilingAlt
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		bset	#5,(Gliding_collision_flags).w

Knuckles_HitCeilingAlt:
		jsr	Player_CheckCeiling
		tst.w	d1
		bpl.s	Knuckles_HitFloor
		neg.w	d1
		cmp.w	#$14,d1
		bcc.s	loc_316A08
		add.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	return_316A06
		move.w	#0,y_vel(a0)

return_316A06:
		rts
; ---------------------------------------------------------------------------

loc_316A08:
		jsr	CheckRightWallDist
		tst.w	d1
		bpl.s	return_316A20
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		bset	#5,(Gliding_collision_flags).w

return_316A20:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitFloor:
		tst.w	y_vel(a0)
		bmi.s	return_316A44
		jsr	Player_CheckFloor
		tst.w	d1
		bpl.s	return_316A44
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		move.w	#0,y_vel(a0)
		bclr	#1,(Gliding_collision_flags).w

return_316A44:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitCeilingAndWalls2:
		jsr	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_316A5E
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		bset	#5,(Gliding_collision_flags).w

loc_316A5E:
		jsr	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_316A76
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		bset	#5,(Gliding_collision_flags).w

loc_316A76:
		jsr	Player_CheckCeiling
		tst.w	d1
		bpl.s	return_316A88
		sub.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)

return_316A88:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitRightWall2:
		jsr	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_316AA2
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		bset	#5,(Gliding_collision_flags).w

loc_316AA2:
		jsr	Player_CheckCeiling
		tst.w	d1
		bpl.s	loc_316ABC
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	return_316ABA
		move.w	#0,y_vel(a0)

return_316ABA:
		rts
; ---------------------------------------------------------------------------

loc_316ABC:
		tst.w	y_vel(a0)
		bmi.s	return_316ADE
		jsr	Player_CheckFloor
		tst.w	d1
		bpl.s	return_316ADE
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		move.w	#0,y_vel(a0)
		bclr	#1,(Gliding_collision_flags).w

return_316ADE:
		rts
; End of function Knuckles_DoLevelCollision2


; =============== S U B	R O U T	I N E =======================================


Knuckles_DoLevelCollision:
		move.l	#Primary_Collision,(Collision_addr).w
		cmp.b	#$C,top_solid_bit(a0)
		beq.s	loc_316AF8
		move.l	#Secondary_Collision,(Collision_addr).w

loc_316AF8:
		move.b	lrb_solid_bit(a0),d5
		move.w	x_vel(a0),d1
		move.w	y_vel(a0),d2
		jsr	CalcAngle
		sub.b	#$20,d0
		and.b	#$C0,d0
		cmp.b	#$40,d0
		beq.w	Knuckles_HitLeftWall
		cmp.b	#$80,d0
		beq.w	Knuckles_HitCeilingAndWalls
		cmp.b	#$C0,d0
		beq.w	Knuckles_HitRightWall
		jsr	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_316B3C
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_316B3C:
		jsr	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_316B4E
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_316B4E:
		jsr	Player_CheckFloor
		tst.w	d1
		bpl.s	return_316BC0
		move.b	y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	loc_316B66
		cmp.b	d2,d0
		blt.s	return_316BC0

loc_316B66:
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Knuckles_ResetOnFloor
		move.b	d3,d0
		add.b	#$20,d0
		and.b	#$40,d0
		bne.s	loc_316B9E
		move.b	d3,d0
		add.b	#$10,d0
		and.b	#$20,d0
		beq.s	loc_316B90
		asr	y_vel(a0)
		bra.s	loc_316BB2
; ---------------------------------------------------------------------------

loc_316B90:
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_316B9E:
		move.w	#0,x_vel(a0)
		cmp.w	#$FC0,y_vel(a0)
		ble.s	loc_316BB2
		move.w	#$FC0,y_vel(a0)

loc_316BB2:
		move.w	y_vel(a0),inertia(a0)
		tst.b	d3
		bpl.s	return_316BC0
		neg.w	inertia(a0)

return_316BC0:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitLeftWall:
		jsr	CheckLeftWallDist
		tst.w	d1
		bpl.s	Knuckles_HitCeiling
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),inertia(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_HitCeiling:
		jsr	Player_CheckCeiling
		tst.w	d1
		bpl.s	Knuckles_HitFloor_0
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	return_316BF4
		move.w	#0,y_vel(a0)

return_316BF4:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitFloor_0:
		tst.w	y_vel(a0)
		bmi.s	return_316C1C
		jsr	Player_CheckFloor
		tst.w	d1
		bpl.s	return_316C1C
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Knuckles_ResetOnFloor
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)

return_316C1C:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitCeilingAndWalls:
		jsr	CheckLeftWallDist
		tst.w	d1
		bpl.s	loc_316C30
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_316C30:
		jsr	CheckRightWallDist
		tst.w	d1
		bpl.s	loc_316C42
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_316C42:
		jsr	Player_CheckCeiling
		tst.w	d1
		bpl.s	return_316C78
		sub.w	d1,y_pos(a0)
		move.b	d3,d0
		add.b	#$20,d0
		and.b	#$40,d0
		bne.s	loc_316C62
		move.w	#0,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_316C62:
		move.b	d3,angle(a0)
		bsr.w	Knuckles_ResetOnFloor
		move.w	y_vel(a0),inertia(a0)
		tst.b	d3
		bpl.s	return_316C78
		neg.w	inertia(a0)

return_316C78:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitRightWall:
		jsr	CheckRightWallDist
		tst.w	d1
		bpl.s	Knuckles_HitCeiling2
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),inertia(a0)
		rts
; ---------------------------------------------------------------------------

Knuckles_HitCeiling2:
		jsr	Player_CheckCeiling
		tst.w	d1
		bpl.s	Knuckles_HitFloor2
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	return_316CAC
		move.w	#0,y_vel(a0)

return_316CAC:
		rts
; ---------------------------------------------------------------------------

Knuckles_HitFloor2:
		tst.w	y_vel(a0)
		bmi.s	return_316CD4
		jsr	Player_CheckFloor
		tst.w	d1
		bpl.s	return_316CD4
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Knuckles_ResetOnFloor
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),inertia(a0)

return_316CD4:
		rts
; End of function Knuckles_DoLevelCollision


; =============== S U B	R O U T	I N E =======================================


Knuckles_ResetOnFloor:
		tst.b	pinball_mode(a0)
		bne.s	Knuckles_ResetOnFloor_Part3
		move.b	#AniIDSonAni_Walk,anim(a0)
; End of function Knuckles_ResetOnFloor


; =============== S U B	R O U T	I N E =======================================


Knuckles_ResetOnFloor_Part2:
		btst	#2,status(a0)
		beq.s	Knuckles_ResetOnFloor_Part3
		bclr	#2,status(a0)
		move.b	y_radius(a0),d0
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.b	#AniIDSonAni_Walk,anim(a0)
		sub.b	#$13,d0
		ext.w	d0
		add.w	d0,y_pos(a0)

Knuckles_ResetOnFloor_Part3:
		bclr	#1,status(a0)
		bclr	#5,status(a0)
		bclr	#4,status(a0)
		move.b	#0,jumping(a0)
		move.w	#0,(Chain_Bonus_counter).w
		move.b	#0,flip_angle(a0)
		move.b	#0,flip_turned(a0)
		move.b	#0,flips_remaining(a0)
		move.w	#0,(Sonic_Look_delay_counter).w
		move.b	#0,double_jump_flag(a0)
		cmpi.b	#32,anim(a0)
		bcc.s	loc_316D5C
		cmpi.b	#AniIDSonAni_Hang2,anim(a0)
		bne.s	return_316D62

loc_316D5C:
		move.b	#AniIDSonAni_Walk,anim(a0)

return_316D62:
		rts
; End of function Knuckles_ResetOnFloor_Part2


; =============== S U B	R O U T	I N E =======================================


Obj_Knuckles_Hurt:

; FUNCTION CHUNK AT 00316E14 SIZE 0000001C BYTES

		tst.w	(Debug_mode_flag).w
		beq.s	Obj_Knuckles_Hurt_Normal
		btst	#4,(Ctrl_1_Press).w
		beq.s	Obj_Knuckles_Hurt_Normal
		move.w	#1,(Debug_placement_mode).w
		clr.b	(Control_Locked).w
		rts
; ---------------------------------------------------------------------------

Obj_Knuckles_Hurt_Normal:
		tst.b	routine_secondary(a0)
		bmi.w	Knuckles_HurtInstantRecover
		jsr	ObjectMove		  ; AKA	SpeedToPos in Sonic 1
		add.w	#$30,y_vel(a0)
		btst	#6,status(a0)
		beq.s	loc_316DA0
		sub.w	#$20,y_vel(a0)

loc_316DA0:
		cmp.w	#-$100,(Camera_Min_Y_pos).w
		bne.s	loc_316DAE
		and.w	#$7FF,y_pos(a0)

loc_316DAE:
		bsr.w	Knuckles_HurtStop
		jsr	Sonic_LevelBound
		jsr	Sonic_RecordPos
		bsr.w	Knuckles_Animate
		bsr.w	LoadKnucklesDynPLC
		jmp	DisplaySprite
; End of function Obj_Knuckles_Hurt


; =============== S U B	R O U T	I N E =======================================


Knuckles_HurtStop:
		move.w	(Camera_Max_Y_pos_now).w,d0
		add.w	#$E0,d0
		cmp.w	y_pos(a0),d0
		blt.w	JmpTo3_KillCharacter
		bsr.w	Knuckles_DoLevelCollision
		btst	#1,status(a0)
		bne.s	return_316E0C
		moveq	#0,d0
		move.w	d0,y_vel(a0)
		move.w	d0,x_vel(a0)
		move.w	d0,inertia(a0)
		move.b	d0,obj_control(a0)
		move.b	#AniIDSonAni_Walk,anim(a0)
		subq.b	#2,routine(a0)
		move.w	#$78,invulnerable_time(a0)
		move.b	#0,pinball_mode(a0)

return_316E0C:
		rts
; ---------------------------------------------------------------------------

JmpTo3_KillCharacter:
		jmp	KillCharacter
; End of function Knuckles_HurtStop

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR Obj_Knuckles_Hurt

Knuckles_HurtInstantRecover:
		subq.b	#2,routine(a0)
		move.b	#0,routine_secondary(a0)
		jsr	Sonic_RecordPos
		bsr.w	Knuckles_Animate
		bsr.w	LoadKnucklesDynPLC
		jmp	DisplaySprite
; END OF FUNCTION CHUNK	FOR Obj_Knuckles_Hurt

; =============== S U B	R O U T	I N E =======================================


Obj_Knuckles_Dead:
		tst.w	(Debug_mode_flag).w
		beq.s	loc_316E4A
		btst	#4,(Ctrl_1_Press).w
		beq.s	loc_316E4A
		move.w	#1,(Debug_placement_mode).w
		clr.b	(Control_Locked).w
		rts
; ---------------------------------------------------------------------------

loc_316E4A:
		jsr	CheckGameOver
		jsr	ObjectMoveAndFall
		jsr	Sonic_RecordPos
		bsr.w	Knuckles_Animate
		bsr.w	LoadKnucklesDynPLC
		jmp	DisplaySprite
; End of function Obj_Knuckles_Dead

; =============== S U B	R O U T	I N E =======================================


Obj_Knuckles_Gone:
		tst.w	restart_countdown(a0)
		beq.s	return_316F78
		subq.w	#1,restart_countdown(a0)
		bne.s	return_316F78
		move.w	#1,(Level_Inactive_flag).w

return_316F78:
		rts
; End of function Obj_Knuckles_Gone

; ---------------------------------------------------------------------------

Obj_Knuckles_Respawning:
		tst.w	(Camera_X_pos_diff).w
		bne.s	loc_316F8C
		tst.w	(Camera_Y_pos_diff).w
		bne.s	loc_316F8C
		move.b	#2,routine(a0)

loc_316F8C:
		bsr.w	Knuckles_Animate
		bsr.w	LoadKnucklesDynPLC
		jmp	DisplaySprite

; =============== S U B	R O U T	I N E =======================================


Knuckles_Animate:
		lea	(KnucklesAniData).l,a1
		moveq	#0,d0
		move.b	anim(a0),d0
		cmp.b	next_anim(a0),d0
		beq.s	KAnim_Do
		move.b	d0,next_anim(a0)
		move.b	#0,anim_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		bclr	#5,status(a0)

KAnim_Do:
		add.w	d0,d0
		add.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	KAnim_WalkRun
		move.b	status(a0),d1
		and.b	#1,d1
		and.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	KAnim_Delay
		move.b	d0,anim_frame_duration(a0)

KAnim_Do2:
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#$F0,d0
		bhs.s	KAnim_End_FF

KAnim_Next:
		move.b	d0,mapping_frame(a0)
		addq.b	#1,anim_frame(a0)

KAnim_Delay:
		rts
; ---------------------------------------------------------------------------

KAnim_End_FF:
		addq.b	#1,d0
		bne.s	KAnim_End_FE
		move.b	#0,anim_frame(a0)
		move.b	1(a1),d0
		bra.s	KAnim_Next
; ---------------------------------------------------------------------------

KAnim_End_FE:
		addq.b	#1,d0
		bne.s	KAnim_End_FD
		move.b	2(a1,d1.w),d0
		sub.b	d0,anim_frame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	KAnim_Next
; ---------------------------------------------------------------------------

KAnim_End_FD:
		addq.b	#1,d0
		bne.s	KAnim_End
		move.b	2(a1,d1.w),anim(a0)

KAnim_End:
		rts
; ---------------------------------------------------------------------------

KAnim_WalkRun:
		addq.b	#1,d0
		bne.w	KAnim_Roll
		moveq	#0,d0
		move.b	flip_angle(a0),d0
		bne.w	KAnim_Tumble
		moveq	#0,d1
		move.b	angle(a0),d0
		bmi.s	loc_31704E
		beq.s	loc_31704E
		subq.b	#1,d0

loc_31704E:
		move.b	status(a0),d2
		and.b	#1,d2
		bne.s	loc_31705A
		not.b	d0

loc_31705A:
		add.b	#$10,d0
		bpl.s	loc_317062
		moveq	#3,d1

loc_317062:
		and.b	#$FC,render_flags(a0)
		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		btst	#5,status(a0)
		bne.w	KAnim_Push
		lsr.b	#4,d0
		and.b	#6,d0
		move.w	inertia(a0),d2
		bpl.s	loc_317086
		neg.w	d2

loc_317086:
		tst.b	status_secondary(a0)
		bpl.w	loc_317090
		add.w	d2,d2

loc_317090:
		lea	(KnucklesAni_Run).l,a1
		cmp.w	#$600,d2
		bcc.s	loc_3170A4
		lea	(KnucklesAni_Walk).l,a1
		add.b	d0,d0

loc_3170A4:
		add.b	d0,d0
		move.b	d0,d3
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmp.b	#-1,d0
		bne.s	loc_3170C2
		move.b	#0,anim_frame(a0)
		move.b	1(a1),d0

loc_3170C2:
		move.b	d0,mapping_frame(a0)
		add.b	d3,mapping_frame(a0)
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	return_3170E4
		neg.w	d2
		add.w	#$800,d2
		bpl.s	loc_3170DA
		moveq	#0,d2

loc_3170DA:
		lsr.w	#8,d2
		move.b	d2,anim_frame_duration(a0)
		addq.b	#1,anim_frame(a0)

return_3170E4:
		rts
; ---------------------------------------------------------------------------

KAnim_Tumble:
		move.b	flip_angle(a0),d0
		moveq	#0,d1
		move.b	status(a0),d2
		and.b	#1,d2
		bne.s	KAnim_Tumble_Left

		and.b	#$FC,render_flags(a0)
		add.b	#$B,d0
		divu.w	#$16,d0
		add.b	#frK_Tumble1,d0
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ---------------------------------------------------------------------------

KAnim_Tumble_Left:
		and.b	#$FC,render_flags(a0)
		tst.b	flip_turned(a0)
		beq.s	loc_31712C
		or.b	#1,render_flags(a0)
		add.b	#$B,d0
		bra.s	loc_317138
; ---------------------------------------------------------------------------

loc_31712C:
		or.b	#3,render_flags(a0)
		neg.b	d0
		add.b	#-$71,d0

loc_317138:
		divu.w	#$16,d0
		add.b	#frK_Tumble1,d0
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ---------------------------------------------------------------------------

KAnim_Roll:
		subq.b	#1,anim_frame_duration(a0)
		bpl.w	KAnim_Delay
		addq.b	#1,d0
		bne.s	KAnim_Push
		move.w	inertia(a0),d2
		bpl.s	loc_317160
		neg.w	d2

loc_317160:
		lea	(KnucklesAni_Roll2).l,a1
		cmp.w	#$600,d2
		bcc.s	loc_317172
		lea	(KnucklesAni_Roll).l,a1

loc_317172:
		neg.w	d2
		add.w	#$400,d2
		bpl.s	loc_31717C
		moveq	#0,d2

loc_31717C:
		lsr.w	#8,d2
		move.b	d2,anim_frame_duration(a0)
		move.b	status(a0),d1
		and.b	#1,d1
		and.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	KAnim_Do2
; ---------------------------------------------------------------------------

KAnim_Push:
		subq.b	#1,anim_frame_duration(a0)
		bpl.w	KAnim_Delay
		move.w	inertia(a0),d2
		bmi.s	loc_3171A8
		neg.w	d2

loc_3171A8:
		add.w	#$800,d2
		bpl.s	loc_3171B0
		moveq	#0,d2

loc_3171B0:
		lsr.w	#8,d2
		move.b	d2,anim_frame_duration(a0)
		lea	(KnucklesAni_Push).l,a1
		move.b	status(a0),d1
		and.b	#1,d1
		and.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	KAnim_Do2
; End of function Knuckles_Animate

	include "animations/Knuckles.asm"

; =============== S U B	R O U T	I N E =======================================


LoadKnucklesDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0	; load frame number
		bsr.w	LoadKnucklesMap

LoadKnucklesDynPLC_Part2:
		cmp.b	(Sonic_LastLoadedDPLC).w,d0
		beq.s	.nochange
		move.b	d0,(Sonic_LastLoadedDPLC).w
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.superplc
		lea	(MapRUnc_Knuckles).l,a2
;		bra.s	.cont
;	.superplc:
;		lea	(MapRUnc_SuperKnuckles).l,a2
	.cont:
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	.nochange
		move.w	#tiles_to_bytes(ArtTile_ArtUnc_Sonic),d4	; Temporary
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.superart
		move.l	#ArtUnc_Knuckles,d6
;		bra.s	.readentry
;	.superart:
;		move.l	#ArtUnc_SuperKnuckles,d6

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
; End of function Knuckles_LoadGfx

LoadKnucklesMap:
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.super
	.normal:
		cmpi.l	#MapUnc_Knuckles,mappings(a0)
		beq.s	.skip
		move.l	#MapUnc_Knuckles,mappings(a0)
;		bra.s	.skip
;	.super:
;		cmpi.l	#MapUnc_SuperKnuckles,mappings(a0)
;		beq.s	.skip
;		move.l	#MapUnc_SuperKnuckles,mappings(a0)
	.skip:
		rts

; =============== S U B	R O U T	I N E =======================================

; Doesn't exist in S2

sub_3192E6:					  ; ...
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eor.w	#$F,d2
		lea	(Primary_Angle).w,a4
		move.w	#-$10,a3
		move.w	#$800,d6
		jsr	FindFloor
		move.b	#$80,d2

loc_319306:
		jmp	loc_1ECFE
; End of function sub_3192E6

; =============== S U B	R O U T	I N E =======================================


sub_318FF6:					  ; ...
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(Primary_Angle).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		jsr	FindFloor
		move.b	#0,d2
		jmp	loc_1ECFE
; End of function sub_318FF6

; ---------------------------------------------------------------------------
; This doesn't exist in S2...
; START	OF FUNCTION CHUNK FOR sub_315C22

loc_319208:					  ; ...
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(Primary_Angle).w,a4
		move.w	#$10,a3
		move.w	#0,d6
		jsr	FindWall
		move.b	#$C0,d2
		jmp	loc_1ECFE
; END OF FUNCTION CHUNK	FOR sub_315C22

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_315C22

loc_3193D2:					  ; ...
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eor.w	#$F,d3
		lea	(Primary_Angle).w,a4
		move.w	#$FFF0,a3
		move.w	#$400,d6
		jsr	FindWall
		move.b	#$40,d2
		jmp	loc_1ECFE
; END OF FUNCTION CHUNK	FOR sub_315C22