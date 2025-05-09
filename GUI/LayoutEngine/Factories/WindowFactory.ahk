#Requires AutoHotkey v2.0 

#Include ../ComponentCore/Window.ahk

class WindowFactory {
    CreateNew() {
        return Window()
    }
}