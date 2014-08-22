@echo off

set prg_name=MSpeech.exe
set search_prg_name=Search-App-Class-Name\SearchAppClassName.exe
set reciver_prg_name=MSpeech-Reciver-Demo\MSpeech_Reciver_Demo.exe
set installer_prg_name=MSpeech-Setup-1.5.5.exe

if "%ProgramFiles(x86)%"=="" goto DoWin32
set PROGRAMFILES=%ProgramFiles(x86)%
:DoWin32
set NSISPath="%PROGRAMFILES%\NSIS\makensis.exe"

cls
call clear.bat

if exist %prg_name% (
  upx.exe -9 %prg_name%
  upx.exe -9 %search_prg_name%
  upx.exe -9 %reciver_prg_name%
  copy /Y langs\*.xml Installer\base\langs\
  copy /Y script\*.* Installer\base\script\
  copy /Y %prg_name% Installer\base\
  copy /Y %reciver_prg_name% Installer\base\
  copy /Y %search_prg_name% Installer\base\
  copy /Y libeay32.dll Installer\base\
  copy /Y libFLAC.dll Installer\base\
  copy /Y ssleay32.dll Installer\base\
  copy /Y changelog.txt Installer\base\
  copy /Y getlicense_en.txt Installer\base\
  copy /Y getlicense_ru.txt Installer\base\
  copy /Y MSpeech.cf Installer\base\
  copy /Y MSpeech.ini Installer\base\
  cd Installer\
  del /Q /F %installer_prg_name%
  %NSISPath% /DINNER setup_x86.nsi
  cd ..
)

call clear.bat
