!include "MUI2.nsh"
!include "UAC.nsh"
!include "LogicLib.nsh"
!include "Library.nsh"

!define HOME ".\base\"

!define PRODUCT_NAME "MSpeech"
!define NAME "MSpeech"
!define VERSION 1.5.8
!define COMPANY "Mikhael Grigorev"
!define URL http://www.im-history.ru

;--------------------------------
;Configuration

  ;General

  OutFile MSpeech-Setup-${VERSION}.exe

  ;bzip2
  SetCompressor /SOLID lzma

  ShowUninstDetails show
  ShowInstDetails show

  CRCCheck on
  XPStyle on

  ;Folder selection page
  InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
  
  VIProductVersion ${VERSION}.0
  VIAddVersionKey ProductName "${NAME}"
  VIAddVersionKey ProductVersion "${VERSION}"
  VIAddVersionKey CompanyName "${COMPANY}"
  VIAddVersionKey CompanyWebsite "${URL}"
  VIAddVersionKey FileVersion "${VERSION}"
  VIAddVersionKey FileDescription "${NAME}"
  VIAddVersionKey LegalCopyright "${COMPANY}"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;----------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
;  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU" 
;  !define MUI_LANGDLL_REGISTRY_KEY "Software\${PRODUCT_NAME}"
;  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"
  
;--------------------------------
;Modern UI Configuration

  Name "${PRODUCT_NAME}"

  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_FINISHPAGE_NOAUTOCLOSE
  !define MUI_ABORTWARNING
  !define MUI_ICON "${HOME}\..\..\MSpeech_Icon.ico"
  !define MUI_UNICON "${HOME}\..\..\MSpeech_Icon.ico"
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "logo.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "left_logo.bmp"
  !define MUI_UNFINISHPAGE_NOAUTOCLOSE

  ;!define MUI_FINISHPAGE_RUN_TEXT "$(FinishPageRunDesc)"
  ;!define MUI_FINISHPAGE_RUN "MSpeech.exe"
  ;!define MUI_FINISHPAGE_RUN_FUNCTION PageFinishRun

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${HOME}\..\license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES  
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ;first language is the default language
  !insertmacro MUI_LANGUAGE "Russian"

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------

;Function PageFinishRun
;!insertmacro UAC_AsUser_ExecShell "" "$INSTDIR\MSpeech.exe" "" "" ""
;FunctionEnd

;--------------------------------
;Installer Functions

Function .onInit

  ; Предотвращение множественности запуска 
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "$(^Name)") i .r1 ?e'
  Pop $R0
  ${IfNot} $R0 == 0
    MessageBox MB_OK|MB_ICONEXCLAMATION "One copy of the installer $(^Name) is already running."
    Abort
  ${EndIf}

uac_tryagain:
!insertmacro UAC_RunElevated
${Switch} $0
${Case} 0
	${IfThen} $1 = 1 ${|} Quit ${|} ;we are the outer process, the inner process has done its work, we are done
	${IfThen} $3 <> 0 ${|} ${Break} ${|} ;we are admin, let the show go on
	${If} $1 = 3 ;RunAs completed successfully, but with a non-admin user
		MessageBox mb_YesNo|mb_IconExclamation|mb_TopMost|mb_SetForeground "This installer requires admin privileges, try again" /SD IDNO IDYES uac_tryagain IDNO 0
	${EndIf}
	;fall-through and die
${Case} 1223
	MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "This installer requires admin privileges, aborting!"
	Quit
${Case} 1062
	MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Logon service not running, aborting!"
	Quit
${Default}
	MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Unable to elevate , error $0"
	Quit
${EndSwitch}

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

;--------------------------------
;Macros

!macro WriteRegStringIfUndef ROOT SUBKEY KEY VALUE
Push $R0
ReadRegStr $R0 "${ROOT}" "${SUBKEY}" "${KEY}"
StrCmp $R0 "" +1 +2
WriteRegStr "${ROOT}" "${SUBKEY}" "${KEY}" '${VALUE}'
Pop $R0
!macroend

!macro DelRegStringIfUnchanged ROOT SUBKEY KEY VALUE
Push $R0
ReadRegStr $R0 "${ROOT}" "${SUBKEY}" "${KEY}"
StrCmp $R0 '${VALUE}' +1 +2
DeleteRegValue "${ROOT}" "${SUBKEY}" "${KEY}"
Pop $R0
!macroend

!macro DelRegKeyIfUnchanged ROOT SUBKEY VALUE
Push $R0
ReadRegStr $R0 "${ROOT}" "${SUBKEY}" ""
StrCmp $R0 '${VALUE}' +1 +2
DeleteRegKey "${ROOT}" "${SUBKEY}"
Pop $R0
!macroend

!macro DelRegKeyIfEmpty ROOT SUBKEY
Push $R0
EnumRegValue $R0 "${ROOT}" "${SUBKEY}" 1
StrCmp $R0 "" +1 +2
DeleteRegKey /ifempty "${ROOT}" "${SUBKEY}"
Pop $R0
!macroend

; Удаление RHVoice
Function UninstallRHVoice
DetailPrint "Uninstalling RHVoice..."
StrCpy $R1 ""
ReadRegStr $0 HKLM "Software\RHVoice" "path"
;DetailPrint "RHVoicePath: $0"
${If} $0 == ""
  ${If} ${RunningX64}
  SetRegView 64
  ReadRegStr $0 HKLM "Software\RHVoice" "path"
  SetRegView 32
  ${EndIf}
  ${If} $0 == ""
    ; Хвосты оригинального RHVoice
    StrCpy $R1 "$PROGRAMFILES\RHVoice"
    DetailPrint "Original RHVoice directory set: $R1"
  ${Else}
    DetailPrint "In the registry, found information on RHVoiceDir (x64): $0"
    StrCpy $R1 $0
  ${EndIf}
${Else}
  DetailPrint "In the registry, found information on RHVoiceDir (x86): $0"
  StrCpy $R1 $0
${EndIf}
; Проверка оригинального RHVoice
IfFileExists "$R1\lib32\RHVoiceSvr.dll" rhvoicedelete 0
  StrCpy $R1 "$INSTDIR\rhvoice"
rhvoicedelete:
IfFileExists "$R1\lib32\RHVoiceSvr.dll" 0 rhvoicedone
  DetailPrint "Found library RHVoice: $R1\lib32\RHVoiceSvr.dll"
  !insertmacro UnInstallLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED "$R1\lib32\RHVoiceSvr.dll"
  !define LIBRARY_X64
  ${If} ${RunningX64}
  !insertmacro UnInstallLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED "$R1\lib64\RHVoiceSvr.dll"
  ${EndIf}
  !undef LIBRARY_X64
  Delete "$R1\lib32\RHVoiceSvr.dll"
  Rmdir "$R1\lib32"
  Delete "$R1\lib64\RHVoiceSvr.dll"
  Rmdir "$R1\lib64"
  ; Удаляем хвосты оригинального RHVoice
  IfFileExists "$PROGRAMFILES\RHVoice\uninstall\uninstall-RHVoice.exe" 0 rhvoice32
    DetailPrint "Delete original RHVoice: $PROGRAMFILES\RHVoice\uninstall\uninstall-RHVoice.exe"
    Delete "$PROGRAMFILES\RHVoice\uninstall\uninstall-RHVoice.exe"
    Rmdir "$PROGRAMFILES\RHVoice\uninstall"
    Rmdir "$PROGRAMFILES\RHVoice\"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RHVoice"
    Goto nodelorig
  rhvoice32:
  IfFileExists "$PROGRAMFILES32\RHVoice\uninstall\uninstall-RHVoice.exe" 0 nodelorig
    DetailPrint "Delete original RHVoice (x86): $PROGRAMFILES32\RHVoice\uninstall\uninstall-RHVoice.exe"
    Delete "$PROGRAMFILES32\RHVoice\uninstall\uninstall-RHVoice.exe"
    Rmdir "$PROGRAMFILES32\RHVoice\uninstall"
    Rmdir "$PROGRAMFILES32\RHVoice\"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RHVoice"
  nodelorig:
  DeleteRegKey HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice"
  ${If} ${RunningX64}
  SetRegView 64
  DeleteRegKey HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice"
  SetRegView 32
  ${EndIf}
  DeleteRegKey HKLM "Software\RHVoice"
  ${If} ${RunningX64}
  SetRegView 64
  DeleteRegKey HKLM "Software\RHVoice"
  SetRegView 32
  ${EndIf}
rhvoicedone:
FunctionEnd

;--------------------------------
;Language Strings

LangString SecAddShortcutsDesc ${LANG_RUSSIAN} "Добавить ярлыки в меню Пуск"
LangString SecAddShortcutsDesc ${LANG_ENGLISH} "Add shortcuts to Start Menu"

LangString SecAddShortcutsInDesktopDesc ${LANG_RUSSIAN} "Добавить ярлык на Рабочий стол"
LangString SecAddShortcutsInDesktopDesc ${LANG_ENGLISH} "Add shortcut to the Desktop"

LangString SecAddRHVoiceDesc ${LANG_RUSSIAN} "Установить систему синтеза речи RHVoice"
LangString SecAddRHVoiceDesc ${LANG_ENGLISH} "Installing the speech synthesis system RHVoice"

LangString SecAddRHVoiceCoreDesc ${LANG_RUSSIAN} "RHVoice"
LangString SecAddRHVoiceCoreDesc ${LANG_ENGLISH} "RHVoice"

LangString SecAddRHVoiceRussianPackDesc ${LANG_RUSSIAN} "Русский языковой пакет для RHVoice"
LangString SecAddRHVoiceRussianPackDesc ${LANG_ENGLISH} "Russian language pack for RHVoice"

LangString SecAddRHVoiceRussianVoiceAnnaDesc ${LANG_RUSSIAN} "Русский голос Анна для RHVoice"
LangString SecAddRHVoiceRussianVoiceAnnaDesc ${LANG_ENGLISH} "Russian voice Anna for RHVoice"

LangString SecAddRHVoiceRussianVoiceElenaDesc ${LANG_RUSSIAN} "Русский голос Елена для RHVoice"
LangString SecAddRHVoiceRussianVoiceElenaDesc ${LANG_ENGLISH} "Russian voice Elena for RHVoice"

LangString SecAddRHVoiceRussianVoiceIrinaDesc ${LANG_RUSSIAN} "Русский голос Ирина для RHVoice"
LangString SecAddRHVoiceRussianVoiceIrinaDesc ${LANG_ENGLISH} "Russian voice Irina for RHVoice"

LangString SecAddRHVoiceRussianVoiceAleksandrDesc ${LANG_RUSSIAN} "Русский голос Александр для RHVoice"
LangString SecAddRHVoiceRussianVoiceAleksandrDesc ${LANG_ENGLISH} "Russian voice Aleksandr for RHVoice"

LangString SecAddRHVoiceEnglishPackDesc ${LANG_RUSSIAN} "Английский языковой пакет для RHVoice"
LangString SecAddRHVoiceEnglishPackDesc ${LANG_ENGLISH} "English language pack for RHVoice"

LangString SecAddRHVoiceEnglishVoiceAlanDesc ${LANG_RUSSIAN} "Английский голос Алан для RHVoice"
LangString SecAddRHVoiceEnglishVoiceAlanDesc ${LANG_ENGLISH} "English voice Alan for RHVoice"

LangString SecAddRHVoiceEnglishVoiceCLBDesc ${LANG_RUSSIAN} "Английский голос CLB для RHVoice"
LangString SecAddRHVoiceEnglishVoiceCLBDesc ${LANG_ENGLISH} "English voice CLB for RHVoice"

LangString RunMSpeechDesc ${LANG_RUSSIAN} "Запустить MSpeech.lnk"
LangString RunMSpeechDesc ${LANG_ENGLISH} "Run MSpeech.lnk"

LangString RunMSpeechReciverDemoDesc ${LANG_RUSSIAN} "Запустить MSpeech Reciver Demo.lnk"
LangString RunMSpeechReciverDemoDesc ${LANG_ENGLISH} "Run MSpeech Reciver Demo.lnk"

LangString RunSearchAppClassNameDesc ${LANG_RUSSIAN} "Запустить SearchAppClassName.lnk"
LangString RunSearchAppClassNameDesc ${LANG_ENGLISH} "Run SearchAppClassName.lnk"

LangString DeleteMSpeechDesc ${LANG_RUSSIAN} "Удалить программу MSpeech.lnk"
LangString DeleteMSpeechDesc ${LANG_ENGLISH} "Uninstall MSpeech.lnk"

LangString FinishPageRunDesc ${LANG_RUSSIAN} "Запустить MSpeech"
LangString FinishPageRunDesc ${LANG_ENGLISH} "Run MSpeech"

;--------------------------------
;Installer Sections

;!define SF_SELECTED   1
;!define SF_RO         16
!define SF_NOT_RO     0xFFFFFFEF

Section "MSpeech" SecMainProgramUserSpace

  SetOverwrite on
  SetOutPath "$INSTDIR"

  File "${HOME}\MSpeech.exe"
  File "${HOME}\MSpeech_Reciver_Demo.exe"
  File "${HOME}\SearchAppClassName.exe"
  File "${HOME}\libeay32.dll"
  File "${HOME}\libFLAC.dll"
  File "${HOME}\ssleay32.dll"
  File "${HOME}\changelog.txt"
  File "${HOME}\getlicense_en.txt"
  File "${HOME}\getlicense_ru.txt"
  File "${HOME}\LICENSE"

  IfFileExists "$INSTDIR\MSpeechForms.ini" 0 +2
   Delete "$INSTDIR\MSpeechForms.ini"

  IfFileExists "$INSTDIR\MSpeech.ini" trynoini 0
    File "${HOME}\MSpeech.ini"

  trynoini:
  File "${HOME}\uninstall.ico"

  SetOutPath "$INSTDIR\langs"

  File "${HOME}\langs\Russian.xml"
  File "${HOME}\langs\English.xml"

  SetOutPath "$INSTDIR\script"

  File "${HOME}\script\Halt_Workstation.cmd"
  File "${HOME}\script\Lock_Workstation.cmd"
  File "${HOME}\script\Logoff_Workstation.cmd"
  File "${HOME}\script\Reboot_Workstation.cmd"
  File "${HOME}\script\Show_Desktop.scf"
  File "${HOME}\script\Show_Desktop.vbs"
  File "${HOME}\script\StopHalt_Workstation.cmd"

  SetOutPath "$INSTDIR"

SectionEnd

Section $(SecAddShortcutsDesc) SecAddShortcuts

  SetOverwrite on
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\$(RunMSpeechDesc)" "$INSTDIR\MSpeech.exe" "" "$INSTDIR\MSpeech.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\$(RunMSpeechReciverDemoDesc)" "$INSTDIR\MSpeech_Reciver_Demo.exe" "" "$INSTDIR\MSpeech_Reciver_Demo.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\$(RunSearchAppClassNameDesc)" "$INSTDIR\SearchAppClassName.exe" "" "$INSTDIR\SearchAppClassName.exe" 0
  CreateShortcut "$SMPROGRAMS\${PRODUCT_NAME}\$(DeleteMSpeechDesc)" "$INSTDIR\uninstall.exe" "" $INSTDIR\uninstall.ico 0

SectionEnd

Section $(SecAddShortcutsInDesktopDesc) SecAddShortcutsInDesktop

  SetOverwrite on
  SetShellVarContext all
  CreateShortCut "$DESKTOP\$(RunMSpeechDesc)" "$INSTDIR\MSpeech.exe" "" "$INSTDIR\MSpeech.exe" 0

SectionEnd

SectionGroup $(SecAddRHVoiceDesc) SecAddRHVoice

	Section $(SecAddRHVoiceCoreDesc) SecAddRHVoiceCore
		; Проверяем наличие RHVoice
		ClearErrors
		EnumRegKey $0 HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice" 0
		IfErrors 0 keyrhvoiceexist
		  DetailPrint "RHVoice not found (x86)"
		  ${If} ${RunningX64}
		  ClearErrors
		  SetRegView 64
		  EnumRegKey $0 HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice" 0
		  SetRegView 32
		  ${EndIf}
		  IfErrors 0 keyrhvoiceexist
		    DetailPrint "RHVoice not found (x64)"
		    Goto rhvoiceinstall
		keyrhvoiceexist:
			Call UninstallRHVoice
		rhvoiceinstall:
		SetOverwrite on
		; Регистрация RHVoice DLL
		DetailPrint "Installing RHVoice..."
		SetOutPath "$INSTDIR\rhvoice\lib32"
		!insertmacro installLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED ${HOME}\rhvoice\lib32\RHVoiceSvr.dll "RHVoiceSvr.dll" $INSTDIR
		!define LIBRARY_X64
		${If} ${RunningX64}
		SetOutPath "$INSTDIR\rhvoice\lib64"
		!insertmacro installLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED ${HOME}\rhvoice\lib64\RHVoiceSvr.dll "RHVoiceSvr.dll" $INSTDIR
		${EndIf}
		!undef LIBRARY_X64
		; Прописываем пути к файлам данных движка RHVoice 
		WriteRegStr HKLM "Software\RHVoice" "path" "$INSTDIR\rhvoice"
		WriteRegStr HKLM "Software\RHVoice" "data_path" "$INSTDIR\rhvoice\data"
		${If} ${RunningX64}
		SetRegView 64
		WriteRegStr HKLM "Software\RHVoice" "data_path" "$INSTDIR\rhvoice\data"
		SetRegView 32
		${EndIf}
		; Регистрация RHVoice в SAPI
		WriteRegStr HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice" "CLSID" "{d7577808-7ade-4dea-a5b7-ee314d6ef3a1}"
		${If} ${RunningX64}
		SetRegView 64
		WriteRegStr HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice" "CLSID" "{d7577808-7ade-4dea-a5b7-ee314d6ef3a1}"
		SetRegView 32
		${EndIf}
		SetOutPath "$INSTDIR"
	SectionEnd

	SectionGroup $(SecAddRHVoiceRussianPackDesc) SecAddRHVoiceRussianPack

		Section $(SecAddRHVoiceRussianPackDesc) SecAddRHVoiceRussianPackCore
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\languages\Russian"
			File "${HOME}\rhvoice\data\languages\Russian\clitics.fst"
			File "${HOME}\rhvoice\data\languages\Russian\dict.fst"
			File "${HOME}\rhvoice\data\languages\Russian\downcase.fst"
			File "${HOME}\rhvoice\data\languages\Russian\english_phone_mapping.fst"
			File "${HOME}\rhvoice\data\languages\Russian\g2p.fst"
			File "${HOME}\rhvoice\data\languages\Russian\gpos.fst"
			File "${HOME}\rhvoice\data\languages\Russian\key.fst"
			File "${HOME}\rhvoice\data\languages\Russian\labelling.xml"
			File "${HOME}\rhvoice\data\languages\Russian\language.info"
			File "${HOME}\rhvoice\data\languages\Russian\lseq.fst"
			File "${HOME}\rhvoice\data\languages\Russian\msg.fst"
			File "${HOME}\rhvoice\data\languages\Russian\numbers.fst"
			File "${HOME}\rhvoice\data\languages\Russian\phonemes.xml"
			File "${HOME}\rhvoice\data\languages\Russian\phrasing.dt"
			File "${HOME}\rhvoice\data\languages\Russian\rulex_dict.fst"
			File "${HOME}\rhvoice\data\languages\Russian\rulex_rules.fst"
			File "${HOME}\rhvoice\data\languages\Russian\spell.fst"
			File "${HOME}\rhvoice\data\languages\Russian\stress.fsm"
			File "${HOME}\rhvoice\data\languages\Russian\stress.fst"
			File "${HOME}\rhvoice\data\languages\Russian\syl.fst"
			File "${HOME}\rhvoice\data\languages\Russian\tok.fst"
			File "${HOME}\rhvoice\data\languages\Russian\untranslit.fst"
			SetOutPath "$INSTDIR"
		SectionEnd

		Section $(SecAddRHVoiceRussianVoiceAnnaDesc) SecAddRHVoiceRussianVoiceAnna
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\voices\Anna"
			File "${HOME}\rhvoice\data\voices\anna\dur.pdf"
			File "${HOME}\rhvoice\data\voices\anna\lf0.pdf"
			File "${HOME}\rhvoice\data\voices\anna\lf0.win1"
			File "${HOME}\rhvoice\data\voices\anna\lf0.win2"
			File "${HOME}\rhvoice\data\voices\anna\lf0.win3"
			File "${HOME}\rhvoice\data\voices\anna\lpf.pdf"
			File "${HOME}\rhvoice\data\voices\anna\lpf.win1"
			File "${HOME}\rhvoice\data\voices\anna\mgc.pdf"
			File "${HOME}\rhvoice\data\voices\anna\mgc.win1"
			File "${HOME}\rhvoice\data\voices\anna\mgc.win2"
			File "${HOME}\rhvoice\data\voices\anna\mgc.win3"
			File "${HOME}\rhvoice\data\voices\anna\tree-dur.inf"
			File "${HOME}\rhvoice\data\voices\anna\tree-lf0.inf"
			File "${HOME}\rhvoice\data\voices\anna\tree-lpf.inf"
			File "${HOME}\rhvoice\data\voices\anna\tree-mgc.inf"
			File "${HOME}\rhvoice\data\voices\anna\voice.info"
			File "${HOME}\rhvoice\data\voices\anna\voice.params"
			SetOutPath "$INSTDIR"
		SectionEnd

		Section /o $(SecAddRHVoiceRussianVoiceElenaDesc) SecAddRHVoiceRussianVoiceElena
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\voices\Elena"
			File "${HOME}\rhvoice\data\voices\elena\dur.pdf"
			File "${HOME}\rhvoice\data\voices\elena\lf0.pdf"
			File "${HOME}\rhvoice\data\voices\elena\lf0.win1"
			File "${HOME}\rhvoice\data\voices\elena\lf0.win2"
			File "${HOME}\rhvoice\data\voices\elena\lf0.win3"
			File "${HOME}\rhvoice\data\voices\elena\lpf.pdf"
			File "${HOME}\rhvoice\data\voices\elena\lpf.win1"
			File "${HOME}\rhvoice\data\voices\elena\mgc.pdf"
			File "${HOME}\rhvoice\data\voices\elena\mgc.win1"
			File "${HOME}\rhvoice\data\voices\elena\mgc.win2"
			File "${HOME}\rhvoice\data\voices\elena\mgc.win3"
			File "${HOME}\rhvoice\data\voices\elena\tree-dur.inf"
			File "${HOME}\rhvoice\data\voices\elena\tree-lf0.inf"
			File "${HOME}\rhvoice\data\voices\elena\tree-lpf.inf"
			File "${HOME}\rhvoice\data\voices\elena\tree-mgc.inf"
			File "${HOME}\rhvoice\data\voices\elena\voice.info"
			File "${HOME}\rhvoice\data\voices\elena\voice.params"
			SetOutPath "$INSTDIR"
		SectionEnd

		Section /o $(SecAddRHVoiceRussianVoiceIrinaDesc) SecAddRHVoiceRussianVoiceIrina
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\voices\Irina"
			File "${HOME}\rhvoice\data\voices\irina\dur.pdf"
			File "${HOME}\rhvoice\data\voices\irina\lf0.pdf"
			File "${HOME}\rhvoice\data\voices\irina\lf0.win1"
			File "${HOME}\rhvoice\data\voices\irina\lf0.win2"
			File "${HOME}\rhvoice\data\voices\irina\lf0.win3"
			File "${HOME}\rhvoice\data\voices\irina\lpf.pdf"
			File "${HOME}\rhvoice\data\voices\irina\lpf.win1"
			File "${HOME}\rhvoice\data\voices\irina\mgc.pdf"
			File "${HOME}\rhvoice\data\voices\irina\mgc.win1"
			File "${HOME}\rhvoice\data\voices\irina\mgc.win2"
			File "${HOME}\rhvoice\data\voices\irina\mgc.win3"
			File "${HOME}\rhvoice\data\voices\irina\tree-dur.inf"
			File "${HOME}\rhvoice\data\voices\irina\tree-lf0.inf"
			File "${HOME}\rhvoice\data\voices\irina\tree-lpf.inf"
			File "${HOME}\rhvoice\data\voices\irina\tree-mgc.inf"
			File "${HOME}\rhvoice\data\voices\irina\voice.info"
			File "${HOME}\rhvoice\data\voices\irina\voice.params"
			SetOutPath "$INSTDIR"
		SectionEnd

		Section /o $(SecAddRHVoiceRussianVoiceAleksandrDesc) SecAddRHVoiceRussianVoiceAleksandr
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\voices\Aleksandr"
			File "${HOME}\rhvoice\data\voices\Aleksandr\dur.pdf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\lf0.pdf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\lf0.win1"
			File "${HOME}\rhvoice\data\voices\Aleksandr\lf0.win2"
			File "${HOME}\rhvoice\data\voices\Aleksandr\lf0.win3"
			File "${HOME}\rhvoice\data\voices\Aleksandr\lpf.pdf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\lpf.win1"
			File "${HOME}\rhvoice\data\voices\Aleksandr\mgc.pdf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\mgc.win1"
			File "${HOME}\rhvoice\data\voices\Aleksandr\mgc.win2"
			File "${HOME}\rhvoice\data\voices\Aleksandr\mgc.win3"
			File "${HOME}\rhvoice\data\voices\Aleksandr\tree-dur.inf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\tree-lf0.inf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\tree-lpf.inf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\tree-mgc.inf"
			File "${HOME}\rhvoice\data\voices\Aleksandr\voice.info"
			File "${HOME}\rhvoice\data\voices\Aleksandr\voice.params"
			SetOutPath "$INSTDIR"
		SectionEnd

	SectionGroupEnd

	SectionGroup $(SecAddRHVoiceEnglishPackDesc) SecAddRHVoiceEnglishPack

		Section /o $(SecAddRHVoiceEnglishPackDesc) SecAddRHVoiceEnglishPackCore
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\languages\English"
			File "${HOME}\rhvoice\data\languages\English\accents.dt"
			File "${HOME}\rhvoice\data\languages\English\cmulex.fst"
			File "${HOME}\rhvoice\data\languages\English\cmulex.lts"
			File "${HOME}\rhvoice\data\languages\English\downcase.fst"
			File "${HOME}\rhvoice\data\languages\English\gpos.fst"
			File "${HOME}\rhvoice\data\languages\English\key.fst"
			File "${HOME}\rhvoice\data\languages\English\labelling.xml"
			File "${HOME}\rhvoice\data\languages\English\language.info"
			File "${HOME}\rhvoice\data\languages\English\lseq.fst"
			File "${HOME}\rhvoice\data\languages\English\msg.fst"
			File "${HOME}\rhvoice\data\languages\English\numbers.fst"
			File "${HOME}\rhvoice\data\languages\English\phonemes.xml"
			File "${HOME}\rhvoice\data\languages\English\phrasing.dt"
			File "${HOME}\rhvoice\data\languages\English\spell.fst"
			File "${HOME}\rhvoice\data\languages\English\syl.fst"
			File "${HOME}\rhvoice\data\languages\English\tok.fst"
			File "${HOME}\rhvoice\data\languages\English\tones.dt"
			SetOutPath "$INSTDIR"
		SectionEnd

		Section /o $(SecAddRHVoiceEnglishVoiceAlanDesc) SecAddRHVoiceEnglishVoiceAlan
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\voices\Alan"
			File "${HOME}\rhvoice\data\voices\Alan\dur.pdf"
			File "${HOME}\rhvoice\data\voices\Alan\lf0.pdf"
			File "${HOME}\rhvoice\data\voices\Alan\lf0.win1"
			File "${HOME}\rhvoice\data\voices\Alan\lf0.win2"
			File "${HOME}\rhvoice\data\voices\Alan\lf0.win3"
			File "${HOME}\rhvoice\data\voices\Alan\lpf.pdf"
			File "${HOME}\rhvoice\data\voices\Alan\lpf.win1"
			File "${HOME}\rhvoice\data\voices\Alan\mgc.pdf"
			File "${HOME}\rhvoice\data\voices\Alan\mgc.win1"
			File "${HOME}\rhvoice\data\voices\Alan\mgc.win2"
			File "${HOME}\rhvoice\data\voices\Alan\mgc.win3"
			File "${HOME}\rhvoice\data\voices\Alan\tree-dur.inf"
			File "${HOME}\rhvoice\data\voices\Alan\tree-lf0.inf"
			File "${HOME}\rhvoice\data\voices\Alan\tree-lpf.inf"
			File "${HOME}\rhvoice\data\voices\Alan\tree-mgc.inf"
			File "${HOME}\rhvoice\data\voices\Alan\voice.info"
			File "${HOME}\rhvoice\data\voices\Alan\voice.params"
			SetOutPath "$INSTDIR"
		SectionEnd

		Section /o $(SecAddRHVoiceEnglishVoiceCLBDesc) SecAddRHVoiceEnglishVoiceCLB
			SetOverwrite on
			SetOutPath "$INSTDIR\rhvoice\data\voices\CLB"
			File "${HOME}\rhvoice\data\voices\CLB\dur.pdf"
			File "${HOME}\rhvoice\data\voices\CLB\lf0.pdf"
			File "${HOME}\rhvoice\data\voices\CLB\lf0.win1"
			File "${HOME}\rhvoice\data\voices\CLB\lf0.win2"
			File "${HOME}\rhvoice\data\voices\CLB\lf0.win3"
			File "${HOME}\rhvoice\data\voices\CLB\lpf.pdf"
			File "${HOME}\rhvoice\data\voices\CLB\lpf.win1"
			File "${HOME}\rhvoice\data\voices\CLB\mgc.pdf"
			File "${HOME}\rhvoice\data\voices\CLB\mgc.win1"
			File "${HOME}\rhvoice\data\voices\CLB\mgc.win2"
			File "${HOME}\rhvoice\data\voices\CLB\mgc.win3"
			File "${HOME}\rhvoice\data\voices\CLB\tree-dur.inf"
			File "${HOME}\rhvoice\data\voices\CLB\tree-lf0.inf"
			File "${HOME}\rhvoice\data\voices\CLB\tree-lpf.inf"
			File "${HOME}\rhvoice\data\voices\CLB\tree-mgc.inf"
			File "${HOME}\rhvoice\data\voices\CLB\voice.info"
			File "${HOME}\rhvoice\data\voices\CLB\voice.params"
			SetOutPath "$INSTDIR"
		SectionEnd

	SectionGroupEnd

SectionGroupEnd

;--------------------------------
;Language Strings

  LangString DESC_SecMainProgramUserSpace ${LANG_RUSSIAN} "Установить программу."
  LangString DESC_SecAddShortcuts ${LANG_RUSSIAN} "Добавить ярлыки в меню Пуск."
  LangString DESC_SecAddShortcutsInDesktop ${LANG_RUSSIAN} "Добавить ярлык на Рабочий стол."
  LangString DESC_SecAddRHVoice ${LANG_RUSSIAN} "Установить многоязычный синтезатор речи с открытым исходным кодом."
  LangString DESC_SecAddRHVoiceCore ${LANG_RUSSIAN} "Ядро системы синтеза RHVoice."
  LangString DESC_SecAddRHVoiceRussianPack ${LANG_RUSSIAN} "Русский языковой пакет для системы RHVoice."
  LangString DESC_SecAddRHVoiceEnglishPack ${LANG_RUSSIAN} "Английский языковой пакет для системы RHVoice."

  LangString DESC_SecMainProgramUserSpace ${LANG_ENGLISH} "Install main programms."
  LangString DESC_SecAddShortcuts ${LANG_ENGLISH} "Add shortcuts to the current user's Start Menu."
  LangString DESC_SecAddShortcutsInDesktop ${LANG_ENGLISH} "Add shortcuts to the Desktop."
  LangString DESC_SecAddRHVoice ${LANG_ENGLISH} "Install multilingual speech synthesizer with open source."
  LangString DESC_SecAddRHVoiceCore ${LANG_ENGLISH} "Core synthesis system RHVoice."
  LangString DESC_SecAddRHVoiceRussianPack ${LANG_ENGLISH} "Russian language pack for RHVoice."
  LangString DESC_SecAddRHVoiceEnglishPack ${LANG_ENGLISH} "English language pack for RHVoice."

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMainProgramUserSpace} $(DESC_SecMainProgramUserSpace)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddShortcuts} $(DESC_SecAddShortcuts)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddShortcutsInDesktop} $(DESC_SecAddShortcutsInDesktop)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddRHVoice} $(DESC_SecAddRHVoice)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddRHVoiceCore} $(DESC_SecAddRHVoiceCore)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddRHVoiceRussianPack} $(DESC_SecAddRHVoiceRussianPack)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddRHVoiceRussianPackCore} $(DESC_SecAddRHVoiceRussianPack)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddRHVoiceEnglishPack} $(DESC_SecAddRHVoiceEnglishPack)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddRHVoiceEnglishPackCore} $(DESC_SecAddRHVoiceEnglishPack)
!insertmacro MUI_FUNCTION_DESCRIPTION_END


;--------------------
;Post-install section

Section -post

  ; Store install folder in registry
  WriteRegStr HKLM "SOFTWARE\${PRODUCT_NAME}" "" $INSTDIR

  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Show up in Add/Remove programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME} v${VERSION}"
  WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\Uninstall.exe"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\uninstall.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayVersion" "${VERSION}"

SectionEnd

;--------------------------------
;Uninstaller Functions

Function un.onInit

  !insertmacro MUI_UNGETLANGUAGE
  
FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  !insertmacro UnInstallLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED "$INSTDIR\rhvoice\lib32\RHVoiceSvr.dll"
  !define LIBRARY_X64
  ${If} ${RunningX64}
  !insertmacro UnInstallLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED "$INSTDIR\rhvoice\lib64\RHVoiceSvr.dll"
  ${EndIf}
  !undef LIBRARY_X64
  Delete "$INSTDIR\rhvoice\rhvoice\lib32\RHVoiceSvr.dll"
  Rmdir "$INSTDIR\rhvoice\lib32"
  Delete "$INSTDIR\rhvoice\rhvoice\lib64\RHVoiceSvr.dll"
  Rmdir "$INSTDIR\rhvoice\lib64"
  DeleteRegKey HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice"
  ${If} ${RunningX64}
  SetRegView 64
  DeleteRegKey HKLM "Software\Microsoft\Speech\Voices\TokenEnums\RHVoice"
  SetRegView 32
  ${EndIf}
  DeleteRegKey HKLM "Software\RHVoice"
  ${If} ${RunningX64}
  SetRegView 64
  DeleteRegKey HKLM "Software\RHVoice"
  SetRegView 32
  ${EndIf}
  Delete "$INSTDIR\rhvoice\data\languages\Russian\*.*"
  Rmdir "$INSTDIR\rhvoice\data\languages\Russian\"
  Delete "$INSTDIR\rhvoice\data\voices\Anna\*.*"
  Rmdir "$INSTDIR\rhvoice\data\voices\Anna\"
  Delete "$INSTDIR\rhvoice\data\voices\Elena\*.*"
  Rmdir "$INSTDIR\rhvoice\data\voices\Elena\"
  Delete "$INSTDIR\rhvoice\data\voices\Irina\*.*"
  Rmdir "$INSTDIR\rhvoice\data\voices\Irina\"
  Delete "$INSTDIR\rhvoice\data\voices\Aleksandr\*.*"
  Rmdir "$INSTDIR\rhvoice\data\voices\Aleksandr\"
  Delete "$INSTDIR\rhvoice\data\languages\English\*.*"
  Rmdir "$INSTDIR\rhvoice\data\languages\English\"
  Delete "$INSTDIR\rhvoice\data\voices\Alan\*.*"
  Rmdir "$INSTDIR\rhvoice\data\voices\Alan\"
  Delete "$INSTDIR\rhvoice\data\voices\CLB\*.*"
  Rmdir "$INSTDIR\rhvoice\data\voices\CLB\"
  Rmdir "$INSTDIR\rhvoice\data\languages\"
  Rmdir "$INSTDIR\rhvoice\data\voices\"
  Rmdir "$INSTDIR\rhvoice\data\"
  Rmdir "$INSTDIR\rhvoice\"

  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.txt"
  Delete "$INSTDIR\*.ini"
  Delete "$INSTDIR\*.cf"
  Delete "$INSTDIR\*.rpl"
  Delete "$INSTDIR\*.log"
  Delete "$INSTDIR\*.tts"
  Delete "$INSTDIR\LICENSE"
  Delete "$INSTDIR\uninstall.ico"
  Delete "$INSTDIR\langs\*.*"
  Delete "$INSTDIR\script\*.*"
  Delete /REBOOTOK $INSTDIR\uninstall.exe

  RMDir /r "$INSTDIR\langs"
  RMDir /r "$INSTDIR\script"
  RMDir "$INSTDIR"

  SetShellVarContext all
  Delete "$DESKTOP\$(RunMSpeechDesc)"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\$(RunMSpeechDesc)"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\$(RunMSpeechReciverDemoDesc)"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\$(RunSearchAppClassNameDesc)"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\$(DeleteMSpeechDesc)"

  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"

  DeleteRegKey HKLM "SOFTWARE\${PRODUCT_NAME}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

SectionEnd
