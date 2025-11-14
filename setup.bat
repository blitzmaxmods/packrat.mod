@echo off

rem This requires an environment varaibale called BLITZMAX to be set up to point to your
rem working BlitzMax root folder. Do not include a trailing slash.
rem
rem set BLITZMAX=C:\BlitzMax

echo.
echo PACKRAT.MOD SETUP
echo ======================================================================

if "%BLITZMAX%" == "" {
    echo "!! BLITZMAX environment variable is not set"
    goto :exit
}

if NOT EXIST %BLITZMAX%\bin\bmk.exe {
    echo "!! Cannot find %BLITZMAX%\bin\bmk.exe"
    exit 1
}

REM # CLEANUP

echo * Removing obsolete files

del *.a /s >NUL
del *.i /s >NUL
del *.o /s >NUL
del *.s /s >NUL

REM # COMPILE

echo * Compiling...

%BLITZMAX%\bin\bmk makemods -a packrat.visitor
%BLITZMAX%\bin\bmk makemods -a packrat.patterns

:exit
