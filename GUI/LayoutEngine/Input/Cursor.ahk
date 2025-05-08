#Requires AutoHotkey v2.0
#SingleInstance Force

class Cursor {
    static current := "Arrow"  ; Default cursor is Arrow
    static hCursor := 0
    static types := Map(
        "Arrow",        32512,
        "Hand",         32649,
        "Wait",         32514,
        "Cross",        32515,
        "IBeam",        32513,
        "SizeAll",      32646,
        "SizeWE",       32644,
        "SizeNS",       32645,
        "SizeNESW",     32643,
        "SizeNWSE",     32642,
        "UpArrow",      32516,
        "No",           32648,
        "AppStarting",  32650,
        "Help",         32651
    )

    ; Initialize the cursor by setting up the OnMessage hook
    static Initialize() {
        ; Only intercept the WM_SETCURSOR message if the cursor is not Arrow
        if (Cursor.current != "Arrow")
            OnMessage(0x20, (wParam, lParam, msg, hwnd) => Cursor.OnSetCursor(wParam, lParam, msg, hwnd))  ; Handle WM_SETCURSOR message
    }

    ; Set the cursor type and update the cursor
    static Set(type) {
        if Cursor.current = type
            return

        Cursor.current := type
        Cursor.hCursor := Cursor.Load(Cursor.types[type])
        DllCall("SetCursor", "Ptr", Cursor.hCursor)

        ; If the cursor is not "Arrow", intercept the WM_SETCURSOR message
        if (Cursor.current != "Arrow")
            OnMessage(0x20, (wParam, lParam, msg, hwnd) => Cursor.OnSetCursor(wParam, lParam, msg, hwnd))  ; Handle WM_SETCURSOR message
        else
            OnMessage(0x20, (*) => "")  ; This line is now corrected to remove the hook properly
    }

    ; Load the cursor from the system resources
    static Load(id) {
        static IMAGE_CURSOR := 2, LR_DEFAULTSIZE := 0x40, LR_SHARED := 0x8000
        return DllCall("User32.dll\LoadImage", "Ptr", 0, "Ptr", id, "UInt", IMAGE_CURSOR,
                       "Int", 0, "Int", 0, "UInt", LR_DEFAULTSIZE | LR_SHARED, "Ptr")
    }

    ; The function that gets called when WM_SETCURSOR is triggered
    static OnSetCursor(wParam, lParam, msg, hwnd) {
        if (Cursor.hCursor)
            DllCall("SetCursor", "Ptr", Cursor.hCursor)
        return true  ; Prevent Windows from overriding the cursor
    }
}