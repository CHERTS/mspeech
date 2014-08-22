!include "MUI2.nsh"
!include "UAC.nsh"

!define HOME ".\base\"

!define PRODUCT_NAME "MSpeech"
!define NAME "MSpeech"
!define VERSION 1.4.1
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
  RequestExecutionLevel user

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

;--------------------------------
;Language Strings

LangString SecAddShortcutsDesc ${LANG_RUSSIAN} "Добавить ярлыки в меню Пуск"
LangString SecAddShortcutsDesc ${LANG_ENGLISH} "Add shortcuts to Start Menu"

LangString SecAddShortcutsInDesktopDesc ${LANG_RUSSIAN} "Добавить ярлык на Рабочий стол"
LangString SecAddShortcutsInDesktopDesc ${LANG_ENGLISH} "Add shortcut to the Desktop"

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
  File "${HOME}\MSpeech.cf"
  File "${HOME}\MSpeech.ini"
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

;--------------------------------
;Language Strings

  LangString DESC_SecMainProgramUserSpace ${LANG_RUSSIAN} "Установить программу."
  LangString DESC_SecAddShortcuts ${LANG_RUSSIAN} "Добавить ярлыки в меню Пуск."
  LangString DESC_SecAddShortcutsInDesktop ${LANG_RUSSIAN} "Добавить ярлык на Рабочий стол."

  LangString DESC_SecMainProgramUserSpace ${LANG_ENGLISH} "Install main programms."
  LangString DESC_SecAddShortcuts ${LANG_ENGLISH} "Add shortcuts to the current user's Start Menu."
  LangString DESC_SecAddShortcutsInDesktop ${LANG_ENGLISH} "Add shortcuts to the Desktop."

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMainProgramUserSpace} $(DESC_SecMainProgramUserSpace)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddShortcuts} $(DESC_SecAddShortcuts)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddShortcutsInDesktop} $(DESC_SecAddShortcutsInDesktop)
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

  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.txt"
  Delete "$INSTDIR\*.ini"
  Delete "$INSTDIR\*.cf"
  Delete "$INSTDIR\*.rpl"
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
