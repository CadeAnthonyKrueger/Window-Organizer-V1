#Requires AutoHotkey v2.0

class MouseTracker {
    __New(window) {
        this.window := window
        this.trackedElements := []
        this.textCtrl := ""
        SetTimer(this.Track.Bind(this), 30)
    }

    Initialize() {
        this.textCtrl := this.window.GetWindow().AddText("x10 y10 w200", "")
    }

    Add(element) {
        this.trackedElements.Push(element)
    }

    Track() {
        MouseGetPos(&x, &y)
        this.window.GetWindowCoords(&windowX, &windowY)
        this.textCtrl.Value := "Mouse in GUI: x=" x - windowX ", y=" y - windowY
        ; if relativeX > 100 and relativeX < 200 and relativeY > 100 and relativeY < 200 {
        ;     MsgBox("In Bounds")
        ; }
    }
}