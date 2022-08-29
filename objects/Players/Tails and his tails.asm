Obj_Tails:
	; a0=character
	cmpa.w	#MainCharacter,a0
	bne.s	+
	move.w	(Camera_Min_X_pos).w,(Tails_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_Max_Y_pos_now).w,(Tails_Max_Y_pos).w
	tst.w	(Debug_placement_mode).w	; is debug mode being used?
	beq.s	+			; if not, branch
	jmp		(DebugMode).l
; ---------------------------------------------------------------------------
+
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj_Tails_Index(pc,d0.w),d1
	jmp	Obj_Tails_Index(pc,d1.w)
; ===========================================================================
; off_1B8CC: Obj_Tails_States:
Obj_Tails_Index:	offsetTable
		offsetTableEntry.w Obj_Tails_Init		;  0
		offsetTableEntry.w Obj_Tails_Control	;  2
		offsetTableEntry.w Obj_Tails_Hurt		;  4
		offsetTableEntry.w Obj_Tails_Dead		;  6
		offsetTableEntry.w Obj_Tails_Gone		;  8
		offsetTableEntry.w Obj_Tails_Respawning	; $A
; ===========================================================================
; loc_1B8D8: Obj_Tails_Main:
Obj_Tails_Init:
	addq.b	#2,routine(a0)	; => Obj_Tails_Normal
	jsr		ResetHeight_a0
	move.l	#MapUnc_Tails,mappings(a0)
	move.w	#prio(2),priority(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#$84,render_flags(a0) ; render_flags(Tails) = $80 | initial render_flags(Sonic)
	move.w	#$600,(Tails_top_speed).w	; set Tails' top speed
	move.w	#$C,(Tails_acceleration).w	; set Tails' acceleration
	move.w	#$80,(Tails_deceleration).w	; set Tails' deceleration
	jsr		ResetArtTile_a0
	cmpa.w	#MainCharacter,a0
	bne.s	Obj_Tails_Init_2Pmode
	tst.b	(Last_star_pole_hit).w
	bne.s	Obj_Tails_Init_Continued
	; only happens when not starting at a checkpoint:
	move.b	#$C,top_solid_bit(a0)
	move.b	#$D,lrb_solid_bit(a0)
	move.w	x_pos(a0),(Saved_x_pos).w
	move.w	y_pos(a0),(Saved_y_pos).w
	move.w	art_tile(a0),(Saved_art_tile).w
	move.w	top_solid_bit(a0),(Saved_Solid_bits).w
	bra.s	Obj_Tails_Init_Continued
; ===========================================================================
; loc_1B952:
Obj_Tails_Init_2Pmode:
	move.w	(MainCharacter+top_solid_bit).w,top_solid_bit(a0)
	tst.w	(MainCharacter+art_tile).w
	bpl.s	Obj_Tails_Init_Continued
	ori.w	#high_priority,art_tile(a0)
; loc_1B96E:
Obj_Tails_Init_Continued:
	move.w	x_pos(a0),(Saved_x_pos_2P).w
	move.w	y_pos(a0),(Saved_y_pos_2P).w
	move.w	art_tile(a0),(Saved_art_tile_2P).w
	move.w	top_solid_bit(a0),(Saved_Solid_bits_2P).w
	move.b	#0,flips_remaining(a0)
	move.b	#4,flip_speed(a0)
	move.b	#0,(Super_Sonic_flag).w
	move.b	#0,(Super_Tails_flag).w
	move.b	#$1E,air_left(a0)
	cmpi.w	#$20,(Tails_CPU_routine).w
	beq.s	loc_137A4
	cmpi.w	#$12,(Tails_CPU_routine).w
	beq.s	loc_137A4
	move.w	#0,(Tails_CPU_routine).w	; set AI state to TailsCPU_Init
loc_137A4:
	move.w	#0,(Tails_control_counter).w
	move.w	#0,(Tails_respawn_counter).w
	cmpa.w	#MainCharacter,a0
	bne.s	.notP1
	lea		(P1_FollowObject).w,a1
	bra.s	.cont
.notP1:
	lea		(P2_FollowObject).w,a1
.cont:
	move.l	#Obj_TailsTails,id(a1) ; load Obj_TailsTails (Tails' Tails) at the specified offset
	move.w	a0,parent(a1) ; set its parent object to this

; ---------------------------------------------------------------------------
; Normal state for Tails
; ---------------------------------------------------------------------------
; loc_1B9B4:
Obj_Tails_Control:
	cmpa.w	#MainCharacter,a0
	bne.s	Obj_Tails_Control_Joypad2
	move.w	(Ctrl_1_Logical).w,(Ctrl_2_Logical).w
	tst.w	(Debug_mode_flag).w	; is debug cheat enabled?
	beq.s	+			; if not, branch
	btst	#button_B,(Ctrl_1_Press).w	; is button B pressed?
	beq.s	+			; if not, branch
	move.w	#1,(Debug_placement_mode).w	; change Sonic into a ring/item
	clr.b	(Control_Locked).w		; unlock control
	rts
; -----------------------------------------------------------------------
+	tst.b	(Control_Locked).w	; are controls locked?
	bne.s	Obj_Tails_Control_Part2	; if yes, branch
	move.w	(Ctrl_1).w,(Ctrl_2_Logical).w	; copy new held buttons, to enable joypad control
	move.w	(Ctrl_1).w,(Ctrl_1_Logical).w
	bra.s	Obj_Tails_Control_Part2
; ---------------------------------------------------------------------------
; loc_1B9D4:
Obj_Tails_Control_Joypad2:
	tst.b	(Control_Locked_P2).w
	bne.s	+
	move.w	(Ctrl_2).w,(Ctrl_2_Logical).w
+
	bsr.w	TailsCPU_Control
; loc_1B9EA:
Obj_Tails_Control_Part2:
	btst	#0,obj_control(a0)	; is Tails flying, or interacting with another object that holds him in place or controls his movement somehow?
	beq.s	loc_13872			; if yes, branch to skip Tails' control
	move.b	#0,double_jump_flag(a0)
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	+
	lea	(MainCharacter).w,a1
	clr.b	obj_control(a1)
	bset	#1,status(a1)
	clr.w	(Flying_carrying_Sonic_flag).w
	bra.s	+
; ---------------------------------------------------------------------------

loc_13872:
	moveq	#0,d0
	move.b	status(a0),d0
	andi.w	#6,d0	; %0000 %0110
	move.w	Obj_Tails_Modes(pc,d0.w),d1
	jsr	Obj_Tails_Modes(pc,d1.w)	; run Tails' movement control code
+
	cmpi.w	#-$100,(Camera_Min_Y_pos).w	; is vertical wrapping enabled?
	bne.s	+                               ; if not, branch
	andi.w	#$7FF,y_pos(a0)                 ; perform wrapping of Sonic's y position
+
	jsr		Player_Display
	bsr.w	Tails_Super
	jsr		P1_RecordPos
	bsr.w	Sonic_Water
	move.b	(Primary_Angle).w,next_tilt(a0)
	move.b	(Secondary_Angle).w,tilt(a0)
	tst.b	(WindTunnel_flag).w
	beq.s	+
	tst.b	anim(a0)
	bne.s	+
	move.b	next_anim(a0),anim(a0)
+
	bsr.w	Tails_Animate
	tst.b	obj_control(a0)
	bmi.s	+
	jsr	(TouchResponse).l
+
	bra.w	LoadTailsDynPLC

; ===========================================================================
; secondary states under state Obj_Tails_Normal
; off_1BA4E:
Obj_Tails_Modes:	offsetTable
		offsetTableEntry.w Obj_Tails_MdNormal	; 0 - not airborne or rolling
		offsetTableEntry.w Obj_Tails_MdAir		; 2 - airborne
		offsetTableEntry.w Obj_Tails_MdRoll		; 4 - rolling
		offsetTableEntry.w Obj_Tails_MdJump		; 6 - jumping
; ===========================================================================

; ---------------------------------------------------------------------------
; Tails' AI code for the Sonic and Tails mode 1-player game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1BAD4:
TailsCPU_Control: ; a0=Tails
	move.b	(Ctrl_2_Held).w,d0	; did the real player 2 hit something?
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,d0
	beq.s	+			; if not, branch
	move.w	#600,(Tails_control_counter).w ; give player 2 control for 10 seconds (minimum)
+
	lea	(MainCharacter).w,a1 ; a1=character ; a1=Sonic
	move.w	(Tails_CPU_routine).w,d0
	move.w	TailsCPU_States(pc,d0.w),d0
	jmp	TailsCPU_States(pc,d0.w)
; ===========================================================================
; off_1BAF4:
TailsCPU_States: offsetTable
	offsetTableEntry.w TailsCPU_Init	; 0
	offsetTableEntry.w TailsCPU_Spawning	; 2
	offsetTableEntry.w TailsCPU_Flying	; 4
	offsetTableEntry.w TailsCPU_Normal	; 6
	offsetTableEntry.w TailsCPU_Panic	; 8
	offsetTableEntry.w return_1BF36	; $A
	offsetTableEntry.w loc_13FC2	; $C
	offsetTableEntry.w loc_13FFA	; $E
	offsetTableEntry.w loc_1408A	; $10
	offsetTableEntry.w loc_140C6	; $12
	offsetTableEntry.w loc_140CET	; $14
	offsetTableEntry.w loc_14106	; $16
	offsetTableEntry.w loc_1414C	; $18
	offsetTableEntry.w loc_141F2	; $1A
	offsetTableEntry.w loc_1421C	; $1C
	offsetTableEntry.w loc_14254	; $1E
	offsetTableEntry.w loc_1425C	; $20
	offsetTableEntry.w loc_14286	; $22

; ===========================================================================
; initial AI State
; ---------------------------------------------------------------------------
; loc_1BAFE:
TailsCPU_Init:
	move.w	#6,(Tails_CPU_routine).w	; => TailsCPU_Normal
	move.b	#0,obj_control(a0)
	move.b	#AniIDTailsAni_Walk,anim(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#0,status(a0)
	move.w	#0,(Tails_respawn_counter).w
	rts

; ===========================================================================
; AI State where Tails is waiting to respawn
; ---------------------------------------------------------------------------
; loc_1BB30:
TailsCPU_Spawning:
	move.b	(Ctrl_2_Logical).w,d0
	andi.b	#button_B_mask|button_C_mask|button_A_mask|button_start_mask,d0
	bne.s	TailsCPU_Respawn
	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	bne.w	return_1BB88
	tst.b	obj_control(a1)
	bmi.w	return_1BB88
	move.b	status(a1),d0
	andi.b	#$80,d0
	bne.w	return_1BB88

TailsCPU_Respawn:
	move.w	#4,(Tails_CPU_routine).w	; => TailsCPU_Flying
	move.w	x_pos(a1),d0
	move.w	d0,x_pos(a0)
	move.w	d0,(Tails_CPU_target_x).w
	move.w	y_pos(a1),d0
	move.w	d0,(Tails_CPU_target_y).w
	subi.w	#$C0,d0

loc_13B78:
	move.w	d0,y_pos(a0)
	ori.w	#high_priority,art_tile(a0)
	move.w	#prio(2),priority(a0)
	moveq	#0,d0
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	d0,inertia(a0)
	move.b	d0,flip_turned(a0)
	move.b	d0,double_jump_flag(a0)
	move.b	#2,status(a0)
	move.b	#$1E,air_left(a0)	
	move.b	#$81,obj_control(a0)
	move.b	d0,flips_remaining(a0)
	move.b	d0,flip_speed(a0)
	move.w	d0,move_lock(a0)
	move.b	d0,invulnerable_time(a0)
	move.b	d0,invincibility_time(a0)
	move.b	d0,speedshoes_time(a0)
	move.b	d0,(Tails_Look_delay_counter).w
	move.w	d0,next_tilt(a0)
	move.b	d0,stick_to_convex(a0)
	move.b	d0,spindash_flag(a0)
	move.b	d0,pinball_mode(a0)
	move.w	d0,spindash_counter(a0)
	move.b	d0,jumping(a0)
	move.b	d0,jumping+1(a0)
	move.b	#-$10,double_jump_property(a0)
	bsr.w	Tails_Set_Flying_Animation
	rts

return_1BB88:
	rts
; ===========================================================================
; AI State where Tails pretends to be a helicopter
; ---------------------------------------------------------------------------
; loc_1BB8A:
TailsCPU_Flying:
	tst.b	render_flags(a0)
	bmi.s	TailsCPU_FlyingOnscreen
	addq.w	#1,(Tails_respawn_counter).w
	cmpi.w	#300,(Tails_respawn_counter).w
	blo.s	TailsCPU_Flying_Part2
	move.w	#0,(Tails_respawn_counter).w
	move.w	#2,(Tails_CPU_routine).w
	move.b	#$81,obj_control(a0)
	move.b	#2,status(a0)
	move.w	#0,x_pos(a0)
	move.w	#0,y_pos(a0)
	move.b	#-$10,double_jump_property(a0)
	bsr.w	Tails_Set_Flying_Animation
	rts
; ---------------------------------------------------------------------------

TailsCPU_FlyingOnscreen:
	move.b	#-$10,double_jump_property(a0)
	ori.b	#2,status(a0)
	bsr.w	Tails_Set_Flying_Animation
	move.w	#0,(Tails_respawn_counter).w

; loc_1BBCE:
TailsCPU_Flying_Part2:
	lea	(Sonic_Pos_Record_Buf).w,a2
	move.w	#$10,d2
	lsl.b	#2,d2
	addq.b	#4,d2
	move.w	(Sonic_Pos_Record_Index).w,d3
	sub.b	d2,d3
	move.w	(a2,d3.w),(Tails_CPU_target_x).w
	move.w	2(a2,d3.w),(Tails_CPU_target_y).w
	move.w	x_pos(a0),d0
	sub.w	(Tails_CPU_target_x).w,d0
	beq.s	loc_13CBE
	move.w	d0,d2
	bpl.s	loc_13C7E
	neg.w	d2

loc_13C7E:
	lsr.w	#4,d2
	cmpi.w	#$C,d2
	blo.s	loc_13C88
	moveq	#$C,d2

loc_13C88:
	move.b	x_vel(a1),d1
	bpl.s	loc_13C90
	neg.b	d1

loc_13C90:
	add.b	d1,d2
	addq.w	#1,d2
	tst.w	d0
	bmi.s	loc_13CAA
	bset	#0,status(a0)
	cmp.w	d0,d2
	blo.s	loc_13CA6
	move.w	d0,d2
	moveq	#0,d0

loc_13CA6:
	neg.w	d2
	bra.s	loc_13CBA
; ---------------------------------------------------------------------------

loc_13CAA:
	bclr	#0,status(a0)
	neg.w	d0
	cmp.w	d0,d2
	blo.s	loc_13CBA
	move.b	d0,d2
	moveq	#0,d0

loc_13CBA:
	add.w	d2,x_pos(a0)

loc_13CBE:
	moveq	#1,d2
	move.w	y_pos(a0),d1
	sub.w	(Tails_CPU_target_y).w,d1
	beq.s	loc_13CD2
	bmi.s	loc_13CCE
	neg.w	d2

loc_13CCE:
	add.w	d2,y_pos(a0)

loc_13CD2:
	lea	(Sonic_Stat_Record_Buf).w,a2
	move.b	2(a2,d3.w),d2
	andi.b	#$80,d2
	bne.s	loc_13D42
	or.w	d0,d1
	bne.s	loc_13D42
	cmpi.b	#6,(MainCharacter+routine).w
	bhs.s	loc_13D42
	move.w	#6,(Tails_CPU_routine).w	; => TailsCPU_Normal
	move.b	#0,obj_control(a0)
	move.b	#AniIDTailsAni_Roll,anim(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	andi.b	#$40,status(a0)
	ori.b	#2,status(a0)
	move.w	#0,move_lock(a0)
	andi.w	#drawing_mask,art_tile(a0)
	tst.b	art_tile(a1)
	bpl.s	loc_13D34
	ori.w	#high_priority,art_tile(a0)
loc_13D34:
	move.b	top_solid_bit(a1),top_solid_bit(a0)
	move.b	lrb_solid_bit(a1),lrb_solid_bit(a0)
	rts
; ---------------------------------------------------------------------------

loc_13D42:
	move.b	#$81,obj_control(a0)
	rts

; ===========================================================================
; AI State where Tails follows the player normally
; ---------------------------------------------------------------------------
; loc_1BCE0:
TailsCPU_Normal:
	cmpi.b	#6,(MainCharacter+routine).w	; is Sonic dead?
	blo.s	TailsCPU_Normal_SonicOK		; if not, branch
	; Sonic's dead; fly down to his corpse
	move.w	#4,(Tails_CPU_routine).w	; => TailsCPU_Flying
	move.b	#0,spindash_flag(a0)
	move.w	#0,spindash_counter(a0)
	move.b	#$81,obj_control(a0)
	move.b	#2,status(a0)
	move.b	#AniIDTailsAni_Fly,anim(a0)
	rts
; ---------------------------------------------------------------------------
; loc_1BD0E:
TailsCPU_Normal_SonicOK:
	bsr.w	TailsCPU_CheckDespawn
	tst.w	(Tails_control_counter).w	; if CPU has control
	bne.w	TailsCPU_Normal_HumanControl		; (if not, branch)
	tst.b	obj_control(a0)			; and Tails isn't fully object controlled (&$80)
	bmi.w	TailsCPU_Normal_HumanControl		; (if not, branch)
	tst.w	move_lock(a0)			; and Tails' movement is locked (usually because he just fell down a slope)
	beq.s	+					; (if not, branch)
	tst.w	inertia(a0)			; and Tails is stopped, then...
	bne.s	+					; (if not, branch)
	move.w	#8,(Tails_CPU_routine).w	; => TailsCPU_Panic
+
	lea	(Sonic_Pos_Record_Buf).w,a1
	move.w	#$10,d1
	lsl.b	#2,d1
	addq.b	#4,d1
	move.w	(Sonic_Pos_Record_Index).w,d0
	sub.b	d1,d0
	move.w	(a1,d0.w),d2	; d2 = earlier x position of Sonic
	btst	#3,status(a1)
	bne.s	loc_13DD0
	cmpi.w	#$400,inertia(a1)
	bge.s	loc_13DD0
	subi.w	#$20,d2

loc_13DD0:
	move.w	2(a1,d0.w),d3	; d3 = earlier y position of Sonic
	lea	(Sonic_Stat_Record_Buf).w,a1
	move.w	(a1,d0.w),d1	; d1 = earlier input of Sonic
	move.b	2(a1,d0.w),d4	; d4 = earlier status of Sonic
	move.w	d1,d0
	btst	#5,status(a0)	; is Tails pushing against something?
	beq.s	+		; if not, branch
	btst	#5,d4		; was Sonic pushing against something?
	beq.w	TailsCPU_Normal_FilterAction_Part2 ; if not, branch elsewhere

; either Tails isn't pushing, or Tails and Sonic are both pushing
+	sub.w	x_pos(a0),d2
	beq.s	TailsCPU_Normal_Stand ; branch if Tails is already lined up horizontally with Sonic
	bpl.s	TailsCPU_Normal_FollowRight
	neg.w	d2

; Tails wants to go left because that's where Sonic is
; loc_1BD76: TailsCPU_Normal_FollowLeft:
	cmpi.w	#$30,d2
	blo.s	+
	andi.w	#~(((button_left_mask|button_right_mask)<<8)|(button_left_mask|button_right_mask)),d1	; AND out Sonic's left/right input...
	ori.w	#(button_left_mask<<8)|button_left_mask,d1	; ...and give Tails his own
+
	tst.w	inertia(a0)
	beq.s	TailsCPU_Normal_FilterAction
	btst	#0,status(a0)
	beq.s	TailsCPU_Normal_FilterAction
	btst	#0,obj_control(a0)
	bne.s	TailsCPU_Normal_FilterAction
	subq.w	#1,x_pos(a0)
	bra.s	TailsCPU_Normal_FilterAction
; ===========================================================================
; Tails wants to go right because that's where Sonic is
; loc_1BD98:
TailsCPU_Normal_FollowRight:
	cmpi.w	#$30,d2
	blo.s	+
	andi.w	#~(((button_left_mask|button_right_mask)<<8)|(button_left_mask|button_right_mask)),d1	; AND out Sonic's left/right input
	ori.w	#(button_right_mask<<8)|button_right_mask,d1	; ...and give Tails his own
+
	tst.w	inertia(a0)
	beq.s	TailsCPU_Normal_FilterAction
	btst	#0,status(a0)
	bne.s	TailsCPU_Normal_FilterAction
	btst	#0,obj_control(a0)
	bne.s	TailsCPU_Normal_FilterAction
	addq.w	#1,x_pos(a0)
	bra.s	TailsCPU_Normal_FilterAction
; ===========================================================================
; Tails is happy where he is
; loc_1BDBA:
TailsCPU_Normal_Stand:
	bclr	#0,status(a0)
	move.b	d4,d0
	andi.b	#1,d0
	beq.s	TailsCPU_Normal_FilterAction
	bset	#0,status(a0)

; Filter the action we chose depending on a few things
; loc_1BDCE:
TailsCPU_Normal_FilterAction:
	tst.b	(Tails_CPU_jumping).w
	beq.s	+
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8),d1
	btst	#1,status(a0)
	bne.s	TailsCPU_Normal_SendAction
	move.b	#0,(Tails_CPU_jumping).w
+
	move.w	(Timer_frames).w,d0
	andi.w	#$FF,d0
	beq.s	+
	cmpi.w	#$40,d2
	bhs.s	TailsCPU_Normal_SendAction
+
	sub.w	y_pos(a0),d3
	beq.s	TailsCPU_Normal_SendAction
	bpl.s	TailsCPU_Normal_SendAction
	neg.w	d3
	cmpi.w	#$20,d3
	blo.s	TailsCPU_Normal_SendAction
; loc_1BE06:
TailsCPU_Normal_FilterAction_Part2:
	move.b	(Timer_frames+1).w,d0
	andi.b	#$3F,d0
	bne.s	TailsCPU_Normal_SendAction
	cmpi.b	#AniIDTailsAni_Duck,anim(a0)
	beq.s	TailsCPU_Normal_SendAction
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),d1
	move.b	#1,(Tails_CPU_jumping).w

; Send the action we chose by storing it into player 2's input
; loc_1BE22:
TailsCPU_Normal_SendAction:
	move.w	d1,(Ctrl_2_Logical).w
	rts

; ===========================================================================
; Follow orders from controller 2
; and decrease the counter to when the CPU will regain control
; loc_1BE28:
TailsCPU_Normal_HumanControl:
	tst.w	(Tails_control_counter).w
	beq.s	+	; don't decrease if it's already 0
	subq.w	#1,(Tails_control_counter).w
+
	rts

; ===========================================================================
; loc_1BE34:
TailsCPU_Despawn:
	move.w	#0,(Tails_control_counter).w
	move.w	#0,(Tails_respawn_counter).w
	move.w	#2,(Tails_CPU_routine).w	; => TailsCPU_Spawning
	move.b	#$81,obj_control(a0)
	move.b	#2,status(a0)
	move.w	#$4000,x_pos(a0)
	move.w	#0,y_pos(a0)
	move.b	#0,double_jump_flag(a0)
	rts
; ===========================================================================
; sub_1BE66:
TailsCPU_CheckDespawn:
	tst.b	render_flags(a0)
	bmi.s	TailsCPU_ResetRespawnTimer
	btst	#3,status(a0)
	beq.s	TailsCPU_TickRespawnTimer

	moveq	#0,d0
	move.b	interact(a0),d0
    if object_size=$40
	lsl.w	#6,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a3	; a3=object
	move.b	(Tails_interact_ID).w,d0
	cmp.b	(a3),d0
	bne.s	BranchTo_TailsCPU_Despawn

; loc_1BE8C:
TailsCPU_TickRespawnTimer:
	addq.w	#1,(Tails_respawn_counter).w
	cmpi.w	#$300,(Tails_respawn_counter).w
	blo.s	TailsCPU_UpdateObjInteract

BranchTo_TailsCPU_Despawn
	bra.w	TailsCPU_Despawn
; ===========================================================================
; loc_1BE9C:
TailsCPU_ResetRespawnTimer:
	move.w	#0,(Tails_respawn_counter).w
; loc_1BEA2:
TailsCPU_UpdateObjInteract:
	btst	#3,status(a0)
	beq.s	locret_13F3E
;	moveq	#0,d0
	move.b	interact(a0),d0
    if object_size=$40
	lsl.w	#6,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a3	; a3=object
	move.b	(a3),(Tails_interact_ID).w
locret_13F3E:
	rts

; ===========================================================================
; AI State where Tails stops, drops, and spindashes in Sonic's direction
; ---------------------------------------------------------------------------
; loc_1BEB8:
TailsCPU_Panic:
	bsr.w	TailsCPU_CheckDespawn
	tst.w	(Tails_control_counter).w
	bne.w	return_1BF36
	tst.w	move_lock(a0)
	bne.s	return_1BF36
	tst.b	spindash_flag(a0)
	bne.s	TailsCPU_Panic_ChargingDash
	tst.w	inertia(a0)
	bne.s	return_1BF36
	
	bclr	#0,status(a0)
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcs.s	+
	bset	#0,status(a0)
+
	move.w	#(button_down_mask<<8)|button_down_mask,(Ctrl_2_Logical).w
	move.b	(Timer_frames+1).w,d0
	andi.b	#$7F,d0
	beq.s	TailsCPU_Panic_ReleaseDash

	cmpi.b	#AniIDTailsAni_Duck,anim(a0)
	bne.s	return_1BF36
	move.w	#((button_down_mask|button_B_mask|button_C_mask|button_A_mask)<<8)|(button_down_mask|button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w
	rts
; ---------------------------------------------------------------------------
; loc_1BF0C:
TailsCPU_Panic_ChargingDash:
	move.w	#(button_down_mask<<8)|button_down_mask,(Ctrl_2_Logical).w
	move.b	(Timer_frames+1).w,d0
	andi.b	#$7F,d0
	bne.s	TailsCPU_Panic_RevDash

; loc_1BF1C:
TailsCPU_Panic_ReleaseDash:
	move.w	#0,(Ctrl_2_Logical).w
	move.w	#6,(Tails_CPU_routine).w	; => TailsCPU_Normal
	rts
; ---------------------------------------------------------------------------
; loc_1BF2A:
TailsCPU_Panic_RevDash:
	andi.b	#$1F,d0
	bne.s	return_1BF36
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w

return_1BF36:
	rts
; End of function TailsCPU_Control


loc_13FC2:
	move.b	#1,double_jump_flag(a0)
	move.b	#-$10,double_jump_property(a0)
	move.b	#2,status(a0)
	move.w	#$100,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	lea	(MainCharacter).w,a1
	bsr.w	sub_1459E
	move.b	#1,(Flying_carrying_Sonic_flag).w
	move.w	#$E,(Tails_CPU_routine).w

loc_13FFA:
	move.w	#0,(Tails_control_counter).w
	move.w	#0,(Ctrl_2_Logical).w
	move.b	(Timer_frames+1).w,d0
	andi.b	#$1F,d0
	bne.s	loc_14016
	ori.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_2_Logical).w

loc_14016:
	lea	(Flying_carrying_Sonic_flag).w,a2
	lea	(MainCharacter).w,a1
	btst	#1,status(a1)
	bne.s	loc_14082
	move.w	#6,(Tails_CPU_routine).w
	move.b	#0,obj_control(a0)
	move.b	#0,anim(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#2,status(a0)
	move.w	#0,move_lock(a0)
	andi.w	#drawing_mask,art_tile(a0)
	tst.b	art_tile(a1)
	bpl.s	loc_14068
	ori.w	#high_priority,art_tile(a0)

loc_14068:
	move.b	top_solid_bit(a1),top_solid_bit(a0)
	move.b	lrb_solid_bit(a1),lrb_solid_bit(a0)
loc_14082:
	move.w	(Ctrl_1).w,d0
	bra.w	Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_1408A:
	move.w	#0,(Tails_control_counter).w
	move.b	#$F0,double_jump_property(a0)
	move.w	#0,(Ctrl_2_Logical).w
	move.b	(Timer_frames+1).w,d0
	andi.b	#$F,d0
	bne.s	loc_140ACT
	ori.w	#((button_B_mask|button_C_mask|button_A_mask|button_right_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask|button_right_mask),(Ctrl_2_Logical).w
loc_140ACT:
	tst.b	render_flags(a0)
	bmi.s	locret_140C4
	moveq	#0,d0
	move.l	d0,(a0)
	move.w	d0,x_pos(a0)
	move.w	d0,y_pos(a0)
	move.w	#$A,(Tails_CPU_routine).w

locret_140C4:
	rts
; ---------------------------------------------------------------------------

loc_140C6:
	move.w	#0,(Ctrl_2_Logical).w
	rts
; ---------------------------------------------------------------------------

loc_140CET:
	move.b	#1,double_jump_flag(a0)
	move.b	#-$10,double_jump_property(a0)
	move.b	#2,status(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	lea	(MainCharacter).w,a1
	bsr.w	sub_1459E
	move.b	#1,(Flying_carrying_Sonic_flag).w
	move.w	#$16,(Tails_CPU_routine).w

loc_14106:
	move.w	#0,(Tails_control_counter).w
	move.b	#$F0,double_jump_property(a0)
	move.w	#0,(Ctrl_2_Logical).w
	move.b	(Timer_frames+1).w,d0
	andi.b	#7,d0
	bne.s	loc_14128
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w

loc_14128:
	move.w	(Camera_Y_pos).w,d0
	addi.w	#$90,d0
	cmp.w	y_pos(a0),d0
	blo.s	loc_1413C
	move.w	#$18,(Tails_CPU_routine).w

loc_1413C:
	lea	(Flying_carrying_Sonic_flag).w,a2
	lea	(MainCharacter).w,a1
	move.w	(Ctrl_1).w,d0
	bra.w	Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_1414C:
	move.b	#$F0,double_jump_property(a0)
	tst.w	(Tails_control_counter).w
	beq.s	loc_14164
	tst.b	(Flying_carrying_Sonic_flag).w
	bne.w	loc_141E2
	bra.w	loc_142E2T
; ---------------------------------------------------------------------------

loc_14164:
	move.w	#0,(Ctrl_2_Logical).w
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.w	loc_142E2T
	btst	#1,(Ctrl_1).w
	beq.s	loc_14198
	addq.b	#1,(Tails_CPU_auto_fly_timer).w
	cmpi.b	#-$40,(Tails_CPU_auto_fly_timer).w
	blo.s	loc_141D2
	move.b	#0,(Tails_CPU_auto_fly_timer).w
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w
	bra.s	loc_141D2
; ---------------------------------------------------------------------------

loc_14198:
	btst	#0,(Ctrl_1).w
	beq.s	loc_141BA
	addq.b	#1,(Tails_CPU_auto_fly_timer).w
	cmpi.b	#$20,(Tails_CPU_auto_fly_timer).w
	blo.s	loc_141D2
	move.b	#0,(Tails_CPU_auto_fly_timer).w
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w
	bra.s	loc_141D2
; ---------------------------------------------------------------------------

loc_141BA:
	addq.b	#1,(Tails_CPU_auto_fly_timer).w
	cmpi.b	#$58,(Tails_CPU_auto_fly_timer).w
	blo.s	loc_141D2
	move.b	#0,(Tails_CPU_auto_fly_timer).w
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w

loc_141D2:
	move.b	(Ctrl_1).w,d0
	andi.b	#$C,d0
	or.b	(Ctrl_2_Logical).w,d0
	move.b	d0,(Ctrl_2_Logical).w

loc_141E2:
	lea	(Flying_carrying_Sonic_flag).w,a2
	lea	(MainCharacter).w,a1
	move.w	(Ctrl_1).w,d0
	bra.w	Tails_Carry_Sonic
; ---------------------------------------------------------------------------

loc_141F2:
	move.b	#1,double_jump_flag(a0)
	move.b	#-$10,double_jump_property(a0)
	move.b	#2,status(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.w	#$1C,(Tails_CPU_routine).w

loc_1421C:
	move.w	#0,(Tails_control_counter).w
	move.b	#$F0,double_jump_property(a0)
	move.w	#0,(Ctrl_2_Logical).w
	move.b	(Timer_frames+1).w,d0
	andi.b	#7,d0
	bne.s	loc_1423E
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w

loc_1423E:
	move.w	(Camera_Y_pos).w,d0
	addi.w	#$90,d0
	cmp.w	y_pos(a0),d0
	blo.s	locret_14252
	move.w	#$1E,(Tails_CPU_routine).w

locret_14252:
	rts
; ---------------------------------------------------------------------------

loc_14254:
	move.b	#-$10,double_jump_property(a0)
	rts
; ---------------------------------------------------------------------------

loc_1425C:
	move.b	#1,double_jump_flag(a0)
	move.b	#-$10,double_jump_property(a0)
	move.b	#2,status(a0)
	move.w	#$100,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.w	#$22,(Tails_CPU_routine).w

loc_14286:
	move.w	#0,(Tails_control_counter).w
	move.w	#0,(Ctrl_2_Logical).w
	move.b	(Timer_frames+1).w,d0
	andi.b	#$1F,d0
	bne.s	loc_142A2
	ori.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_2_Logical).w

loc_142A2:
	btst	#1,status(a0)
	bne.s	locret_142E0
	move.w	#6,(Tails_CPU_routine).w
	move.b	#0,obj_control(a0)
	move.b	#0,anim(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#2,status(a0)
	move.w	#0,move_lock(a0)
	andi.w	#$7FFF,art_tile(a0)

locret_142E0:
	rts
; ---------------------------------------------------------------------------

loc_142E2T:
	lea	(MainCharacter).w,a1
	tst.b	render_flags(a1)
	bpl.s	loc_143AA
	tst.w	(Tails_control_counter).w
	bne.w	loc_143AA
	cmpi.w	#$300,y_vel(a1)
	bge.w	loc_143AA
	move.w	#0,x_vel(a0)
	move.w	#0,(Ctrl_2_Logical).w
	cmpi.w	#$200,y_vel(a0)
	bge.s	loc_14328
	addq.b	#1,(Tails_CPU_auto_fly_timer).w
	cmpi.b	#$58,(Tails_CPU_auto_fly_timer).w
	blo.s	loc_143AA
	move.b	#0,(Tails_CPU_auto_fly_timer).w

loc_14328:
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w

loc_143AA:
	lea	(Flying_carrying_Sonic_flag).w,a2
	lea	(MainCharacter).w,a1
	move.w	(Ctrl_1).w,d0
	bra.w	Tails_Carry_Sonic

; =============== S U B R O U T I N E =======================================


Tails_Carry_Sonic:
	tst.b	(a2)
	beq.w	loc_14534
	cmpi.b	#4,routine(a1)
	bhs.w	loc_14466
	btst	#1,status(a1)
	beq.w	loc_1445A

	move.w	(Carried_character_x_vel).w,d1
	cmp.w	x_vel(a1),d1
	bne.w	loc_1445A
	move.w	(Carried_character_y_vel).w,d1
	cmp.w	y_vel(a1),d1
	bne.w	loc_14460

	tst.b	obj_control(a1)
	bmi.w	loc_1446A
	btst	#button_down,(Ctrl_1_Logical).w	; is down being pressed?
	beq.w	loc_14474
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	loc_14474
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#$12,1(a2)
	andi.w	#$F00,d0
	beq.w	loc_14410
	move.b	#$3C,1(a2)

loc_14410:
	btst	#$A,d0
	beq.s	loc_1441C
	move.w	#-$200,x_vel(a1)

loc_1441C:
	btst	#$B,d0
	beq.s	loc_14428
	move.w	#$200,x_vel(a1)

loc_14428:
	move.w	#-$380,y_vel(a1)
	bset	#1,status(a1)
	move.b	#1,jumping(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	bset	#2,status(a1)
	bclr	#4,status(a1)
	rts
; ---------------------------------------------------------------------------

loc_1445A:
	move.w	#-$100,y_vel(a1)

loc_14460:
	move.b	#0,jumping(a1)

loc_14466:
	clr.b	obj_control(a1)

loc_1446A:
	clr.b	(a2)
	move.b	#$3C,1(a2)
	rts
; ---------------------------------------------------------------------------

loc_14474:
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$1C,y_pos(a1)

; this used to have something about reversed gravity between these, loc_144F8

loc_14492:
	andi.b	#-4,render_flags(a1)
	andi.b	#-2,status(a1)
	move.b	status(a0),d0
	andi.b	#1,d0
	or.b	d0,render_flags(a1)
	or.b	d0,status(a1)
; more reverse gravity stuff, there was an eori.b #2,render_flags(a1) here, presumably flipping the sprites

loc_144F8:
	move.w	x_vel(a0),(MainCharacter+x_vel).w
	move.w	x_vel(a0),(Carried_character_x_vel).w
	move.w	y_vel(a0),(MainCharacter+y_vel).w
	move.w	y_vel(a0),(Carried_character_y_vel).w
	movem.l	d0-a6,-(sp)
	lea	(MainCharacter).w,a0
	bsr.w	Sonic_DoLevelCollision
	movem.l	(sp)+,d0-a6
	rts
; ---------------------------------------------------------------------------

loc_14534:
	tst.b	1(a2)
	beq.s	loc_14542
	subq.b	#1,1(a2)
	bne.w	locret_1459C

loc_14542:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.w	locret_1459C
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	subi.w	#$20,d1

loc_1456C:
	cmpi.w	#$10,d1
	bhs.w	locret_1459C
	tst.b	obj_control(a1)
	bne.s	locret_1459C
	cmpi.b	#4,routine(a1)
	bhs.s	locret_1459C
	tst.w	(Debug_placement_mode).w
	bne.s	locret_1459C
	tst.b	spindash_flag(a1)
	bne.s	locret_1459C
	bsr.s	sub_1459E
	sfx		sfx_Grab
	move.b	#1,(a2)

locret_1459C:
	rts
; End of function Tails_Carry_Sonic


; =============== S U B R O U T I N E =======================================


sub_1459E:
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	clr.w	angle(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$1C,y_pos(a1)
	move.w	#$1400,anim(a1)	; move.b #AniIDSonAni_Hang2,anim(a1)
	move.b	#0,anim_frame_duration(a1)
	move.b	#0,anim_frame(a1)
	move.b	#3,obj_control(a1)
	bset	#1,status(a1)
	bclr	#4,status(a1)
	move.b	#0,spindash_flag(a1)
	andi.b	#-4,render_flags(a1)
	andi.b	#-2,status(a1)
	move.b	status(a0),d0
	andi.b	#1,d0
	or.b	d0,render_flags(a1)
	or.b	d0,status(a1)
	move.w	x_vel(a0),(Carried_character_x_vel).w
	move.w	x_vel(a0),x_vel(a1)
	move.w	y_vel(a0),(Carried_character_y_vel).w
	move.w	y_vel(a0),y_vel(a1)

locret_14630:
	rts
; End of function sub_1459E

; End of Tails CPU stuff

; ---------------------------------------------------------------------------
; Subroutine to record Tails' previous positions for invincibility stars
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1BF38:
P2_RecordPos:
	move.w	(Tails_Pos_Record_Index).w,d0
	lea	(Tails_Pos_Record_Buf).w,a1
	lea	(a1,d0.w),a1
	move.w	x_pos(a0),(a1)+
	move.w	y_pos(a0),(a1)+
	addq.b	#4,(Tails_Pos_Record_Index+1).w

	rts
; End of subroutine P2_RecordPos

; ===========================================================================
; ---------------------------------------------------------------------------
; Start of subroutine Obj_Tails_MdNormal
; Called if Tails is neither airborne nor rolling this frame
; ---------------------------------------------------------------------------
; loc_1C00A:
Obj_Tails_MdNormal:
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	loc_14760
	lea	(MainCharacter).w,a1
	clr.b	obj_control(a1)
	bset	#1,status(a1)
	clr.w	(Flying_carrying_Sonic_flag).w

loc_14760:
	bsr.w	Tails_CheckSpindash
	bsr.w	Tails_Jump
	bsr.w	Tails_SlopeResist
	bsr.w	Tails_Move
	bsr.w	Player_Roll
	bsr.w	Tails_LevelBound
	jsr	(ObjectMove).l
	bsr.w	AnglePos
	bsr.w	Player_SlopeRepel
	rts
; End of subroutine Obj_Tails_MdNormal
; ===========================================================================
; Start of subroutine Obj_Tails_MdAir
; Called if Tails is airborne, but not in a ball (thus, probably not jumping)
; loc_1C032: Obj_Tails_MdJump
Obj_Tails_MdAir:
	cmpi.b	#AniIDTailsAni_Spring,anim(a0)
	bne.s	+
	tst.b	y_vel(a0)
	blt.s	+
	move.b	#AniIDTailsAni_Fall,anim(a0)
+
	tst.b	double_jump_flag(a0)
	bne.s	Tails_FlyingSwimming
	bsr.w	Player_AirRoll
	bsr.w	Player_JumpHeight
	bsr.w	Tails_ChgJumpDir
	bsr.w	Tails_LevelBound
	jsr	(ObjectMoveAndFall).l
	btst	#6,status(a0)	; is Tails underwater?
	beq.s	+		; if not, branch
	subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)
+
	bsr.w	Tails_JumpAngle
	bra.w	Tails_DoLevelCollision
; End of subroutine Obj_Tails_MdAir
; ---------------------------------------------------------------------------

Tails_FlyingSwimming:
	bsr.w	Tails_Move_FlySwim
	bsr.w	Tails_ChgJumpDir
	bsr.w	Tails_LevelBound
;	jsr		(ObjectMove).l	; old SNI
	jsr	(ObjectMoveAndFall2).l	; new
	bsr.w	Tails_JumpAngle
;	movem.l	a4-a6,-(sp)		; old SNI
	bsr.w	Tails_DoLevelCollision
;	movem.l	(sp)+,a4-a6		; old SNI
	cmpa.w	#MainCharacter,a0
	beq.s	locret_14820
	lea	(Flying_carrying_Sonic_flag).w,a2
	lea	(MainCharacter).w,a1
	move.w	(Ctrl_1).w,d0
	bsr.w	Tails_Carry_Sonic

locret_14820:
	rts

; =============== S U B R O U T I N E =======================================


Tails_Move_FlySwim:
	move.b	(Timer_frames+1).w,d0
	andi.b	#1,d0
	beq.s	loc_14836
	tst.b	double_jump_property(a0)
	beq.s	loc_14836
	subq.b	#1,double_jump_property(a0)

loc_14836:
	cmpi.b	#1,double_jump_flag(a0)
	beq.s	loc_14860
	cmpi.w	#-$100,y_vel(a0)
	blt.s	loc_14858
	subi.w	#$20,y_vel(a0)
	addq.b	#1,double_jump_flag(a0)
	cmpi.b	#$20,double_jump_flag(a0)
	bne.s	loc_1485E

loc_14858:
	move.b	#1,double_jump_flag(a0)

loc_1485E:
	bra.s	loc_14892
; ---------------------------------------------------------------------------

loc_14860:  ; Come back to this one
	tst.w	(Tails_control_counter).w
	bne.s	Player2_ContFlight
	tst.b	(Flying_carrying_Sonic_flag).w
	bne.s	Player1_ContFlight
Player2_ContFlight:
	move.b	(Ctrl_2_Press_Logical).w,d0
	bra.s	ComparePressT
Player1_ContFlight:
	move.b	(Ctrl_1_Press_Logical).w,d0
ComparePressT:
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.s	loc_1488C
; old SNI, but genuinely a good idea
	cmpi.w	#-$100,y_vel(a0)
	blt.s	loc_1488C

	tst.b	double_jump_property(a0)
	beq.s	loc_1488C
	btst	#6,status(a0)
	beq.s	loc_14886
	tst.b	(Flying_carrying_Sonic_flag).w
	bne.s	loc_1488C

loc_14886:
	move.b	#2,double_jump_flag(a0)

loc_1488C:
	addi.w	#8,y_vel(a0)

loc_14892:
	move.w	(Camera_Min_Y_pos).w,d0
	addi.w	#$10,d0
	cmp.w	y_pos(a0),d0
	blt.s	Tails_Set_Flying_Animation
	tst.w	y_vel(a0)
	bpl.s	Tails_Set_Flying_Animation
	move.w	#0,y_vel(a0)
; End of function Tails_Move_FlySwim


; =============== S U B R O U T I N E =======================================

Tails_Set_Flying_Animation:
	btst	#6,status(a0)
	bne.s	loc_14914
	moveq	#AniIDTailsAni_Fly,d0
	tst.w	(Two_player_mode).w
	bne.s	loc_148F4
	tst.w	y_vel(a0)
	bpl.s	loc_148C4
	moveq	#AniIDTailsAni_Fly2,d0

loc_148C4:
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	loc_148CC
	addq.b	#3,d0	; was #7 in old SNI, but that's due to animation ID differences so it doesn't matter

loc_148CC:
	tst.b	double_jump_property(a0)
	bne.s	loc_148F4
	moveq	#AniIDTailsAni_Tired,d0
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	+
	moveq	#AniIDTailsAni_CarryTired,d0		
+
	move.b	d0,anim(a0)
	tst.b	render_flags(a0)
	bpl.s	locret_148F2
	move.b	(Timer_frames+1).w,d0
	addq.b	#8,d0
	andi.b	#$F,d0
	bne.s	locret_148F2
	sfx		sfx_FlyTired

locret_148F2:
	rts
; ---------------------------------------------------------------------------

loc_148F4:
	move.b	d0,anim(a0)
	tst.b	render_flags(a0)
	bpl.s	locret_14912
	move.b	(Timer_frames+1).w,d0
	addq.b	#8,d0
	andi.b	#$F,d0
	bne.s	locret_14912
	sfx		sfx_Fly
	
locret_14912:
	rts
; ---------------------------------------------------------------------------

loc_14914:
	moveq	#AniIDTailsAni_Swim,d0
	tst.w	y_vel(a0)
	bpl.s	loc_1491E
	moveq	#AniIDTailsAni_Swim2,d0

loc_1491E:
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	loc_14926
	moveq	#AniIDTailsAni_SwimCarry,d0

loc_14926:
	tst.b	double_jump_property(a0)
	bne.s	loc_1492E
	moveq	#AniIDTailsAni_SwimTired,d0
loc_1492E:
	move.b	d0,anim(a0)
	rts
; End of function Tails_Set_Flying_Animation
; ===========================================================================
; Start of subroutine Obj_Tails_MdRoll
; Called if Tails is in a ball, but not airborne (thus, probably rolling)
; loc_1C05C:
Obj_Tails_MdRoll:
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	loc_1494C
	lea	(MainCharacter).w,a1
	clr.b	obj_control(a1)
	bset	#1,status(a1)
	clr.w	(Flying_carrying_Sonic_flag).w

loc_1494C:
	tst.b	pinball_mode(a0)
	bne.s	+
	bsr.w	Tails_Jump
+
	bsr.w	Player_RollRepel
	bsr.w	Tails_RollSpeed
	bsr.w	Tails_LevelBound
	jsr	(ObjectMove).l
	bsr.w	AnglePos
	bsr.w	Player_SlopeRepel
	rts
; End of subroutine Obj_Tails_MdRoll
; ===========================================================================
; Start of subroutine Obj_Tails_MdJump
; Called if Tails is in a ball and airborne (he could be jumping but not necessarily)
; Notes: This is identical to Obj_Tails_MdAir, at least at this outer level.
;        Why they gave it a separate copy of the code, I don't know.
; loc_1C082: Obj_Tails_MdJump2:
Obj_Tails_MdJump:
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	loc_149BA
	lea	(MainCharacter).w,a1
	clr.b	obj_control(a1)
	bset	#1,status(a1)
	clr.w	(Flying_carrying_Sonic_flag).w

loc_149BA:
	bsr.w	Player_JumpHeight
	bsr.w	Tails_ChgJumpDir
	bsr.w	Tails_LevelBound
	jsr	(ObjectMoveAndFall).l
	btst	#6,status(a0)	; is Tails underwater?
	beq.s	+		; if not, branch
	subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)
+
	bsr.w	Tails_JumpAngle
	bsr.w	Tails_DoLevelCollision
	rts
; End of subroutine Obj_Tails_MdJump

; ---------------------------------------------------------------------------
; Subroutine to make Tails walk/run
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C0AC:
Tails_Move:
	move.w	(Tails_top_speed).w,d6
	move.w	(Tails_acceleration).w,d5
	move.w	(Tails_deceleration).w,d4
    if status_sec_isSliding = 7
	tst.b	status_secondary(a0)
	bmi.w	Obj_Tails_Traction
    else
	btst	#status_sec_isSliding,status_secondary(a0)
	bne.w	Obj_Tails_Traction
    endif
	tst.w	move_lock(a0)
	bne.w	Obj_Tails_ResetScr
	jsr		GetCtrlHeldLogical.d2
	btst	#button_left,d2	; is left being pressed?
	beq.s	Obj_Tails_NotLeft			; if not, branch
	bsr.w	Tails_MoveLeft
; loc_1C0D4:
Obj_Tails_NotLeft:
	btst	#button_right,d2	; is right being pressed?
	beq.s	Obj_Tails_NotRight			; if not, branch
	bsr.w	Tails_MoveRight
; loc_1C0E0:
Obj_Tails_NotRight:
	move.b	angle(a0),d0
	addi.b	#$20,d0
	andi.b	#$C0,d0		; is Tails on a slope?
	bne.w	Obj_Tails_ResetScr	; if yes, branch
	tst.w	inertia(a0)	; is Tails moving?
	bne.w	Obj_Tails_ResetScr	; if yes, branch
	bclr	#5,status(a0)
	tst.b	(Victory_flag).w
	beq.s	.normal
	move.b	#AniIDTailsAni_Victory,anim(a0)
	rts
.normal:
	move.b	#AniIDTailsAni_Wait,anim(a0)	; use "standing" animation
	btst	#3,status(a0)
	beq.s	Tails_Balance
.cont:
	moveq	#0,d0
	move.w	interact(a0),a1
	tst.b	status(a1)
	bmi.s	Tails_Lookup
	moveq	#0,d1
	move.b	width_pixels(a1),d1
	move.w	d1,d2
	add.w	d2,d2
	subq.w	#4,d2
	add.w	x_pos(a0),d1
	sub.w	x_pos(a1),d1
	cmpi.w	#4,d1
	blt.s	Tails_BalanceOnObjLeft
	cmp.w	d2,d1
	bge.s	Tails_BalanceOnObjRight
	bra.s	Tails_Lookup
; ---------------------------------------------------------------------------
; balancing checks for Tails
; loc_1C142:
Tails_Balance:
	jsr	(ChkFloorEdge).l
	cmpi.w	#$C,d1
	blt.s	Tails_Lookup
	cmpi.b	#3,next_tilt(a0)
	bne.s	Tails_BalanceLeft
; loc_1C156:
Tails_BalanceOnObjRight:
	bclr	#0,status(a0)
	bra.s	Tails_BalanceDone
; ---------------------------------------------------------------------------
; loc_1C15E:
Tails_BalanceLeft:
	cmpi.b	#3,tilt(a0)
	bne.s	Tails_Lookup
; loc_1C166:
Tails_BalanceOnObjLeft:
	bset	#0,status(a0)
; loc_1C16C:
Tails_BalanceDone:
	move.b	#AniIDTailsAni_Balance,anim(a0)
	bra.s	Obj_Tails_ResetScr
; ---------------------------------------------------------------------------
; loc_1C174:
Tails_Lookup:
	jsr		GetCtrlHeldLogical
	btst	#button_up,d0	; is up being pressed?
	beq.s	Tails_Duck			; if not, branch
	move.b	#AniIDTailsAni_LookUp,anim(a0)			; use "looking up" animation
	addq.w	#1,(Tails_Look_delay_counter).w
	cmpi.w	#$78,(Tails_Look_delay_counter).w
	blo.s	Obj_Tails_ResetScr_Part2
	move.w	#$78,(Tails_Look_delay_counter).w
	cmpa.w	#MainCharacter,a0
	bne.s	+
	cmpi.w	#$C8,(Camera_Y_pos_bias).w
	beq.s	Obj_Tails_UpdateSpeedOnGround
	addq.w	#2,(Camera_Y_pos_bias).w
+
	bra.s	Obj_Tails_UpdateSpeedOnGround
; ---------------------------------------------------------------------------
; loc_1C1A2:
Tails_Duck:
	btst	#button_down,d0	; is down being pressed?
	beq.s	Obj_Tails_ResetScr			; if not, branch
	move.b	#AniIDTailsAni_Duck,anim(a0)			; use "ducking" animation
	addq.w	#1,(Tails_Look_delay_counter).w
	cmpi.w	#$78,(Tails_Look_delay_counter).w
	blo.s	Obj_Tails_ResetScr_Part2
	move.w	#$78,(Tails_Look_delay_counter).w
	cmpa.w	#MainCharacter,a0
	bne.s	+
	cmpi.w	#8,(Camera_Y_pos_bias).w
	beq.s	Obj_Tails_UpdateSpeedOnGround
	subq.w	#2,(Camera_Y_pos_bias).w
+
	bra.s	Obj_Tails_UpdateSpeedOnGround

; ===========================================================================
; moves the screen back to its normal position after looking up or down
; loc_1C1D0:
Obj_Tails_ResetScr:
	move.w	#0,(Tails_Look_delay_counter).w
; loc_1C1D6:
Obj_Tails_ResetScr_Part2:
	cmpa.w	#MainCharacter,a0
	bne.s	Obj_Tails_UpdateSpeedOnGround
	cmpi.w	#(224/2)-16,(Camera_Y_pos_bias).w	; is screen in its default position?
	beq.s	Obj_Tails_UpdateSpeedOnGround	; if yes, branch.
	bhs.s	+				; depending on the sign of the difference,
	addq.w	#4,(Camera_Y_pos_bias).w	; either add 2
+	subq.w	#2,(Camera_Y_pos_bias).w	; or subtract 2

; ---------------------------------------------------------------------------
; updates Tails' speed on the ground
; ---------------------------------------------------------------------------
; loc_1C1E8:
Obj_Tails_UpdateSpeedOnGround:
	jsr		GetCtrlHeldLogical
	andi.b	#button_left_mask|button_right_mask,d0		; is left/right pressed?
	bne.s	Obj_Tails_Traction	; if yes, branch
	move.w	inertia(a0),d0
	beq.s	Obj_Tails_Traction
	bmi.s	Obj_Tails_SettleLeft

; slow down when facing right and not pressing a direction
; Obj_Tails_SettleRight:
	sub.w	d5,d0
	bcc.s	+
	move.w	#0,d0
+
	move.w	d0,inertia(a0)
	bra.s	Obj_Tails_Traction
; ---------------------------------------------------------------------------
; slow down when facing left and not pressing a direction
; loc_1C208:
Obj_Tails_SettleLeft:
	add.w	d5,d0
	bcc.s	+
	move.w	#0,d0
+
	move.w	d0,inertia(a0)

; increase or decrease speed on the ground
; loc_1C214:
Obj_Tails_Traction:
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	muls.w	inertia(a0),d1
	asr.l	#8,d1
	move.w	d1,x_vel(a0)
	muls.w	inertia(a0),d0
	asr.l	#8,d0
	move.w	d0,y_vel(a0)

; stops Tails from running through walls that meet the ground
; loc_1C232:
Obj_Tails_CheckWallsOnGround:
	move.b	angle(a0),d0
	addi.b	#$40,d0
	bmi.s	return_1C2A2
	move.b	#$40,d1
	tst.w	inertia(a0)
	beq.s	return_1C2A2
	bmi.s	+
	neg.w	d1
+
	move.b	angle(a0),d0
	add.b	d1,d0
	move.w	d0,-(sp)
	bsr.w	CalcRoomInFront
	move.w	(sp)+,d0
	tst.w	d1
	bpl.s	return_1C2A2
	asl.w	#8,d1
	addi.b	#$20,d0
	andi.b	#$C0,d0
	beq.s	loc_1C29E
	cmpi.b	#$40,d0
	beq.s	loc_1C28C
	cmpi.b	#$80,d0
	beq.s	loc_1C286
	add.w	d1,x_vel(a0)
	bset	#5,status(a0)
	move.w	#0,inertia(a0)
	rts
; ---------------------------------------------------------------------------

loc_1C286:
	sub.w	d1,y_vel(a0)
	rts
; ---------------------------------------------------------------------------

loc_1C28C:
	sub.w	d1,x_vel(a0)
	bset	#5,status(a0)
	move.w	#0,inertia(a0)
	rts
; ---------------------------------------------------------------------------
loc_1C29E:
	add.w	d1,y_vel(a0)

return_1C2A2:
	rts
; End of subroutine Tails_Move


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C2A4:
Tails_MoveLeft:
	move.w	inertia(a0),d0
	beq.s	+
	bpl.s	Tails_TurnLeft	; if Tails is already moving to the right, branch
+
	bset	#0,status(a0)
	bne.s	+
	bclr	#5,status(a0)
	move.b	#AniIDTailsAni_Run,next_anim(a0)
+
	sub.w	d5,d0	; add acceleration to the left
	move.w	d6,d1
	neg.w	d1
	cmp.w	d1,d0	; compare new speed with top speed
	bgt.s	+	; if new speed is less than the maximum, branch
	add.w	d5,d0	; remove this frame's acceleration change
	cmp.w	d1,d0	; compare speed with top speed
	ble.s	+	; if speed was already greater than the maximum, branch
	move.w	d1,d0	; limit speed on ground going left
+
	move.w	d0,inertia(a0)
	move.b	#AniIDTailsAni_Walk,anim(a0)	; use walking animation
	rts
; ---------------------------------------------------------------------------
; loc_1C2DE:
Tails_TurnLeft:
	sub.w	d4,d0
	bcc.s	+
	move.w	#-$80,d0
+
	move.w	d0,inertia(a0)
	move.b	angle(a0),d0
	addi.b	#$20,d0
	andi.b	#$C0,d0
	bne.s	return_1C328
	cmpi.w	#$400,d0
	blt.s	return_1C328
	move.b	#AniIDTailsAni_Stop,anim(a0)	; use "stopping" animation
	bclr	#0,status(a0)
	sfx	sfx_Skid
	cmpi.b	#$C,air_left(a0)
	blo.s	return_1C328	; if he's drowning, branch to not make dust
	jsr		PutDustIntoA1
	move.b	#6,routine(a1)
	move.b	#$15,mapping_frame(a1)

return_1C328:
	rts
; End of subroutine Tails_MoveLeft


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C32A:
Tails_MoveRight:
	move.w	inertia(a0),d0
	bmi.s	Tails_TurnRight
	bclr	#0,status(a0)
	beq.s	+
	bclr	#5,status(a0)
	move.b	#AniIDTailsAni_Run,next_anim(a0)
+
	add.w	d5,d0	; add acceleration to the right
	cmp.w	d6,d0	; compare new speed with top speed
	blt.s	+	; if new speed is less than the maximum, branch
	sub.w	d5,d0	; remove this frame's acceleration change
	cmp.w	d6,d0	; compare speed with top speed
	bge.s	+	; if speed was already greater than the maximum, branch
	move.w	d6,d0	; limit speed on ground going right
+
	move.w	d0,inertia(a0)
	move.b	#AniIDTailsAni_Walk,anim(a0)	; use walking animation
	rts
; ---------------------------------------------------------------------------
; loc_1C35E:
Tails_TurnRight:
	add.w	d4,d0
	bcc.s	+
	move.w	#$80,d0
+
	move.w	d0,inertia(a0)
	move.b	angle(a0),d0
	addi.b	#$20,d0
	andi.b	#$C0,d0
	bne.s	return_1C3A8
	cmpi.w	#-$400,d0
	bgt.s	return_1C3A8
	move.b	#AniIDTailsAni_Stop,anim(a0)	; use "stopping" animation
	bset	#0,status(a0)
	sfx	sfx_Skid
	cmpi.b	#$C,air_left(a0)
	blo.s	return_1C3A8	; if he's drowning, branch to not make dust
	jsr		PutDustIntoA1
	move.b	#6,routine(a1)
	move.b	#$15,mapping_frame(a1)

return_1C3A8:
	rts
; End of subroutine Tails_MoveRight

; ---------------------------------------------------------------------------
; Subroutine to change Tails' speed as he rolls
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C3AA:
Tails_RollSpeed:
	move.w	(Tails_top_speed).w,d6
	asl.w	#1,d6
	move.w	(Tails_acceleration).w,d5
	asr.w	#1,d5	; natural roll deceleration = 1/2 normal acceleration
	move.w	(Tails_deceleration).w,d4
	asr.w	#2,d4	; controlled roll deceleration...
			; interestingly, Tails is much worse at this than Sonic when underwater
    if status_sec_isSliding = 7
	tst.b	status_secondary(a0)
	bmi.w	Obj_Tails_Roll_ResetScr
    else
	btst	#status_sec_isSliding,status_secondary(a0)
	bne.w	Obj_Tails_Roll_ResetScr
    endif
	tst.w	move_lock(a0)
	bne.s	Tails_ApplyRollSpeed
	jsr		GetCtrlHeldLogical
	btst	#button_left,d0	; is left being pressed?
	beq.s	+				; if not, branch
	bsr.w	Tails_RollLeft
+
	btst	#button_right,d0	; is right being pressed?
	beq.s	Tails_ApplyRollSpeed		; if not, branch
	bsr.w	Tails_RollRight

; loc_1C3E2:
Tails_ApplyRollSpeed:
	move.w	inertia(a0),d0
	beq.s	Tails_CheckRollStop
	bmi.s	Tails_ApplyRollSpeedLeft

; Tails_ApplyRollSpeedRight:
	sub.w	d5,d0
	bcc.s	+
	move.w	#0,d0
+
	move.w	d0,inertia(a0)
	bra.s	Tails_CheckRollStop
; ---------------------------------------------------------------------------
; loc_1C3F8:
Tails_ApplyRollSpeedLeft:
	add.w	d5,d0
	bcc.s	+
	move.w	#0,d0
+
	move.w	d0,inertia(a0)

; loc_1C404
Tails_CheckRollStop:
	tst.w	inertia(a0)
	bne.s	Obj_Tails_Roll_ResetScr
	tst.b	pinball_mode(a0)  ; note: the spindash flag has a different meaning when Tails is already rolling -- it's used to mean he's not allowed to stop rolling
	bne.s	Tails_KeepRolling
	bclr	#2,status(a0)
	jsr		ResetHeight_a0
	move.b	#AniIDTailsAni_Wait,anim(a0)
	subq.w	#1,y_pos(a0)
	bra.s	Obj_Tails_Roll_ResetScr

; ---------------------------------------------------------------------------
; magically gives Tails an extra push if he's going to stop rolling where it's not allowed
; (such as in an S-curve in HTZ or a stopper chamber in CNZ)
; loc_1C42E:
Tails_KeepRolling:
	move.w	#$400,inertia(a0)
	btst	#0,status(a0)
	beq.s	Obj_Tails_Roll_ResetScr
	neg.w	inertia(a0)

; resets the screen to normal while rolling, like Obj_Tails_ResetScr
; loc_1C440:
Obj_Tails_Roll_ResetScr:
	cmpa.w	#MainCharacter,a0
	bne.s	Tails_SetRollSpeed
	cmpi.w	#(224/2)-16,(Camera_Y_pos_bias).w	; is screen in its default position?
	beq.s	Tails_SetRollSpeed		; if yes, branch
	bhs.s	+				; depending on the sign of the difference,
	addq.w	#4,(Camera_Y_pos_bias).w	; either add 2
+	subq.w	#2,(Camera_Y_pos_bias).w	; or subtract 2

; loc_1C452:
Tails_SetRollSpeed:
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	muls.w	inertia(a0),d0
	asr.l	#8,d0
	move.w	d0,y_vel(a0)	; set y velocity based on $14 and angle
	muls.w	inertia(a0),d1
	asr.l	#8,d1
	cmpi.w	#$1000,d1
	ble.s	+
	move.w	#$1000,d1	; limit Tails' speed rolling right
+
	cmpi.w	#-$1000,d1
	bge.s	+
	move.w	#-$1000,d1	; limit Tails' speed rolling left
+
	move.w	d1,x_vel(a0)	; set x velocity based on $14 and angle
	bra.w	Obj_Tails_CheckWallsOnGround
; End of function Tails_RollSpeed


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; loc_1C488:
Tails_RollLeft:
	move.w	inertia(a0),d0
	beq.s	+
	bpl.s	Tails_BrakeRollingRight
+
	bset	#0,status(a0)
	move.b	#AniIDTailsAni_Roll,anim(a0)	; use "rolling" animation
	rts
; ---------------------------------------------------------------------------
; loc_1C49E:
Tails_BrakeRollingRight:
	sub.w	d4,d0	; reduce rightward rolling speed
	bcc.s	+
	move.w	#-$80,d0
+
	move.w	d0,inertia(a0)
	rts
; End of function Tails_RollLeft


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; loc_1C4AC:
Tails_RollRight:
	move.w	inertia(a0),d0
	bmi.s	Tails_BrakeRollingLeft
	bclr	#0,status(a0)
	move.b	#AniIDTailsAni_Roll,anim(a0)	; use "rolling" animation
	rts
; ---------------------------------------------------------------------------
; loc_1C4C0:
Tails_BrakeRollingLeft:
	add.w	d4,d0		; reduce leftward rolling speed
	bcc.s	+
	move.w	#$80,d0
+
	move.w	d0,inertia(a0)
	rts
; End of subroutine Tails_RollRight


; ---------------------------------------------------------------------------
; Subroutine for moving Tails left or right when he's in the air
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C4CE:
Tails_ChgJumpDir:   ; I don't think this'll really ever be combined, but oh well.
	move.w	(Tails_top_speed).w,d6
	move.w	(Tails_acceleration).w,d5
	asl.w	#1,d5
	btst	#4,status(a0)		; did Tails jump from rolling?
	bne.s	Obj_Tails_Jump_ResetScr	; if yes, branch to skip midair control
	move.w	x_vel(a0),d0
    ; Also come back to this one
	tst.w	(Tails_control_counter).w
	bne.s	Player2_ContFlight2
	tst.b	(Flying_carrying_Sonic_flag).w
	bne.s	Player1_ContFlight2
Player2_ContFlight2:
	btst	#button_left,(Ctrl_2_Held_Logical).w
	bra.s	ComparePressT2
Player1_ContFlight2:
	btst	#button_left,(Ctrl_1_Held_Logical).w
ComparePressT2:
	beq.s	+	; if not holding left, branch

	bset	#0,status(a0)
	sub.w	d5,d0	; add acceleration to the left
	move.w	d6,d1
	neg.w	d1
	cmp.w	d1,d0	; compare new speed with top speed
	bgt.s	+	; if new speed is less than the maximum, branch
	move.w	d1,d0	; limit speed in air going left, even if Tails was already going faster (speed limit/cap)
+
	tst.w	(Tails_control_counter).w
	bne.s	Player2_ContFlight3
	tst.b	(Flying_carrying_Sonic_flag).w
	bne.s	Player1_ContFlight3
    ; Come back to this one
Player2_ContFlight3:
	btst	#button_right,(Ctrl_2_Held_Logical).w
	bra.s	ComparePressT3
Player1_ContFlight3:
	btst	#button_right,(Ctrl_1_Held_Logical).w
ComparePressT3:
	beq.s	+	; if not holding right, branch

	bclr	#0,status(a0)
	add.w	d5,d0	; accelerate right in the air
	cmp.w	d6,d0	; compare new speed with top speed
	blt.s	+	; if new speed is less than the maximum, branch
	move.w	d6,d0	; limit speed in air going right, even if Tails was already going faster (speed limit/cap)
; Obj_Tails_JumpMove:
+	move.w	d0,x_vel(a0)

; loc_1C518: Obj_Tails_ResetScr2:
Obj_Tails_Jump_ResetScr:
	cmpa.w	#MainCharacter,a0
	bne.s	Tails_JumpPeakDecelerate
	cmpi.w	#(224/2)-16,(Camera_Y_pos_bias).w	; is screen in its default position?
	beq.s	Tails_JumpPeakDecelerate			; if yes, branch
	bhs.s	+				; depending on the sign of the difference,
	addq.w	#4,(Camera_Y_pos_bias).w	; either add 2
+	subq.w	#2,(Camera_Y_pos_bias).w	; or subtract 2

; loc_1C52A:
Tails_JumpPeakDecelerate:
	cmpi.w	#-$400,y_vel(a0)	; is Tails moving faster than -$400 upwards?
	blo.s	return_1C558		; if yes, return
	move.w	x_vel(a0),d0
	move.w	d0,d1
	asr.w	#5,d1		; d1 = x_velocity / 32
	beq.s	return_1C558	; return if d1 is 0
	bmi.s	Tails_JumpPeakDecelerateLeft

; Tails_JumpPeakDecelerateRight:
	sub.w	d1,d0	; reduce x velocity by d1
	bcc.s	+
	move.w	#0,d0
+
	move.w	d0,x_vel(a0)
	rts
; ---------------------------------------------------------------------------
; loc_1C54C:
Tails_JumpPeakDecelerateLeft:
	sub.w	d1,d0	; reduce x velocity by d1
	bcs.s	+
	move.w	#0,d0
+
	move.w	d0,x_vel(a0)

return_1C558:
	rts
; End of subroutine Tails_ChgJumpDir
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to prevent Tails from leaving the boundaries of a level
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C55A:
Tails_LevelBound:
	move.l	x_pos(a0),d1
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d1
	swap	d1
	move.w	(Tails_Min_X_pos).w,d0
	addi.w	#$10,d0
	cmp.w	d1,d0			; has Tails touched the left boundary?
	bhi.s	Tails_Boundary_Sides	; if yes, branch
	move.w	(Tails_Max_X_pos).w,d0
	addi.w	#$128,d0
	tst.b	(Current_Boss_ID).w
	bne.s	+
	addi.w	#$40,d0
+
	cmp.w	d1,d0			; has Tails touched the right boundary?
	bls.s	Tails_Boundary_Sides	; if yes, branch

; loc_1C58C:
Tails_Boundary_CheckBottom:
	move.w	(Tails_Max_Y_pos).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0		; has Tails touched the bottom boundary?
	blt.s	Tails_Boundary_Bottom	; if yes, branch
	rts
; ---------------------------------------------------------------------------
Tails_Boundary_Bottom:
	lea	0.w,a2			; NAT: Make the code below wont crash
	jmp	(KillCharacter).l
; ===========================================================================

; loc_1C5A0:
Tails_Boundary_Sides:
	move.w	d0,x_pos(a0)
	move.w	#0,x_sub(a0) ; subpixel x
	move.w	#0,x_vel(a0)
	move.w	#0,inertia(a0)
	bra.s	Tails_Boundary_CheckBottom
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine allowing Tails to jump
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C61E:
Tails_Jump:
	jsr		GetCtrlPressLogical
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0 ; is A, B or C pressed?
	beq.w	return_1C6C2	; if not, return
	moveq	#0,d0
	move.b	angle(a0),d0
	addi.b	#$80,d0
	bsr.w	CalcRoomOverHead
	cmpi.w	#6,d1		; does Tails have enough room to jump?
	blt.w	return_1C6C2	; if not, branch
	move.w	#$680,d2
	btst	#6,status(a0)	; Test if underwater
	beq.s	+
	move.w	#$380,d2	; set lower jump speed if underwater
+
	moveq	#0,d0
	move.b	angle(a0),d0
	subi.b	#$40,d0
	jsr	(CalcSine).l
	muls.w	d2,d1
	asr.l	#8,d1
	add.w	d1,x_vel(a0)	; make Tails jump (in X... this adds nothing on level ground)
	muls.w	d2,d0
	asr.l	#8,d0
	add.w	d0,y_vel(a0)	; make Tails jump (in Y)
	bset	#1,status(a0)
	bclr	#5,status(a0)
	addq.l	#4,sp
	move.b	#1,jumping(a0)
	clr.b	stick_to_convex(a0)
	sfx	sfx_Jump	; play jumping sound

	move.b	#$E,y_radius(a0)
	move.b	#7,x_radius(a0)
	btst	#2,status(a0)
	bne.s	Tails_RollJump
	move.b	#AniIDTailsAni_Roll,anim(a0)	; use "jumping" animation
	bset	#2,status(a0)
	addq.w	#1,y_pos(a0)

return_1C6C2:
	rts
; ---------------------------------------------------------------------------
; loc_1C6C4:
Tails_RollJump:
	bset	#4,status(a0) ; set the rolling+jumping flag
	rts
; End of function Tails_Jump


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ===========================================================================
Tails_Test_For_Flight:
	tst.b	double_jump_flag(a0)
	bne.w	locret_151A2
    jsr		GetCtrlPressLogical
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	locret_151A2
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_15156
	bclr	#4,status(a0)
	tst.b	(Super_Tails_flag).w	; check Super-state
	beq.s	Tails_CheckTransform		; if not in a super-state, branch
	bra.s	loc_1515C
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Code that transforms Tails into Super Tails
; if he has enough rings and emeralds
; ---------------------------------------------------------------------------

Tails_CheckTransform:
	cmpi.b	#7,(Emerald_count).w		; does Tails have all 7 Chaos Emeralds?
	blo.s	loc_1515C		; if not, branch:
	cmpi.w	#50,(Ring_count).w	; does Tails have at least 50 rings?
	blo.s	loc_1515C	; if not, Fly/Swim
	tst.b	(Update_HUD_timer).w
	bne.w	Sonic_TurnSuper
	bra.s	loc_1515C
; ---------------------------------------------------------------------------

loc_15156:
	move.b	(Ctrl_1_Logical).w,d0
	andi.b	#button_up_mask,d0
	bne.w	loc_1515C
	tst.w	(Tails_control_counter).w
	beq.s	locret_151A2

loc_1515C:
	btst	#2,status(a0)
	beq.s	loc_1518C
	bclr	#2,status(a0)
	move.b	y_radius(a0),d1
	move.b	#$F,y_radius(a0)
	move.b	#9,x_radius(a0)
	sub.b	#$F,d1
	ext.w	d1

loc_15188:
	add.w	d1,y_pos(a0)

loc_1518C:
	bclr	#4,status(a0)
	move.b	#1,double_jump_flag(a0)
	move.b	#-$10,double_jump_property(a0)
	bsr.w	Tails_Set_Flying_Animation

locret_151A2:
	rts
; ---------------------------------------------------------------------------
; End of function Tails_Test_For_Flight

; ---------------------------------------------------------------------------
; Subroutine to check for starting to charge a spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C70E:
Tails_CheckSpindash:    ; Remove this eventually. For now, I'll just fix its controls.
	tst.b	spindash_flag(a0)
	bne.s	Tails_UpdateSpindash
	cmpi.b	#AniIDTailsAni_Duck,anim(a0)
	bne.s	return_1C75C
    jsr		GetCtrlPressLogical
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	return_1C75C
	move.b	#AniIDTailsAni_Spindash,anim(a0)
	sfx	sfx_Spindash
	addq.l	#4,sp
	move.b	#1,spindash_flag(a0)
	move.w	#0,spindash_counter(a0)
	cmpi.b	#$C,air_left(a0)	; if he's drowning, branch to not make dust
	blo.s	+
	jsr		PutDustIntoA1
	move.b	#2,anim(a1)
+
	bsr.w	Tails_LevelBound
	bsr.w	AnglePos

return_1C75C:
	rts
; End of subroutine Tails_CheckSpindash


; ---------------------------------------------------------------------------
; Subrouting to update an already-charging spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C75E:
Tails_UpdateSpindash:
    jsr		GetCtrlHeldLogical
	btst	#button_down,d0
	bne.w	Tails_ChargingSpindash

	; unleash the charged spindash and start rolling quickly:
	move.b	#$E,y_radius(a0)
	move.b	#7,x_radius(a0)
	move.b	#AniIDTailsAni_Roll,anim(a0)
	addq.w	#1,y_pos(a0)	; add the difference between Tails' rolling and standing heights
	move.b	#0,spindash_flag(a0)
	moveq	#0,d0
	move.b	spindash_counter(a0),d0
	add.w	d0,d0
	move.w	Tails_SpindashSpeeds(pc,d0.w),inertia(a0)
	cmpa.w	#MainCharacter,a0
	bne.s	+
	move.w	inertia(a0),d0
	subi.w	#$800,d0
	add.w	d0,d0
	andi.w	#$1F00,d0
	neg.w	d0
	addi.w	#$2000,d0
	move.w	d0,(Horiz_scroll_delay_val).w
+
	btst	#0,status(a0)
	beq.s	+
	neg.w	inertia(a0)
+
	bset	#2,status(a0)
	jsr		PutDustIntoA1
	move.b	#0,anim(a1)
	sfx	sfx_Dash
	bra.s	Obj_Tails_Spindash_ResetScr
; ===========================================================================
; word_1C7CE:
Tails_SpindashSpeeds:
	dc.w  $800	; 0
	dc.w  $880	; 1
	dc.w  $900	; 2
	dc.w  $980	; 3
	dc.w  $A00	; 4
	dc.w  $A80	; 5
	dc.w  $B00	; 6
	dc.w  $B80	; 7
	dc.w  $C00	; 8
; ===========================================================================
; loc_1C7E0:
Tails_ChargingSpindash:			; If still charging the dash...
	tst.w	spindash_counter(a0)
	beq.s	+
	move.w	spindash_counter(a0),d0
	lsr.w	#5,d0
	sub.w	d0,spindash_counter(a0)
	bcc.s	+
	move.w	#0,spindash_counter(a0)
+
    jsr		GetCtrlPressLogical
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	Obj_Tails_Spindash_ResetScr
	move.w	#(AniIDTailsAni_Spindash<<8),anim(a0)
	sfx	sfx_Spindash
	addi.w	#$200,spindash_counter(a0)
	cmpi.w	#$800,spindash_counter(a0)
	blo.s	Obj_Tails_Spindash_ResetScr
	move.w	#$800,spindash_counter(a0)

Obj_Tails_Spindash_ResetScr:
	addq.l	#4,sp
	cmpa.w	#MainCharacter,a0
	bne.s	loc_1C83C	; just don't do it at all, we're removing p2 camera bias anyway
	cmpi.w	#(224/2)-16,(Camera_Y_pos_bias).w
	beq.s	loc_1C83C
	bhs.s	+
	addq.w	#4,(Camera_Y_pos_bias).w
+	subq.w	#2,(Camera_Y_pos_bias).w

loc_1C83C:
	bsr.w	Tails_LevelBound
	bsr.w	AnglePos
	rts
; End of subroutine Tails_UpdateSpindash


; ---------------------------------------------------------------------------
; Subroutine to slow Tails walking up a slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C846:
Tails_SlopeResist:
	move.b	angle(a0),d0
	addi.b	#$60,d0
	cmpi.b	#$C0,d0
	bhs.s	return_1C87A
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	muls.w	#$20,d0
	asr.l	#8,d0
	tst.w	inertia(a0)
	beq.s	return_1C87A
	bmi.s	loc_1C876
	tst.w	d0
	beq.s	+
	add.w	d0,inertia(a0)	; change Tails' $14
+
	rts
; ---------------------------------------------------------------------------

loc_1C876:
	add.w	d0,inertia(a0)

return_1C87A:
	rts
; End of subroutine Tails_SlopeResist

; ---------------------------------------------------------------------------
; Subroutine to return Tails' angle to 0 as he jumps
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C8FA:
Tails_JumpAngle:
	move.b	angle(a0),d0	; get Tails' angle
	beq.s	Tails_JumpFlip	; if already 0, branch
	bpl.s	loc_1C90A	; if higher than 0, branch

	addq.b	#2,d0		; increase angle
	bcc.s	BranchTo_Tails_JumpAngleSet
	moveq	#0,d0

BranchTo_Tails_JumpAngleSet ; BranchTo
	bra.s	Tails_JumpAngleSet
; ===========================================================================

loc_1C90A:
	subq.b	#2,d0		; decrease angle
	bcc.s	Tails_JumpAngleSet
	moveq	#0,d0

; loc_1C910:
Tails_JumpAngleSet:
	move.b	d0,angle(a0)
; End of function Tails_JumpAngle
	; continue straight to Tails_JumpFlip

; ---------------------------------------------------------------------------
; Updates Tails' secondary angle if he's tumbling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C914:
Tails_JumpFlip:
	move.b	flip_angle(a0),d0
	beq.s	return_1C958
	tst.w	inertia(a0)
	bmi.s	Tails_JumpLeftFlip
; loc_1C920:
Tails_JumpRightFlip:
	move.b	flip_speed(a0),d1
	add.b	d1,d0
	bcc.s	BranchTo_Tails_JumpFlipSet
	subq.b	#1,flips_remaining(a0)
	bcc.s	BranchTo_Tails_JumpFlipSet
	move.b	#0,flips_remaining(a0)
	moveq	#0,d0

BranchTo_Tails_JumpFlipSet ; BranchTo
	bra.s	Tails_JumpFlipSet
; ===========================================================================
; loc_1C938:
Tails_JumpLeftFlip:
	tst.b	flip_turned(a0)
	bne.s	Tails_JumpRightFlip
	move.b	flip_speed(a0),d1
	sub.b	d1,d0
	bcc.s	Tails_JumpFlipSet
	subq.b	#1,flips_remaining(a0)
	bcc.s	Tails_JumpFlipSet
	move.b	#0,flips_remaining(a0)
	moveq	#0,d0
; loc_1C954:
Tails_JumpFlipSet:
	move.b	d0,flip_angle(a0)

return_1C958:
	rts
; End of function Tails_JumpFlip

; ---------------------------------------------------------------------------
; Subroutine for Tails to interact with the floor and walls when he's in the air
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1C95A: Tails_Floor:
Tails_DoLevelCollision:
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$C,top_solid_bit(a0)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	move.b	lrb_solid_bit(a0),d5
	move.w	x_vel(a0),d1
	move.w	y_vel(a0),d2
	jsr	(CalcAngle).l
	subi.b	#$20,d0
	andi.b	#$C0,d0
	cmpi.b	#$40,d0
	beq.w	Tails_HitLeftWall
	cmpi.b	#$80,d0
	beq.w	Tails_HitCeilingAndWalls
	cmpi.b	#$C0,d0
	beq.w	Tails_HitRightWall
	bsr.w	CheckLeftWallDist
	tst.w	d1
	bpl.s	+
	sub.w	d1,x_pos(a0)
	move.w	#0,x_vel(a0)	; stop Tails since he hit a wall
+
	bsr.w	CheckRightWallDist
	tst.w	d1
	bpl.s	+
	add.w	d1,x_pos(a0)
	move.w	#0,x_vel(a0)	; stop Tails since he hit a wall
+
	bsr.w	Player_CheckFloor
	tst.w	d1
	bpl.s	return_1CA3A
	move.b	y_vel(a0),d2
	addq.b	#8,d2
	neg.b	d2
	cmp.b	d2,d1
	bge.s	+
	cmp.b	d2,d0
	blt.s	return_1CA3A
+
	add.w	d1,y_pos(a0)
	move.b	d3,angle(a0)
	bsr.w	Player_ResetOnFloor
	move.b	d3,d0
	addi.b	#$20,d0
	andi.b	#$40,d0
	bne.s	loc_1CA18
	move.b	d3,d0
	addi.b	#$10,d0
	andi.b	#$20,d0
	beq.s	loc_1CA0A
	asr	y_vel(a0)
	bra.s	loc_1CA2C
; ===========================================================================

loc_1CA0A:
	move.w	#0,y_vel(a0)
	move.w	x_vel(a0),inertia(a0)
	rts
; ===========================================================================

loc_1CA18:
	move.w	#0,x_vel(a0)	; stop Tails since he hit a wall
	cmpi.w	#$FC0,y_vel(a0)
	ble.s	loc_1CA2C
	move.w	#$FC0,y_vel(a0)

loc_1CA2C:
	move.w	y_vel(a0),inertia(a0)
	tst.b	d3
	bpl.s	return_1CA3A
	neg.w	inertia(a0)

return_1CA3A:
	rts
; ===========================================================================
; loc_1CA3C:
Tails_HitLeftWall:
	bsr.w	CheckLeftWallDist
	tst.w	d1
	bpl.s	Tails_HitCeiling ; branch if distance is positive (not inside wall)
	sub.w	d1,x_pos(a0)
	move.w	#0,x_vel(a0)	; stop Tails since he hit a wall
	move.w	y_vel(a0),inertia(a0)
	rts
; ===========================================================================
; loc_1CA56:
Tails_HitCeiling:
	bsr.w	Player_CheckCeiling
	tst.w	d1
	bpl.s	Tails_HitFloor	; branch if distance is positive (not inside ceiling)
	sub.w	d1,y_pos(a0)
	tst.w	y_vel(a0)
	bpl.s	return_1CA6E
	move.w	#0,y_vel(a0)	; stop Tails in y since he hit a ceiling

return_1CA6E:
	rts
; ===========================================================================
; loc_1CA70:
Tails_HitFloor:
	tst.w	y_vel(a0)
	bmi.s	return_1CA96
	bsr.w	Player_CheckFloor
	tst.w	d1
	bpl.s	return_1CA96
	add.w	d1,y_pos(a0)
	move.b	d3,angle(a0)
	bsr.w	Player_ResetOnFloor
	move.w	#0,y_vel(a0)
	move.w	x_vel(a0),inertia(a0)

return_1CA96:
	rts
; ===========================================================================
; loc_1CA98:
Tails_HitCeilingAndWalls:
	bsr.w	CheckLeftWallDist
	tst.w	d1
	bpl.s	+
	sub.w	d1,x_pos(a0)
	move.w	#0,x_vel(a0)	; stop Tails since he hit a wall
+
	bsr.w	CheckRightWallDist
	tst.w	d1
	bpl.s	+
	add.w	d1,x_pos(a0)
	move.w	#0,x_vel(a0)	; stop Tails since he hit a wall
+
	bsr.w	Player_CheckCeiling
	tst.w	d1
	bpl.s	return_1CAF2
	sub.w	d1,y_pos(a0)
	move.b	d3,d0
	addi.b	#$20,d0
	andi.b	#$40,d0
	bne.s	loc_1CADC
	move.w	#0,y_vel(a0)	; stop Tails in y since he hit a ceiling
	rts
; ===========================================================================

loc_1CADC:
	move.b	d3,angle(a0)
	bsr.w	Player_ResetOnFloor
	move.w	y_vel(a0),inertia(a0)
	tst.b	d3
	bpl.s	return_1CAF2
	neg.w	inertia(a0)

return_1CAF2:
	rts
; ===========================================================================
; loc_1CAF4:
Tails_HitRightWall:
	bsr.w	CheckRightWallDist
	tst.w	d1
	bpl.s	Tails_HitCeiling2
	add.w	d1,x_pos(a0)
	move.w	#0,x_vel(a0)	; stop Tails since he hit a wall
	move.w	y_vel(a0),inertia(a0)
	rts
; ===========================================================================
; identical to Tails_HitCeiling...
; loc_1CB0E:
Tails_HitCeiling2:
	bsr.w	Player_CheckCeiling
	tst.w	d1
	bpl.s	Tails_HitFloor2
	sub.w	d1,y_pos(a0)
	tst.w	y_vel(a0)
	bpl.s	return_1CB26
	move.w	#0,y_vel(a0)	; stop Tails in y since he hit a ceiling

return_1CB26:
	rts
; ===========================================================================
; identical to Tails_HitFloor...
; loc_1CB28:
Tails_HitFloor2:
	tst.w	y_vel(a0)
	bmi.s	return_1CB4E
	bsr.w	Player_CheckFloor
	tst.w	d1
	bpl.s	return_1CB4E
	add.w	d1,y_pos(a0)
	move.b	d3,angle(a0)
	bsr.w	Player_ResetOnFloor
	move.w	#0,y_vel(a0)
	move.w	x_vel(a0),inertia(a0)

return_1CB4E:
	rts
; End of function Tails_DoLevelCollision

; ---------------------------------------------------------------------------
; Subroutine to reset Tails' mode when he lands on the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1CB5C:
Tails_ResetOnFloor_Part2:
	tst.b	pinball_mode(a0)
	bne.s	Tails_ResetOnFloor_Part3
	btst	#2,status(a0)
	beq.s	Tails_ResetOnFloor_Part3
	bclr	#2,status(a0)
	jsr		ResetHeight_a0
	move.b	#AniIDTailsAni_Walk,anim(a0)	; use running/walking/standing animation
	subq.w	#1,y_pos(a0)	; move Tails up 1 pixel so the increased height doesn't push him slightly into the ground
; loc_1CB80:
Tails_ResetOnFloor_Part3:
	bclr	#1,status(a0)
	bclr	#5,status(a0)
	bclr	#4,status(a0)
	move.b	#0,jumping(a0)
	move.b	#0,double_jump_flag(a0)
	move.w	#0,(Chain_Bonus_counter).w
	move.b	#0,flip_angle(a0)
	move.b	#0,flip_turned(a0)
	move.b	#0,flips_remaining(a0)
	move.w	#0,(Tails_Look_delay_counter).w
	cmpi.b	#AniIDTailsAni_Hang2,anim(a0)
	bne.s	return_1CBC4
	move.b	#AniIDTailsAni_Walk,anim(a0)

return_1CBC4:
	rts
; End of subroutine Tails_ResetOnFloor

; ===========================================================================
; ---------------------------------------------------------------------------
; Tails when he gets hurt
; ---------------------------------------------------------------------------
; loc_1CBC6:
Obj_Tails_Hurt:
	cmpa.w	#MainCharacter,a0
	bne.s	Obj02_Hurt_Normal
	tst.w	(Debug_mode_flag).w
	beq.s	Obj02_Hurt_Normal
	btst	#button_B,(Ctrl_1_Press).w
	beq.s	Obj02_Hurt_Normal
	move.w	#1,(Debug_placement_mode).w
	clr.b	(Control_Locked).w
	rts
; ---------------------------------------------------------------------------
; loc_1B13A:
Obj02_Hurt_Normal:
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	loc_156D6
	lea	(MainCharacter).w,a1
	clr.b	obj_control(a1)
	bset	#1,status(a1)
	clr.w	(Flying_carrying_Sonic_flag).w

loc_156D6:
	jsr	(ObjectMove).l
	addi.w	#$30,y_vel(a0)
	btst	#6,status(a0)
	beq.s	+
	subi.w	#$20,y_vel(a0)
+
	cmpi.w	#-$100,(Camera_Min_Y_pos).w
	bne.s	+
	andi.w	#$7FF,y_pos(a0)
+
	bsr.w	Tails_HurtStop
	bsr.w	Tails_LevelBound
	jsr		P1_RecordPos
	bsr.w	Tails_Animate
	bsr.w	LoadTailsDynPLC
	jmp	(DisplaySprite).l
; ===========================================================================
; loc_1CC08:
Tails_HurtStop:
	lea	0.w,a2
	move.w	(Tails_Max_Y_pos).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0
	jlt 	KillCharacter
	bsr.w	Tails_DoLevelCollision
	btst	#1,status(a0)
	bne.s	return_1CC4E
	moveq	#0,d0
	move.w	d0,y_vel(a0)
	move.w	d0,x_vel(a0)
	move.w	d0,inertia(a0)
	move.b	d0,obj_control(a0)
	move.b	#AniIDTailsAni_Walk,anim(a0)
	move.b	#2,routine(a0)	; => Obj_Tails_Control
	move.w	#$78,invulnerable_time(a0)
	move.b	#0,spindash_flag(a0)

return_1CC4E:
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Tails when he dies.
; ---------------------------------------------------------------------------

; loc_1CC50:
Obj_Tails_Dead:
	cmpa.w	#MainCharacter,a0
	bne.s	+
	tst.w	(Debug_mode_flag).w
	beq.s	+
	btst	#button_B,(Ctrl_1_Press).w
	beq.s	+
	move.w	#1,(Debug_placement_mode).w
	clr.b	(Control_Locked).w
	rts
+
	tst.b	(Flying_carrying_Sonic_flag).w
	beq.s	loc_157C8
	lea	    (MainCharacter).w,a1
	clr.b	obj_control(a1)
	bset	#1,status(a1)
	clr.w	(Flying_carrying_Sonic_flag).w

loc_157C8:
	jsr 	CheckGameOver
	jsr	    (ObjectMoveAndFall).l
	jsr		P1_RecordPos
	bsr.w	Tails_Animate
	bsr.w	LoadTailsDynPLC
	jmp	    (DisplaySprite).l

Obj_Tails_Finished:
    jmp     Obj_Sonic_Finished

; ===========================================================================
; ---------------------------------------------------------------------------
; Tails when the level is restarted
; ---------------------------------------------------------------------------
; loc_1CCEC:
Obj_Tails_ResetLevel:
	tst.b	(Time_Over_flag).w

    if gameRevision=0
	bne.s	Obj_Tails_ResetLevel_Part3
    else
	beq.s	Obj_Tails_ResetLevel_Part2
	tst.b	(Time_Over_flag_2P).w
	beq.s	Obj_Tails_ResetLevel_Part3
	move.w	#0,restart_countdown(a0)
	clr.b	(Update_HUD_timer).w
	clr.b	(Update_HUD_timer_2P).w
	move.b	#8,routine(a0)
	rts
    endif

; ---------------------------------------------------------------------------
Obj_Tails_ResetLevel_Part2:
	tst.b	(Time_Over_flag_2P).w
	beq.s	Obj_Tails_ResetLevel_Part3
	move.w	#0,restart_countdown(a0)
	move.l	#Obj_TimeOver,(TimeOver_TimeText+id).w ; load Obj_GameOver
	move.l	#Obj_TimeOver,(TimeOver_OverText+id).w ; load Obj_GameOver
	move.b	#2,(TimeOver_TimeText+mapping_frame).w
	move.b	#3,(TimeOver_OverText+mapping_frame).w
	move.w	a0,(TimeOver_TimeText+parent).w
	bra.s	Obj_Tails_Finished
; ---------------------------------------------------------------------------
Obj_Tails_ResetLevel_Part3:
	move.b	#0,(Scroll_lock_P2).w
	move.b	#$A,routine(a0)	; => Obj_Tails_Respawning
	move.w	(Saved_x_pos_2P).w,x_pos(a0)
	move.w	(Saved_y_pos_2P).w,y_pos(a0)
	move.w	(Saved_art_tile_2P).w,art_tile(a0)
	move.w	(Saved_Solid_bits_2P).w,top_solid_bit(a0)
	clr.w	(Ring_count_2P).w
	clr.b	(Extra_life_flags_2P).w
	move.b	#0,obj_control(a0)
	move.b	#5,anim(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#2,status(a0)
	move.w	#0,move_lock(a0)

return_1CD8E:
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tails when he's offscreen and waiting for the level to restart
; ---------------------------------------------------------------------------
; loc_1CD90:
Obj_Tails_Gone:
	tst.w	restart_countdown(a0)
	beq.s	+
	subq.w	#1,restart_countdown(a0)
	bne.s	+
	move.w	#1,(Level_Inactive_flag).w
+
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tails when he's waiting for the camera to scroll back to where he respawned
; ---------------------------------------------------------------------------
; loc_1CDA4:
Obj_Tails_Respawning:
	tst.w	(Camera_X_pos_diff_P2).w
	bne.s	+
	tst.w	(Camera_Y_pos_diff_P2).w
	bne.s	+
	move.b	#2,routine(a0)
+
	bsr.w	Tails_Animate
	bsr.w	LoadTailsDynPLC
	jmp	(DisplaySprite).l
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to animate Tails' sprites
; See also: AnimateSprite and Sonic_Animate
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1CDC4:
Tails_Animate:
	lea	(TailsAniData).l,a1
; loc_1CDCA:
Tails_Animate_Part2:
	moveq	#0,d0
	move.b	anim(a0),d0
	cmp.b	next_anim(a0),d0	; has animation changed?
	beq.s	TAnim_Do		; if not, branch
	move.b	d0,next_anim(a0)	; set to next animation
	move.b	#0,anim_frame(a0)	; reset animation frame
	move.b	#0,anim_frame_duration(a0)	; reset frame duration
	bclr	#5,status(a0)
; loc_1CDEC:
TAnim_Do:
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),d0
	bmi.s	TAnim_WalkRunZoom	; if animation is walk/run/roll/jump, branch
	move.b	status(a0),d1
	andi.b	#1,d1
	andi.b	#$FC,render_flags(a0)
	or.b	d1,render_flags(a0)
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	TAnim_Delay			; if time remains, branch
	move.b	d0,anim_frame_duration(a0)	; load frame duration
; loc_1CE12:
TAnim_Do2:
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	cmpi.b	#$F0,d0
	bhs.s	TAnim_End_FF		; if animation is complete, branch
; loc_1CE22:
TAnim_Next:
	move.b	d0,mapping_frame(a0)	; load sprite number
	addq.b	#1,anim_frame(a0)	; go to next frame
; return_1CE2A:
TAnim_Delay:
	rts
; ===========================================================================
; loc_1CE2C:
TAnim_End_FF:
	addq.b	#1,d0		; is the end flag = $FF ?
	bne.s	TAnim_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bra.s	TAnim_Next
; ===========================================================================
; loc_1CE3C:
TAnim_End_FE:
	addq.b	#1,d0		; is the end flag = $FE ?
	bne.s	TAnim_End_FD	; if not, branch
	move.b	2(a1,d1.w),d0	; read the next byte in the script
	sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
	sub.b	d0,d1
	move.b	1(a1,d1.w),d0	; read sprite number
	bra.s	TAnim_Next
; ===========================================================================
; loc_1CE50:
TAnim_End_FD:
	addq.b	#1,d0			; is the end flag = $FD ?
	bne.s	TAnim_End		; if not, branch
	move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
; return_1CE5A:
TAnim_End:
	rts
; ===========================================================================
; loc_1CE5C:
TAnim_WalkRunZoom: ; a0=character
	; note: for some reason SAnim_WalkRun doesn't need to do this here...
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from Tails' frame duration
	bpl.s	TAnim_Delay			; if time remains, branch

	addq.b	#1,d0		; is the end flag = $FF ?
	bne.w	TAnim_Roll	; if not, branch
	moveq	#0,d0		; is animation walking/running?
	move.b	flip_angle(a0),d0	; if not, branch
	bne.w	TAnim_Tumble
	moveq	#0,d1
	move.b	angle(a0),d0	; get Tails' angle
	bmi.s	+
	beq.s	+
	subq.b	#1,d0
+
	move.b	status(a0),d2
	andi.b	#1,d2		; is Tails mirrored horizontally?
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
	bne.w	TAnim_Push
	lsr.b	#4,d0		; divide angle by 16
	andi.b	#6,d0		; angle must be 0, 2, 4 or 6
	mvabs.w	inertia(a0),d2	; get Tails' "speed" for animation purposes
    if status_sec_isSliding = 7
	tst.b	status_secondary(a0)
	bpl.w	+
    else
	btst	#status_sec_isSliding,status_secondary(a0)
	beq.w	+
    endif
	add.w	d2,d2
+	; @nomodspeed
	lea	(TailsAni_HaulAss).l,a1
	cmpi.w	#$700,d2		; is Tails going really fast?
	bhs.s	+				; if yes, branch
	lea	(TailsAni_Run).l,a1
	cmpi.w	#$600,d2		; is Tails going pretty fast?
	bhs.s	+	; if not, branch
	lea	(TailsAni_Walk).l,a1
	add.b	d0,d0
+	; @running
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
	bpl.s	returnT_1B4AC
	neg.w	d2
	addi.w	#$800,d2
	bpl.s	+
	moveq	#0,d2
+
	lsr.w	#8,d2
	move.b	d2,anim_frame_duration(a0)	; modify frame duration
	addq.b	#1,anim_frame(a0)		; modify frame number

returnT_1B4AC:
	rts
; ===========================================================================
; loc_1CF08
TAnim_Tumble:
	move.b	flip_angle(a0),d0
	moveq	#0,d1
	move.b	status(a0),d2
	andi.b	#1,d2
	bne.s	TAnim_Tumble_Left

	andi.b	#$FC,render_flags(a0)
	addi.b	#$B,d0
	divu.w	#$16,d0
	addi.b	#frT_Tumble1,d0
	move.b	d0,mapping_frame(a0)
	move.b	#0,anim_frame_duration(a0)
	rts
; ===========================================================================
; loc_1CF36
TAnim_Tumble_Left:
	andi.b	#$FC,render_flags(a0)
	tst.b	flip_turned(a0)
	beq.s	+
	ori.b	#1,render_flags(a0)
	addi.b	#$B,d0
	bra.s	++
; ===========================================================================
+
	ori.b	#3,render_flags(a0)
	neg.b	d0
	addi.b	#$8F,d0
+
	divu.w	#$16,d0
	addi.b	#frT_Tumble1,d0
	move.b	d0,mapping_frame(a0)
	move.b	#0,anim_frame_duration(a0)
	rts

; ===========================================================================
; loc_1CF6E:
TAnim_Roll:
	addq.b	#1,d0		; is the end flag = $FE ?
	bne.s	TAnim_GetTailFrame	; if not, branch
	mvabs.w	inertia(a0),d2
	lea	(TailsAni_Roll2).l,a1
	cmpi.w	#$600,d2
	bhs.s	+
	lea	(TailsAni_Roll).l,a1
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
	bra.w	TAnim_Do2
; ===========================================================================
; loc_1CFB2
TAnim_Push:
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
	lea	(TailsAni_Push).l,a1
	move.b	status(a0),d1
	andi.b	#1,d1
	andi.b	#$FC,render_flags(a0)
	or.b	d1,render_flags(a0)
	bra.w	TAnim_Do2

; ===========================================================================
; loc_1CFE4:
TAnim_GetTailFrame:
	move.w	x_vel(a2),d1
	move.w	y_vel(a2),d2
	jsr	(CalcAngle).l
	moveq	#0,d1
	move.b	status(a0),d2
	andi.b	#1,d2
	bne.s	loc_1D002
	not.b	d0
	bra.s	loc_1D006
; ===========================================================================

loc_1D002:
	addi.b	#$80,d0

loc_1D006:
	addi.b	#$10,d0
	bpl.s	+
	moveq	#3,d1
+
	andi.b	#$FC,render_flags(a0)
	eor.b	d1,d2
	or.b	d2,render_flags(a0)
	lsr.b	#3,d0
	andi.b	#$C,d0
	move.b	d0,d3
	lea	(Obj_TailsTailsAni_Directional).l,a1
	move.b	#3,anim_frame_duration(a0)
	bsr.w	TAnim_Do2
	add.b	d3,mapping_frame(a0)
	rts
; ===========================================================================

	include	"animations/Tails.asm"

; ===========================================================================

; ---------------------------------------------------------------------------
; Tails' Tails pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1D184:
LoadTailsTailsDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0	; load frame number
		bsr.w	LoadTailsTailsMap

LoadTailsTailsDynPLC_Part2:
		cmp.b	dplc_prev_frame(a0),d0
		beq.s	.nochange
		move.b	d0,dplc_prev_frame(a0)
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.superplc
		lea	(MapRUnc_TailsTails).l,a2
;		bra.s	.cont
;	.superplc:
;		lea	(MapRUnc_SuperTailsTails).l,a2
;	.cont:
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	.nochange
		jsr		TailsTailsDPLC_ArtTileSet
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.superart
		move.l	#ArtUnc_TailsTails,d6
;		bra.s	.readentry
;	.superart:
;		move.l	#ArtUnc_SuperTailsTails,d6

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
; End of function LoadTailsTailsDynPLC

LoadTailsTailsMap:
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.super
;	.normal:
		cmpi.l	#MapUnc_TailsTails,mappings(a0)
		beq.s	.skip
		move.l	#MapUnc_TailsTails,mappings(a0)
;		bra.s	.skip
;	.super:
;		cmpi.l	#MapUnc_SuperTailsTails,mappings(a0)
;		beq.s	.skip
;		move.l	#MapUnc_SuperTailsTails,mappings(a0)
	.skip:
		rts

TailsTailsDPLC_ArtTileSet:
	move.w	parent(a0),a1
	cmpa.w	#MainCharacter,a1
	bne.s	.sidekick
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_Sonic+$10),d4
	rts
.sidekick:
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_Tails+$10),d4
	rts

; ---------------------------------------------------------------------------
; Tails pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1D1AC:
LoadTailsDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0	; load frame number
		bsr.w	LoadTailsMap

LoadTailsDynPLC_Part2:
		cmp.b	dplc_prev_frame(a0),d0
		beq.s	.nochange
		move.b	d0,dplc_prev_frame(a0)
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.superplc
		lea	(MapRUnc_Tails).l,a2
;		bra.s	.cont
;	.superplc:
;		lea	(MapRUnc_SuperTails).l,a2
;	.cont:
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	.nochange
		jsr		DPLC_ArtTileSet
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.superart
		move.l	#ArtUnc_Tails,d6
;		bra.s	.readentry
;	.superart:
;		move.l	#ArtUnc_SuperTails,d6

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
; End of function LoadTailsTailsDynPLC

LoadTailsMap:
;		tst.b	(Super_Sonic_flag).w
;		bne.s	.super
;	.normal:
		cmpi.l	#MapUnc_Tails,mappings(a0)
		beq.s	.skip
		move.l	#MapUnc_Tails,mappings(a0)
;		bra.s	.skip
;	.super:
;		cmpi.l	#MapUnc_SuperTails,mappings(a0)
;		beq.s	.skip
;		move.l	#MapUnc_SuperTails,mappings(a0)
	.skip:
		rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 05 - Tails' tails
; ----------------------------------------------------------------------------
; Sprite_1D200:
Obj_TailsTails:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj_TailsTails_Index(pc,d0.w),d1
	jmp	Obj_TailsTails_Index(pc,d1.w)
; ===========================================================================
; off_1D20E: Obj_TailsTails_States:
Obj_TailsTails_Index:	offsetTable
		offsetTableEntry.w Obj_TailsTails_Init	; 0
		offsetTableEntry.w Obj_TailsTails_Main	; 2
; ===========================================================================

Obj_TailsTails_parent_prev_anim = objoff_30

; loc_1D212
Obj_TailsTails_Init:
	addq.b	#2,routine(a0) ; => Obj_TailsTails_Main
	move.l	#MapUnc_TailsTails,mappings(a0)
	movea.w	parent(a0),a2 ; a2=character
	move.w	art_tile(a2),art_tile(a0)
	add.w	#make_art_tile($10,0,0),art_tile(a0)
	move.w	#prio(2),priority(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#4,render_flags(a0)

; loc_1D23A:
Obj_TailsTails_Main:
	movea.w	parent(a0),a2 ; a2=character
	move.b	angle(a2),angle(a0)
	move.b	status(a2),status(a0)
	move.w	x_pos(a2),x_pos(a0)
	move.w	y_pos(a2),y_pos(a0)
	andi.w	#drawing_mask,art_tile(a0)
	tst.w	art_tile(a2)
	bpl.s	+
	ori.w	#high_priority,art_tile(a0)
+
	moveq	#0,d0
	move.b	anim(a2),d0
	btst	#5,status(a2)		; is Tails about to push against something?
	beq.s	+			; if not, branch
	cmpi.b	#frT_Push1,mapping_frame(a2)	; Is Tails in his pushing animation yet?
	blo.s	+			; If not yet, branch, and do not set tails' tail pushing animation
	cmpi.b	#frT_Push4,mapping_frame(a2)	; ''
	bhi.s	+			; ''
	moveq	#4,d0
+
	; This is here so Obj_TailsTailsAni_Flick works
	; It changes anim(a0) itself, so we don't want the below code changing it as well
	cmp.b	Obj_TailsTails_parent_prev_anim(a0),d0	; Did Tails' animation change?
	beq.s	.display
	move.b	d0,Obj_TailsTails_parent_prev_anim(a0)
	move.b	Obj_TailsTailsAniSelection(pc,d0.w),anim(a0)	; If so, update Tails' tails' animation
; loc_1D288:
.display:
	lea	(Obj_TailsTailsAniData).l,a1
	bsr.w	Tails_Animate_Part2
	bsr.w	LoadTailsTailsDynPLC
	movea.w	parent(a0),a1			; Move Tails' register to a1
	move.w	invulnerable_time(a1),d0	; Move Tails' invulnerable time to d0
	beq.s	.display2			; Is invulnerable_time 0?  If so, always display his tails
	addq.w	#1,d0				; Make d0 the same as old invulnerable_time's d0
	lsr.w	#3,d0				; Shift bits to the right 3 times
	bcc.s	.return				; If the Carry bit is not set, branch and do not display Tails' tails

.display2:
	jmp	(DisplaySprite).l               ; Display Tails' tails
.return:
	rts
; ===========================================================================
; animation master script table for the tails
; chooses which animation script to run depending on what Tails is doing
; byte_1D29E:
Obj_TailsTailsAniSelection:
	dc.b	0,0	; TailsAni_Walk,Run	->
	dc.b	3	; TailsAni_Roll		-> Directional
	dc.b	$E	; TailsAni_Roll2	-> Directional Fast
	dc.b	9	; TailsAni_Push		-> Pushing
	dc.b	1	; TailsAni_Wait		-> Swish
	dc.b	9	; TailsAni_Balance	-> Pushing
	dc.b	2	; TailsAni_LookUp	-> Flick
	dc.b	1	; TailsAni_Duck		-> Swish
	dc.b	7	; TailsAni_Spindash	-> Spindash
	dc.b	0,0,0	; TailsAni_Dummy1,2,3	->
	dc.b	8	; TailsAni_Stop		-> Skidding
	dc.b	0,0	; TailsAni_Float,2	->
	dc.b	0	; TailsAni_Spring	->
	dc.b	0	; TailsAni_Hang		->
	dc.b	0,0	; TailsAni_Blink,2	->
	dc.b	$A	; TailsAni_Hang2	-> Hanging
	dc.b	0	; TailsAni_Bubble	->
	dc.b	0,0,0,0	; TailsAni_Death,2,3,4	->
	dc.b	0,0	; TailsAni_Hurt,Slide	->
	dc.b	0	; TailsAni_Blank	->
	dc.b	0,0	; TailsAni_Dummy4,5	->
	dc.b	0	; TailsAni_HaulAss	->
	dc.b	$B,$C,$D,$B,$C	; flying animations (fly, fly2, tired, carry, carryup)
	dc.b	3	; TailsAni_AirRoll	-> Directional
	dc.b	0	; TailsAni_Fall		-> Nothing
	dc.b	0	; TailsAni_Victory	-> nothing
	dc.b	$D	; TailsAni_CarryTired	-> tired
	dc.b	0,0,0,0	; four Swim animations
	even

	include	"animations/Tails's Tails.asm"