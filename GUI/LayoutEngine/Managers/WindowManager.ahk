#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ../Factories/WindowFactory.ahk

class WindowManager {
    static instance := ""
    static allowConstruction := false

    __New() {
        if !WindowManager.allowConstruction
            throw "WindowManager is a singleton and cannot be instantiated directly. Use GetInstance()."
        this.windowFactory := unset
        this.windows := []
    }

    static GetInstance() {
        if WindowManager.instance = "" {
            WindowManager.allowConstruction := true
            WindowManager.instance := WindowManager()
            WindowManager.allowConstruction := false
        }
        return WindowManager.instance
    }

    static Initialize() {
        this.GetInstance().Initialize()
    }

    Initialize() {
        this.windowFactory := WindowFactory()
    }

    static CreateRootWindow(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams) {
        WindowManager.GetInstance().CreateRootWindow(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams)
    }

    CreateRootWindow(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams) {
        this.windows.Push(this.windowFactory.GetElement({ 
            name: appName, appIconPath: appIconPath, styleSheet: styleSheet, 
            inlineStyle: inlineStyle, guiParams: guiParams, id: this.windows.Length + 1
        }))
        currentWindowID := this.windows.Length
        currentWindow := this.windows[currentWindowID]
        entryPoint(currentWindow).Create()
        currentWindow.PrepareForRender(0, currentWindowID)
        currentWindow.RenderAllComponents()
        currentWindow.Show()
    }
}
