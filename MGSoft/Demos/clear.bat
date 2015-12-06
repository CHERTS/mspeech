@echo off

set dirname=.

del /S %dirname%\*.identcache
del /S %dirname%\*.dproj.local
del /S %dirname%\*.otares
del /S %dirname%\*.local
del /S %dirname%\*.tvsconfig
del /S %dirname%\*.dcu
del /S %dirname%\*.~*
del /S %dirname%\descript.ion
del /S %dirname%\*.ddp
del /S %dirname%\*.map
del /S %dirname%\*.drc
rd /S /Q %dirname%\__history
rd /S /Q %dirname%\Win32\Release
rd /S /Q %dirname%\Win32
