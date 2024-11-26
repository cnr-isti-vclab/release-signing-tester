; Must modify:
; - DISTRIB_PATH

!define MAINDIR $PROGRAMFILES64
!define PRODUCT_NAME "ReleaseSigningTester"
!define PRODUCT_VERSION "0.1"
!define PRODUCT_PUBLISHER "Alessandro Muntoni - VCG - ISTI - CNR"
!define PRODUCT_WEB_SITE "https://vcg.isti.cnr.it/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\ReleaseSigningTester.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define DISTRIB_FOLDER "DISTRIB_PATH"

; MUI 1.67 compatible -----
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "${DISTRIB_FOLDER}\LICENSE.txt"
; License page
!insertmacro MUI_PAGE_LICENSE "${DISTRIB_FOLDER}\privacy.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES


; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\ReleaseSigningTester.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------
!define /date NOW "%Y_%m_%d"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "ReleaseSigningTester-windows.exe"
InstallDir "${MAINDIR}\VCG\ReleaseSigningTester"
ShowInstDetails show
ShowUnInstDetails show

!include LogicLib.nsh
!include ExecWaitJob.nsh
!include FileAssociation.nsh

Function .onInit
  ReadRegStr $0 HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
  ${If} $0 != "" ;2020.0x...
    MessageBox MB_OK "Please first uninstall old ReleaseSigningTester version. Starting uninstaller now..."
	StrCpy $8 '"$0"'
	!insertmacro ExecWaitJob r8
  ${Else}
    ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ReleaseSigningTester_64b" "UninstallString"
    ${If} $0 != "" ;2016.12
	  MessageBox MB_OK "Please first uninstall old ReleaseSigningTester version. Starting uninstaller now..."
   	  StrCpy $8 '"$0"'
	  !insertmacro ExecWaitJob r8
    ${EndIf}
  ${EndIf}
FunctionEnd

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  ;Let's delete all the dangerous stuff from previous releases.
  ;Shortcuts for currentuser shell context
  RMDir /r "$SMPROGRAMS\ReleaseSigningTester"
  Delete "$DESKTOP\ReleaseSigningTester.lnk"

  ;Shortcuts for allusers
  SetShellVarContext all ;Set alluser context. Icons created later are in allusers
  RMDir /r "$SMPROGRAMS\ReleaseSigningTester"
  Delete "$DESKTOP\ReleaseSigningTester.lnk"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY_S}"

  Delete "$INSTDIR\*"

  SetOverwrite on
  File "${DISTRIB_FOLDER}\ReleaseSigningTester.exe"
  CreateDirectory "$SMPROGRAMS\ReleaseSigningTester"
  CreateShortCut "$SMPROGRAMS\ReleaseSigningTester\ReleaseSigningTester.lnk" "$INSTDIR\ReleaseSigningTester.exe"
  CreateShortCut "$DESKTOP\ReleaseSigningTester.lnk" "$INSTDIR\ReleaseSigningTester.exe"

  ;Copy everything inside DISTRIB
  SetOutPath "$INSTDIR"
  File /nonfatal /a /r "${DISTRIB_FOLDER}\"

SectionEnd

Section -Prerequisites
    ;always install vc_redist
	;ReadRegStr $1 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" "Installed"
	;${If} $1 <> 0
	;	Goto endPrerequisites
	;${Else}
		ExecWait '"$INSTDIR\vc_redist.x64.exe" /q /norestart'
	;${EndIf}
	;endPrerequisites:
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\ReleaseSigningTester.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\ReleaseSigningTester.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Section -AdditionalIcons
  SetShellVarContext all
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\ReleaseSigningTester\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\ReleaseSigningTester\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd


Function un.onInit ;before uninstall starts
  ${If} ${Silent}
    Return
  ${Else}
	MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
	Abort
  ${EndIf}
FunctionEnd

Section Uninstall ;uninstall instructions
  RMDir /r "$INSTDIR"

  ;Remove shortcuts in currentuser profile
  RMDir /r "$SMPROGRAMS\ReleaseSigningTester"
  Delete "$DESKTOP\ReleaseSigningTester.lnk"

  ;Remove shortcuts in allusers profile
  SetShellVarContext all
  RMDir /r "$SMPROGRAMS\ReleaseSigningTester"
  Delete "$DESKTOP\ReleaseSigningTester.lnk"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY_S}"

  SetAutoClose true
SectionEnd

Function un.onUninstSuccess ;after uninstall
  HideWindow
  ${If} ${Silent}
    Return
  ${Else}
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
  ${EndIf}
FunctionEnd
