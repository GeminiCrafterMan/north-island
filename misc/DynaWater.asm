; ===========================================================================
; Water Palette Loading for Sonic 2
; Converted from S1 to S2 by Gemini0
; Created by BunniDev with ProjectFM, Gemini0 and RandomName's help
; ===========================================================================
; ---------------------------------------------------------------------------
; Initial palette shift loading
; Only run this at level start!
; ---------------------------------------------------------------------------

loadWaterShift:
		moveq	#0,d0
		move.b  (Current_Zone).w,d0
		add.w	d0,d0
		add.w	d0,d0
		add.b   (Current_Act).w,d0
		add.w   d0,d0
		add.w	d0,d0
		move.l	waterValTable(pc,d0.w),(waterValues).w
		bra.w	updateWaterShift

; ===========================================================================
; Per act version (Gotta be 2 acts because even (Also I'm sure it'd be more useful))
waterValTable: zoneOrderedTable 2,8	; why did it have to be set up like this, this makes zero sense
	; Entry format: blue<<3, zero, red<<3, green<<3
	; EHZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; Zone 1
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; WZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; Zone 3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; MTZ, have to have four acts because it's technically two zones
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; WFZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; HTZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; HPZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; Zone 9
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; OOZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; MCZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; CNZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; CPZ	; Shit's pink!
		zoneTableEntry.b	$4<<3, 0, $4<<3, -$2<<3
		zoneTableEntry.b	$4<<3, 0, $4<<3, -$2<<3
	; DEZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; ARZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	; SCZ
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
		zoneTableEntry.b	0, 0, -$2<<3, -$2<<3
	zoneTableEnd
; ===========================================================================
; ---------------------------------------------------------------------------
; Updates water palette
; Should be run every frame (Necessary for palette cycles)
; ---------------------------------------------------------------------------

updateWaterShift:
		moveq	#$40/2-1,d3		; update all colors (loop iterates through 2 colors at once)
		lea	(waterValues).w,a1	; get water values
		move.w	(a1)+,d0		; get blue into d0
		spl		d7				; get blue sign (0 - positive, $FF - negative)
		ext.w	d7				; extend sign to word
		move.b	(a1)+,d1		; get red into d1
		spl		d7				; get red sign (0 - positive, $FF - negative)
		and.w	#$E0E<<3,d7 	; get red and blue clamp values
		move.w	d7,d4			; copy it to low word of d4
		swap	d4 				; swap d4 words
		move.w	d7,d4 			; copy it to high word of d4
		move.b	(a1)+,d2		; get green
		spl		d7				; get green sign (0 - positive, $FF - negative)
		and.w	#$E<<3,d7		; get green clamp value
		move.w	d7,d5			; copy it to low word of d5
		swap	d5				; swap d5 words
		move.w	d7,d5			; copy it to high word of d5
		lea	(Normal_palette).w,a1	; load normal palette into a1
		lea	(Underwater_palette).w,a2	; load water palette into a2
	.colorLoop:
		move.l	(a1)+,d7		; get 2 colors
		move.l	d7,d6			; copy colors to d6
		and.l	#$0E0E0E0E,d7	; get only greens and reds
		lsl.l	#3,d7			; shift d7, so colors will range from $10101010(and 0) to $70707070
	.blue:
		add.w	d0,d7			; add/sub blue value
		bpl.s	.red			; if value is in range, branch
		and.w	#$FF,d7			; clear high byte of the word
		add.w	d4,d7			; apply blue and red clamp value
		sub.b	d4,d7			; udno red clamp value applying
	.red:
		add.b	d1,d7			; add/sub red value
		bpl.s	.blue2			; if value is in range, branch
		move.b	d4,d7			; apply red clamp value
	.blue2:
		swap	d7				; swap to another color
		; same thing again
		add.w	d0,d7
		bpl.s	.red2
		and.w	#$FF,d7
		add.w	d4,d7
		sub.b	d4,d7
	.red2:
		add.b	d1,d7
		bpl.s	.green
		move.b	d4,d7
	.green:
		lsr.l	#3,d7			; shift d7 back to its initial position
		; d6 is copy of those 2 colors
		and.l	#$00E000E0,d6	; get only greens
		lsr.l	#1,d6			; shift d6, so colors will range from $00100010(and 0) to $00700070
		add.b	d2,d6			; add green value	
		bpl.s	.green2			; if value is in range, branch
		move.b	d5,d6			; apply green clamp value
	.green2:
		swap	d6				; swap to another color	
		; same thing again
		add.b	d2,d6
		bpl.s	.nextColor
		move.b	d5,d6
	.nextColor:
		add.l	d6,d6			; shift d6 back to its initial position
		add.l	d6,d7			; combine all colors
		swap	d7				; swap them back
		move.l	d7,(a2)+		; copy colors to water palette
		dbf	d3,.colorLoop
	.waterShiftEnd:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Updates water palette
; Should be run every frame (Necessary for palette cycles)
; ---------------------------------------------------------------------------

updateWaterShiftForFade:
		moveq	#$40/2-1,d3		; update all colors (loop iterates through 2 colors at once)
		lea	(waterValues).w,a1	; get water values
		move.w	(a1)+,d0		; get blue into d0
		spl		d7				; get blue sign (0 - positive, $FF - negative)
		ext.w	d7				; extend sign to word
		move.b	(a1)+,d1		; get red into d1
		spl		d7				; get red sign (0 - positive, $FF - negative)
		and.w	#$E0E<<3,d7 	; get red and blue clamp values
		move.w	d7,d4			; copy it to low word of d4
		swap	d4 				; swap d4 words
		move.w	d7,d4 			; copy it to high word of d4
		move.b	(a1)+,d2		; get green
		spl		d7				; get green sign (0 - positive, $FF - negative)
		and.w	#$E<<3,d7		; get green clamp value
		move.w	d7,d5			; copy it to low word of d5
		swap	d5				; swap d5 words
		move.w	d7,d5			; copy it to high word of d5
		lea	(Normal_palette).w,a1	; load normal palette into a1
		lea	(Underwater_target_palette).w,a2	; load water palette into a2
	.colorLoop:
		move.l	(a1)+,d7		; get 2 colors
		move.l	d7,d6			; copy colors to d6
		and.l	#$0E0E0E0E,d7	; get only greens and reds
		lsl.l	#3,d7			; shift d7, so colors will range from $10101010(and 0) to $70707070
	.blue:
		add.w	d0,d7			; add/sub blue value
		bpl.s	.red			; if value is in range, branch
		and.w	#$FF,d7			; clear high byte of the word
		add.w	d4,d7			; apply blue and red clamp value
		sub.b	d4,d7			; udno red clamp value applying
	.red:
		add.b	d1,d7			; add/sub red value
		bpl.s	.blue2			; if value is in range, branch
		move.b	d4,d7			; apply red clamp value
	.blue2:
		swap	d7				; swap to another color
		; same thing again
		add.w	d0,d7
		bpl.s	.red2
		and.w	#$FF,d7
		add.w	d4,d7
		sub.b	d4,d7
	.red2:
		add.b	d1,d7
		bpl.s	.green
		move.b	d4,d7
	.green:
		lsr.l	#3,d7			; shift d7 back to its initial position
		; d6 is copy of those 2 colors
		and.l	#$00E000E0,d6	; get only greens
		lsr.l	#1,d6			; shift d6, so colors will range from $00100010(and 0) to $00700070
		add.b	d2,d6			; add green value	
		bpl.s	.green2			; if value is in range, branch
		move.b	d5,d6			; apply green clamp value
	.green2:
		swap	d6				; swap to another color	
		; same thing again
		add.b	d2,d6
		bpl.s	.nextColor
		move.b	d5,d6
	.nextColor:
		add.l	d6,d6			; shift d6 back to its initial position
		add.l	d6,d7			; combine all colors
		swap	d7				; swap them back
		move.l	d7,(a2)+		; copy colors to water palette
		dbf	d3,.colorLoop
	.waterShiftEnd:
		rts
; ===========================================================================