#Requires AutoHotkey v2.0 

#Include ./Component.ahk

class Window extends Component {
    __New(name, styleSheet) {
        super.__New(name, styleSheet, 0)
        TraySetIcon A_ScriptDir "\Assets\logo.ico"
        this.window := Gui("-Caption +AlwaysOnTop", "Window Organizer")
    }

    Show() {
        ; MsgBox(Format("Show GUI: {}", this.style.ToString()))
        this.window.BackColor := this.style.appearance.backgroundColor
        this.window.Show(Format("w{} h{}", this.style.dimension.w, this.style.dimension.h))
    }

    GetWindow() {
        return this.window
    }
}