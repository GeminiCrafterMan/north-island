Obj_FGObject:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_FGObject_Index(pc,d0.w),d1
		jmp		Obj_FGObject_Index(pc,d1.w)
; ===========================================================================
Obj_FGObject_Index:	offsetTable
	offsetTableEntry.w	Obj_FGObject_Main
	offsetTableEntry.w	Obj_FGObject_Display
; objoff_2A = original X pos
; objoff_2C = original y pos
; ===========================================================================

Obj_FGObject_Main:
		addq.b	#2,routine(a0)
		move.l	#MapUnc_FGTree,mappings(a0) ; Add mappings here!
		move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0) ; Tweak this to change VRAM location tied to object!
		move.b	#$14,render_flags(a0) ; This must always be at least $10! The $10 in this ensures it displays in front of all level art.
		move.b	#32,width_pixels(a0)
		move.b	#$40,y_radius(a0)
		move.w	#prio(0),priority(a0) ; This ensures it displays in front of almost ALL sprites.
		move.w	x_pos(a0),objoff_2A(a0) ; Move this here to ensure proper sprite deletion.
		move.w	y_pos(a0),objoff_2C(a0) ; Move this here to ensure proper sprite deletion.

Obj_FGObject_Display:
	;-- Thank you based pylon --
		move.w	objoff_2A(a0), d1 ; Store the original X position in d1....
		move.w	d1,d2 ; ... and make sure to allow us to readd it in d2 so we don't assume we are at X = 0.
		subi.w	#$A0,d1 ; Subtract A0 from d1.
		sub.w	(Camera_X_pos).w,d1 ; Subtract the current screen position from d1.
		asr.w	#1,d1 ; Divide d1 by 2. (Tweak this to get different scroll rates!)
		add.w	d2,d1 ; Add the base X position to our offset.
		move.w	d1,x_pos(a0) ; Here's our new X position!
	; y pos stuff i think
		move.w	objoff_2C(a0), d1 ; Store the original X position in d1....
		move.w	d1,d2 ; ... and make sure to allow us to readd it in d2 so we don't assume we are at X = 0.
		subi.w	#$A0,d1 ; Subtract A0 from d1.
		sub.w	(Camera_Y_pos).w,d1 ; Subtract the current screen position from d1.
		asr.w	#1,d1 ; Divide d1 by 2. (Tweak this to get different scroll rates!)
		add.w	d2,d1 ; Add the base X position to our offset.
		move.w	d1,y_pos(a0) ; Here's our new X position!
; sonic 2 can suck my fuckin balls bro
		move.w	objoff_2A(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		jhi		DeleteObject
		jmp		(DisplaySprite).l
MapUnc_FGTree:	BINCLUDE	"mappings/sprite/Obj_FGObject_a.bin"