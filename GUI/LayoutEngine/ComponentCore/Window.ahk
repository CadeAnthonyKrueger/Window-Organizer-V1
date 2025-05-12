#Requires AutoHotkey v2.0

#Include ./Component.ahk
#Include ../Utils/Validator.ahk
#Include ../Utils/MapHelper.ahk
#Include ../Managers/ComponentManager.ahk

class Window extends Component {
    __New() {
        super.__New()
        this.windowID := unset
        this.windowX := 0
        this.windowY := 0
        this.gui := unset
        this.componentManager := unset
    }

    Initialize(params) {
        splitParams := MapHelper.SplitMap(params, ["name", "styleSheet", "inlineStyle"], ["appIconPath", "guiParams", "id"])
        super.Initialize(splitParams[1])

        validParams := Map("appIconPath", "", "guiParams", "-Caption +AlwaysOnTop", "id", 1)
        validParams := Validator.ValidateParams(splitParams[2], validParams)


        if validParams["appIconPath"] {
            TraySetIcon(validParams["appIconPath"])
        }
        ;CoordMode("Mouse", "Screen")
        this.windowID := validParams["id"]
        this.gui := Gui(validParams["guiParams"], this.name)
        this.componentManager := ComponentManager()
        ;Cursor.Initialize()
    }

    Deinitialize() {
        super.Deinitialize()
    }

    Show() {
        ;MouseTracker.Initialize(this)
        this.window.BackColor := this.style.appearance.backgroundColor
        this.window.Show(Format("w{} h{}", this.style.dimension.w, this.style.dimension.h))
        this.SetWindowCoords()
    }

    SetWindowCoords() {
        this.window.GetClientPos(&x, &y)
        this.windowX := x
        this.windowY := y
    }

    GetWindowCoords(&windowX, &windowY) {
        windowX := this.windowX
        windowY := this.windowY
    }

    GetWindow() {
        return this.gui
    }

    GetComponentManager() {
        return this.componentManager
    }
}