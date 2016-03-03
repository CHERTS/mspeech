@echo off

del *.~*
del *.dcu
del descript.ion
del *.ddp
del *.map
del *.identcache 
del *.local
del *.drc
del /Q /F Release\*.*
rd /S /Q __history

cd Search-App-Class-Name
call clear.bat
cd ..
cd MSpeech-Reciver-Demo
call clear.bat
cd ..
