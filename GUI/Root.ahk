#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ./RecoilAHK/RecoilAHK.ahk
#Include ./Components/MainView.ahk
#Include ./Utils/Path.ahk

RecoilAHK.CreateRoot(
    entryPoint := MainView, 
    appName := "Window Organizer", 
    appIconPath := Path.Resolve(A_LineFile, "Assets/logo.ico"), 
    styleSheet := Path.Resolve(A_LineFile, "Root.ini")
)