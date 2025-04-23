^!t::  ; Press Ctrl + Alt + T to trigger
{
    Send("^t")
    Sleep(200)
    Send("^l")
    Sleep(200)
    Send("EOL")
    Sleep(200)
    Send("^l")
    Sleep(200)
    Send("^c")
    Sleep(200)
    Send("^w")
    Sleep(200)
    MsgBox(A_Clipboard)
}
