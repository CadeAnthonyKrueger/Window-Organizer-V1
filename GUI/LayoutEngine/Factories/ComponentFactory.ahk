#Requires AutoHotkey v2.0 

#Include ../ComponentCore/Component.ahk

class ComponentFactory {
    CreateNew() {
        return Component()
    }
}