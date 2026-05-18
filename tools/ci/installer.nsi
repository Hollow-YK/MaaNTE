!include "MUI2.nsh"
!include "LogicLib.nsh"

; ---------- 动态参数（可在命令行通过 /D 指定） ----------
!ifndef VERSION
  !define VERSION "1.0.0"
!endif
!ifndef ARCH
  !define ARCH "x64"
!endif
!ifndef ICON_FILE
  !define ICON_FILE "H:\MAANTE\logo.ico"
!endif
!ifndef SOURCE_DIR
  !define SOURCE_DIR "H:\MAANTE"
!endif

; ---------- 基本信息 ----------
Name "MAANTE"
!ifndef OUTFILE
  !define OUTFILE "MAANTE_Setup.exe"
!endif
OutFile "${OUTFILE}"
InstallDir "D:\MAANTE"
InstallDirRegKey HKLM "Software\MAANTE" "InstallDir"
RequestExecutionLevel admin
SetCompressor lzma

; ---------- 图标（使用动态变量） ----------
!define MUI_ICON "${ICON_FILE}"
!define MUI_UNICON "${ICON_FILE}"

; ---------- 页面 ----------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "SimpChinese"

; ---------- 安装区段 ----------
Section "Install"
    SetOutPath "$INSTDIR"
    ; 使用动态源文件目录
    File /r "${SOURCE_DIR}\*.*"

    ; 创建卸载程序
    WriteUninstaller "$INSTDIR\uninstall.exe"

    ; 注册表（程序和功能）
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "DisplayName" "MAANTE"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "DisplayIcon" "$INSTDIR\logo.ico"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "Publisher" "MAANTE"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "InstallLocation" "$INSTDIR"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "NoRepair" 1
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "DisplayVersion" "${VERSION}"
    ; 如需记录架构，可取消下面注释（非标准字段）
    ; WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE" "Architecture" "${ARCH}"
    
    WriteRegStr HKLM "Software\MAANTE" "InstallDir" "$INSTDIR"

    ; 创建开始菜单快捷方式
    SetShellVarContext all
    CreateDirectory "$SMPROGRAMS\MAANTE"
    CreateShortCut "$SMPROGRAMS\MAANTE\MAANTE.lnk" "$INSTDIR\MAANTE.exe" "" "$INSTDIR\logo.ico" 0
    CreateShortCut "$SMPROGRAMS\MAANTE\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\logo.ico" 0

    ; 创建桌面快捷方式
    CreateShortCut "$DESKTOP\MAANTE.lnk" "$INSTDIR\MAANTE.exe" "" "$INSTDIR\logo.ico" 0
SectionEnd

; ---------- 卸载区段 ----------
Section "Uninstall"
    SetShellVarContext all
    Delete "$SMPROGRAMS\MAANTE\MAANTE.lnk"
    Delete "$SMPROGRAMS\MAANTE\Uninstall.lnk"
    RMDir  "$SMPROGRAMS\MAANTE"
    Delete "$DESKTOP\MAANTE.lnk"
    RMDir /r "$INSTDIR"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MAANTE"
    DeleteRegKey HKLM "Software\MAANTE"
SectionEnd
