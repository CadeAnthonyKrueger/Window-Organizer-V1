#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ./Managers/WindowManager.ahk

class Engine {
    static instance := ""
    static isInitialized := false
    static allowConstruction := false

    __New() {
        if !Engine.allowConstruction
            throw "Engine is a singleton and cannot be instantiated directly. Use GetInstance()."
    }

    static GetInstance() {
        if Engine.instance = "" {
            Engine.allowConstruction := true
            Engine.instance := WindowManager()
            Engine.allowConstruction := false
        }
        return Engine.instance
    }

    static CreateRoot(entryPoint, appName := unset, appIconPath := unset, styleSheet := unset, inlineStyle := unset, guiParams := unset) 
    {
        if !Engine.isInitialized {
            Engine.GetInstance().Initialize()
            Engine.isInitialized := true
        }
        WindowManager.CreateRootWindow(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams)
    }

    Initialize() {
        WindowManager.Initialize()
        ; ... other manager inits
        WindowManager.ShowWindow("Main")
    }
}
