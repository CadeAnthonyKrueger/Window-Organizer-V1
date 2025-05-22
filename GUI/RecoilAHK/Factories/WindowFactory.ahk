#Requires AutoHotkey v2.0 

#Include ./AbstractFactory.ahk
#Include ../ComponentCore/Window.ahk

class WindowFactory extends AbstractFactory {
    CreateNew() {
        return Window()
    }
}