#Requires AutoHotkey v2.0
#Include ./EventDispatcher.ahk

class MouseTracker {
    static instance := ""

    __New(window) {
        this.window := window
        this.textCtrl := ""
        this.windowMouseX := 0
        this.windowMouseY := 0
        SetTimer(this.Track.Bind(this), 30)
    }

    static GetInstance(window := unset) {
        try {
            if MouseTracker.instance = ""
            {
                if !IsSet(window)
                    throw Error("MouseTracker requires a window on first call to GetInstance()")
                MouseTracker.instance := MouseTracker(window)
            }
        } catch {
            if !IsSet(window)
                throw Error("MouseTracker requires a window on first call to GetInstance()")
            MouseTracker.instance := MouseTracker(window)
        }
        return MouseTracker.instance
    }

    static Initialize(window) {
        inst := MouseTracker.GetInstance(window)
        inst.textCtrl := inst.window.GetWindow().AddText("x10 y10 w200", "")
    }

    Track() {
        MouseGetPos(&x, &y)
        this.window.GetWindowCoords(&windowX, &windowY)
        previousX := this.windowMouseX
        previousY := this.windowMouseY
        this.windowMouseX := x - windowX
        this.windowMouseY := y - windowY
        if previousX != this.windowMouseX or previousY != this.windowMouseY {
            this.textCtrl.Value := "Mouse in GUI: x=" this.windowMouseX ", y=" this.windowMouseY
            EventDispatcher.HandleMouseMove(this.windowMouseX, this.windowMouseY)
        }
    }
}
