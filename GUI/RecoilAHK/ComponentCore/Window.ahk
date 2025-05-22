#Requires AutoHotkey v2.0

#Include ./Component.ahk
#Include ../Utils/Validator.ahk
#Include ../Utils/MapHelper.ahk
#Include ../Managers/ComponentManager.ahk

class Window extends Component {
    __New() {
        super.__New()
        this.windowTitle := unset
        this.windowX := 0
        this.windowY := 0
        this.gui := unset
        this.componentManager := unset
    }

    Initialize(params) {
        this.componentManager := ComponentManager()
        splitParams := MapHelper.SplitMap(params, ["name", "styleSheet", "inlineStyle"], ["iconPath", "guiParams", "windowTitle"])
        super.Initialize(splitParams[1])
        MsgBox("HE")
        validParams := Map("iconPath", "", "guiParams", "-Caption +AlwaysOnTop", "windowTitle", "")
        validParams := Validator.ValidateParams(splitParams[2], validParams)


        if validParams["iconPath"] {
            TraySetIcon(validParams["iconPath"])
        }
        ;CoordMode("Mouse", "Screen")
        this.windowTitle := validParams["windowTitle"]
        this.gui := Gui(validParams["guiParams"], this.windowTitle)
        this.depth := 0
        ;Cursor.Initialize()
    }

    Deinitialize() {
        super.Deinitialize()
    }

    ResolveLayout() {
        this.ResolvePosition()
    }

    Show() {
        ;MouseTracker.Initialize(this)
        this.componentManager.RenderAll()
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