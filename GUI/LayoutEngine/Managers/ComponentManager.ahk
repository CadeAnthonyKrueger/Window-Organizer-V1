#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ../Factories/ComponentFactory.ahk
#Include ../ComponentCore/ComponentTree.ahk

class ComponentManager {
    static instance := ""
    static allowConstruction := false

    __New() {
        if !ComponentManager.allowConstruction
            throw "ComponentManager is a singleton and cannot be instantiated directly. Use GetInstance()."
        this.componentFactory := unset
        this.componentTree := unset
    }

    static GetInstance() {
        if ComponentManager.instance = "" {
            ComponentManager.allowConstruction := true
            ComponentManager.instance := ComponentManager()
            ComponentManager.allowConstruction := false
        }
        return ComponentManager.instance
    }

    static Initialize() {
        this.GetInstance().Initialize()
    }

    Initialize() {
        this.componentFactory := ComponentFactory()
        this.componentTree := ComponentTree()
    }
}
