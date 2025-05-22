#Requires AutoHotkey v2.0 

#Include ./AbstractFactory.ahk
#Include ../ComponentCore/Component.ahk

class ComponentFactory extends AbstractFactory {
    CreateNew() {
        return Component()
    }
}