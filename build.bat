@ECHO OFF

REM // make sure we can write to the file s2built.bin
REM // also make a backup to s2built.prev.bin
IF NOT EXIST s2built.gen goto LABLNOCOPY
IF EXIST s2built.prev.gen del s2built.prev.gen
IF EXIST s2built.prev.gen goto LABLNOCOPY
move /Y s2built.gen s2built.prev.gen > NUL
IF EXIST s2built.gen goto LABLERROR3

:LABLNOCOPY
REM // delete some intermediate assembler output just in case
IF EXIST s2.p del s2.p
IF EXIST s2.p goto LABLERROR2
IF EXIST s2.h del s2.h
IF EXIST s2.h goto LABLERROR1

REM // run the assembler
set AS_MSGPATH=win32/as
set USEANSI=n

set debug_syms=
set print_err=-E -q
set revision_override=
set s2p2bin_args=

:parseloop
IF "%1"=="-ds" (
	set debug_syms=-g MAP
	echo Will generate debug symbols
)
IF "%1"=="-pe" (
	REM // allow the user to choose to print error messages out by supplying the -pe parameter
	set print_err=
	echo Selected detailed assembler output
)
IF "%1"=="-a" (
	set s2p2bin_args=-a
	echo Will use accurate sound driver compression
)
IF "%1"=="-r0" (
	set revision_override=-D gameRevision=0
	echo Building REV00
)
IF "%1"=="-r1" (
	set revision_override=-D gameRevision=1
	echo Building REV01
)
IF "%1"=="-r2" (
	set revision_override=-D gameRevision=2
	echo Building REV02
)
SHIFT
IF NOT "%1"=="" goto parseloop

echo Assembling...

"AMPS/Includer.exe" AS AMPS AMPS/.Data
"win32/as/asw" -xx -c %debug_syms% %print_err% -A -L %revision_override% s2.asm

REM // if there were errors, there won't be any s2.p output
IF NOT EXIST s2.p goto LABLERROR5

REM // combine the assembler output into a rom
"win32/s2p2bin" %s2p2bin_args% s2.p s2built.gen s2.h

REM // fix some pointers and things that are impossible to fix from the assembler without un-splitting their data
"win32/fixpointer" s2.h s2built.gen   off_3A294 MapRUnc_Sonic $2D 0 4   word_728C_user Obj_EndingController_MapUnc_7240 2 2 1

REM // done -- pause if we seem to have failed, then exit
IF NOT EXIST s2built.gen pause & exit /b
"ErrorDebugger/ConvSym.exe" s2.lst s2built.gen -input as_lst -a

REM REM // fix the rom header (checksum)
"win32/fixheader" s2built.gen

REM // if there were errors/warnings, a log file is produced
IF EXIST s2.log goto LABLERROR4

del s2.p
del s2.h
del AMPS\.Data
exit /b

:LABLERROR1
echo Failed to build because write access to s2.h was denied.
pause


exit /b

:LABLERROR2
echo Failed to build because write access to s2.p was denied.
pause


exit /b

:LABLERROR3
echo Failed to build because write access to s2built.gen was denied.
pause

exit /b

:LABLERROR4
REM // display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *      There were build warnings. See s2.log for more details.       *
echo *                                                                    *
echo **********************************************************************
echo.
pause

exit /b

:LABLERROR5
REM // display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *       There were build errors. See s2.log for more details.        *
echo *                                                                    *
echo **********************************************************************
echo.
pause


