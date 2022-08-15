KnucklesAniData:dc.w KnucklesAni_Walk-KnucklesAniData
		dc.w KnucklesAni_Run-KnucklesAniData; 1
		dc.w KnucklesAni_Roll-KnucklesAniData; 2
		dc.w KnucklesAni_Roll2-KnucklesAniData;	3
		dc.w KnucklesAni_Push-KnucklesAniData; 4
		dc.w KnucklesAni_Wait-KnucklesAniData; 5
		dc.w KnucklesAni_Balance-KnucklesAniData; 6
		dc.w KnucklesAni_LookUp-KnucklesAniData; 7
		dc.w KnucklesAni_Duck-KnucklesAniData; 8
		dc.w KnucklesAni_Spindash-KnucklesAniData; 9
		dc.w KnucklesAni_Unused-KnucklesAniData; 10
		dc.w KnucklesAni_Pull-KnucklesAniData; 11
		dc.w KnucklesAni_Balance2-KnucklesAniData; 12
		dc.w KnucklesAni_Stop-KnucklesAniData; 13
		dc.w KnucklesAni_Float-KnucklesAniData;	14
		dc.w KnucklesAni_Float2-KnucklesAniData; 15
		dc.w KnucklesAni_Spring-KnucklesAniData; 16
		dc.w KnucklesAni_Hang-KnucklesAniData; 17
		dc.w KnucklesAni_Unused_0-KnucklesAniData; 18
		dc.w KnucklesAni_S3EndingPose-KnucklesAniData; 19
		dc.w KnucklesAni_WFZHang-KnucklesAniData; 20
		dc.w KnucklesAni_Bubble-KnucklesAniData; 21
		dc.w KnucklesAni_DeathBW-KnucklesAniData; 22
		dc.w KnucklesAni_Drown-KnucklesAniData;	23
		dc.w KnucklesAni_Death-KnucklesAniData;	24
		dc.w KnucklesAni_OilSlide-KnucklesAniData; 25
		dc.w KnucklesAni_Hurt-KnucklesAniData; 26
		dc.w KnucklesAni_OilSlide_0-KnucklesAniData; 27
		dc.w KnucklesAni_Blank-KnucklesAniData;	28
		dc.w KnucklesAni_Unused_1-KnucklesAniData; 29
		dc.w KnucklesAni_Unused_2-KnucklesAniData; 30
		dc.w KnucklesAni_Transform-KnucklesAniData; 31
		dc.w KnucklesAni_Gliding-KnucklesAniData; 32
		dc.w KnucklesAni_FallFromGlide-KnucklesAniData;	33
		dc.w KnucklesAni_GetUp-KnucklesAniData;	34
		dc.w KnucklesAni_HardFall-KnucklesAniData; 35
		dc.w KnucklesAni_Badass-KnucklesAniData; 36
KnucklesAni_Walk:dc.b $FF,  7,	8,  1,	2,  3,	4,  5,	6,afEnd
KnucklesAni_Run:dc.b $FF,$21,$22,$23,$24,afEnd,afEnd,afEnd,afEnd,afEnd
KnucklesAni_Roll:dc.b $FE,$9A,$96,$9A,$97,$9A,$98,$9A,$99,afEnd
KnucklesAni_Roll2:dc.b $FE,$9A,$96,$9A,$97,$9A,$98,$9A,$99,afEnd
KnucklesAni_Push:dc.b $FD,$CE,$CF,$D0,$D1,afEnd,afEnd,afEnd,afEnd,afEnd
KnucklesAni_Wait:dc.b	5,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56
		dc.b $56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56
		dc.b $56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56
		dc.b $56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$56,$D2; 39
		dc.b $D2,$D2,$D3,$D3,$D3,$D2,$D2,$D2,$D3,$D3,$D3,$D2,$D2; 52
		dc.b $D2,$D3,$D3,$D3,$D2,$D2,$D2,$D3,$D3,$D3,$D2,$D2,$D2; 65
		dc.b $D3,$D3,$D3,$D2,$D2,$D2,$D3,$D3,$D3,$D2,$D2,$D2,$D3; 78
		dc.b $D3,$D3,$D2,$D2,$D2,$D3,$D3,$D3,$D2,$D2,$D2,$D3,$D3; 91
		dc.b $D3,$D4,$D4,$D4,$D4,$D4,$D7,$D8,$D9,$DA,$DB,$D8,$D9; 104
		dc.b $DA,$DB,$D8,$D9,$DA,$DB,$D8,$D9,$DA,$DB,$D8,$D9,$DA; 117
		dc.b $DB,$D8,$D9,$DA,$DB,$D8,$D9,$DA,$DB,$D8,$D9,$DA,$DB
		dc.b $DC,$DD,$DC,$DD,$DE,$DE,$D8,$D7,afEnd
KnucklesAni_Balance:dc.b   3,$9F,$9F,$A0,$A0,$A1,$A1,$A2,$A2,$A3,$A3,$A4,$A4
		dc.b $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
		dc.b $A5,$A5,$A6,$A6,$A6,$A7,$A7,$A7,$A8,$A8,$A9,$A9,$AA
		dc.b $AA,afBack,  6
KnucklesAni_LookUp:dc.b	  5,$D5,$D6,afBack,  1
KnucklesAni_Duck:dc.b	5,$9B,$9C,afBack,	1
KnucklesAni_Spindash:dc.b   0,$86,$87,$86,$88,$86,$89,$86,$8A,$86,$8B,afEnd
KnucklesAni_Unused:dc.b	  9,$BA,$C5,$C6,$C6,$C6,$C6,$C6,$C6,$C7,$C7,$C7,$C7
		dc.b $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7,afChange,  0
KnucklesAni_Pull:dc.b  $F,$8F,afEnd
KnucklesAni_Balance2:dc.b   3,$A1,$A1,$A2,$A2,$A3,$A3,$A4,$A4,$A5,$A5,$A5,$A5
		dc.b $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A6,$A6
		dc.b $A6,$A7,$A7,$A7,$A8,$A8,$A9,$A9,$AA,$AA,afBack, 6
KnucklesAni_Stop:dc.b	3,$9D,$9E,$9F,$A0,afChange,	0
KnucklesAni_Float:dc.b	 7,$C0,afEnd
KnucklesAni_Float2:dc.b	  5,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,afEnd
KnucklesAni_Spring:dc.b	$2F,$8E,afChange,  0
KnucklesAni_Hang:dc.b	1,$AE,$AF,afEnd
KnucklesAni_Unused_0:dc.b  $F,$43,$43,$43,afBack,	1
KnucklesAni_S3EndingPose:dc.b	5,$B1,$B2,$B2,$B2,$B3,$B4,afBack,	1,  7,$B1,$B3,$B3
		dc.b $B3,$B3,$B3,$B3,$B2,$B3,$B4,$B3,afBack,  4
KnucklesAni_WFZHang:dc.b $13,$91,afEnd
KnucklesAni_Bubble:dc.b	 $B,$B0,$B0,  3,  4,afChange,  0
KnucklesAni_DeathBW:dc.b $20,$AC,afEnd
KnucklesAni_Drown:dc.b $20,$AD,afEnd
KnucklesAni_Death:dc.b $20,$AB,afEnd
KnucklesAni_OilSlide:dc.b   9,$8C,afEnd
KnucklesAni_Hurt:dc.b $40,$8D,afEnd
KnucklesAni_OilSlide_0:dc.b   9,$8C,afEnd
KnucklesAni_Blank:dc.b $77,  0,afEnd
KnucklesAni_Unused_1:dc.b $13,$D0,$D1,afEnd
KnucklesAni_Unused_2:dc.b   3,$CF,$C8,$C9,$CA,$CB,afBack, 4
KnucklesAni_Gliding:dc.b $1F,$C0,afEnd
KnucklesAni_FallFromGlide:dc.b	 7,$CA,$CB,afBack,	 1
KnucklesAni_GetUp:dc.b	$F,$CD,afChange,  0
KnucklesAni_HardFall:dc.b  $F,$9C,afChange,	0
KnucklesAni_Badass:dc.b	  5,$D8,$D9,$DA,$DB,$D8,$D9,$DA,$DB,$D8,$D9,$DA,$DB
		dc.b $D8,$D9,$DA,$DB,$D8,$D9,$DA,$DB,$D8,$D9,$DA,$DB,$D8
		dc.b $D9,$DA,$DB,$D8,$D9,$DA,$DB,$DC,$DD,$DC,$DD,$DE,$DE
		dc.b afEnd
KnucklesAni_Transform:dc.b   2,$EB,$EB,$EC,$ED,$EE,$ED,$EE,$ED,$EE,$ED,$EC, afChange,  0
	rev02even