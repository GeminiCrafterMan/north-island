; ----------------------------------------------------------------------------
; Object 62 - Twisted Ramp from S3K. Very easy to port.
; ----------------------------------------------------------------------------
Obj_TwistedRamp:
		lea	(MainCharacter).w,a1
		bsr.s	.cont1
		lea	(Sidekick).w,a1
		bsr.s	.cont1
        jmp     MarkObjGone

; =============== S U B R O U T I N E =======================================
; sub_24D9A
.cont1:
		btst	#1,status(a1)
		bne.w	.ret
		move.w	x_pos(a1),d0
		addi.w	#$10,d0
		sub.w	x_pos(a0),d0
		bcs.w	.ret
		cmpi.w	#$20,d0
		bge.w	.ret
		move.w	y_pos(a1),d0
		sub.w	y_pos(a0),d0
		cmpi.w	#-$14,d0
		blt.s	.ret
		cmpi.w	#$20,d0
		bgt.s	.ret
		tst.b	obj_control(a1)
		bne.s	.ret
		btst	#0,status(a0)
		bne.s	.cont2
		cmpi.w	#$400,x_vel(a1)
		blt.s	.ret
		addi.w	#$400,x_vel(a1)
		bra.s	.cont3
; ---------------------------------------------------------------------------
; loc_24DEE
.cont2:
		cmpi.w	#-$400,x_vel(a1)
		bgt.s	.ret
		subi.w	#$400,x_vel(a1)
; loc_24DFC
.cont3:
		move.w	#-$700,y_vel(a1)
		bset	#1,status(a1)
		move.b	#2,routine(a1)
		move.w	#1,inertia(a1)
		move.b	#1,flip_angle(a1)
		move.b	#0,anim(a1)
		move.b	#0,flips_remaining(a1)
		move.b	#4,flip_speed(a1)
		move.b	#5,flip_turned(a1)
; locret_24E32
.ret:
		rts
; End of object Obj_TwistedRamp