#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ./LayoutEngine/Engine.ahk
#Include ./Components/MainView.ahk
#Include ./Utils/Path.ahk

Engine.CreateRoot(
    entryPoint := MainView, 
    appName := "Window Organizer", 
    appIconPath := Path.Resolve(A_LineFile, "Assets/logo.ico"), 
    styleSheet := Path.Resolve(A_LineFile, "Root.ini")
)