; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.


;
; Key remapping.
;

CapsLock::Ctrl


;
; Those are keyboard shortcuts for applications
;

; Home directory
#f::Run C:\Users\massimo\

; Terminal
#Return::Run %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe
;C:\Windows\SysWOW64\cmd.exe /c ""C:\Program Files (x86)\Git\bin\sh.exe" --login -i"

; Emacs 
#e::
IfWinExist emacs@FRATOCCHIO
	WinActivate
else
 	Run "C:\Program Files (x86)\Emacs\bin\runemacs.exe"
return

; Web browser
#w::
ifWinExist ahk_class MozillaUIWindowClass
{
  WinActivate
}
else
{
  Run "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
  WinWait ahk_class MozillaUIWindowClass
  WinActivate
}
return

;
; Various keys I got used to on Linux
;
<^>!a::à
<^>!e::è
<^>!i::ì
<^>!o::ò
<^>!u::ù


;
; Windows managing
;
#m::WinMaximize, A  ; Assign a hotkey to maximize the active window.

#Esc::WinClose, A   ; Assign a hotkey to close the active window.
