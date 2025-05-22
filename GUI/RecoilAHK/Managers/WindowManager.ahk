#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ../Factories/WindowFactory.ahk
#Include ../Utils/MapHelper.ahk

class WindowManager {
    static instance := ""
    static allowConstruction := false

    __New() {
        if !WindowManager.allowConstruction
            throw "WindowManager is a singleton and cannot be instantiated directly. Use GetInstance()."
        this.windowFactory := unset
        this.windowRegistry := unset
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
        WindowManager.GetInstance().Initialize()
    }

    Initialize() {
        this.windowFactory := WindowFactory()
        this.windowRegistry := Map()
    }

    static CreateRootWindow(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams) {
        return WindowManager.GetInstance().CreateRootWindow(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams)
    }

    CreateRootWindow(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams) {
        ; Root window is always named "Main" for hardcoded engine logic
        return WindowManager.CreateWindow(entryPoint, "Main", appName, appIconPath, styleSheet, inlineStyle, guiParams)
    }

    static CreateWindow(entryPoint, name, windowTitle, iconPath, styleSheet, inlineStyle, guiParams) {
        return WindowManager.GetInstance().CreateWindow(entryPoint, name, windowTitle, iconPath, styleSheet, inlineStyle, guiParams)
    }

    CreateWindow(entryPoint, name, windowTitle, iconPath, styleSheet, inlineStyle, guiParams) {
        this.windowRegistry[name] := this.windowFactory.GetElement({ 
            name: name, windowTitle: windowTitle, iconPath: iconPath, 
            styleSheet: styleSheet, inlineStyle: inlineStyle, guiParams: guiParams
        })
        currentWindow := this.windowRegistry.Set(name)
        ; Initialize all components and build up the component tree starting from the provided entry point for a given window
        entryPoint(currentWindow).Create()
        ; Once all components are initialized, resolve absolute and relative layouts recursively, starting from the given window
        currentWindow.ResolveLayout()
        return currentWindow
    }

    static ShowWindow(windowName) {
        WindowManager.GetInstance().ShowWindow(windowName)
    }

    ShowWindow(windowName) {
        this.windowRegistry.Get(windowName).Show()
    }
}
