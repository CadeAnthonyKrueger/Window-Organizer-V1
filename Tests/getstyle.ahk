winID := WinGetID("A")  ; "A" = active window
exStyle := WinGetExStyle("ahk_id " winID)

if (exStyle & 0x80) ; WS_EX_TOOLWINDOW
{
    MsgBox("This is likely a popup!")
}
else
{
    MsgBox("This is probably a regular window.")
}
