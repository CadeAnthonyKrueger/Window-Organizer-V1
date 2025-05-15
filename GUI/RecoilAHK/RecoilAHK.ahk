#Requires AutoHotkey v2.0 
#SingleInstance Force

#Include ./Engine.ahk
#Include ./Managers/WindowManager.ahk

class RecoilAHK {
    static CreateRoot(entryPoint, appName := unset, appIconPath := unset, styleSheet := unset, inlineStyle := unset, guiParams := unset) {
        Engine.CreateRoot(entryPoint, appName, appIconPath, styleSheet, inlineStyle, guiParams) 
    }

    static CreateWindow(entryPoint, name, title, iconPath := unset, styleSheet := unset, inlineStyle := unset, guiParams := unset) {
        WindowManager.CreateWindow(entryPoint, name, title, iconPath, styleSheet, inlineStyle, guiParams)
    }

    static ShowWindow(name) {
        WindowManager.ShowWindow(name)
    }

}