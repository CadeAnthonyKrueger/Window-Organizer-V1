#Requires AutoHotkey v2.0 

class Relationships {
    __New(component, parentWindow, parent) {
        this.component := component
        this.parentWindow := parentWindow
        this.parent := parent
        this.children := []
        this.componentManager := parentWindow.GetComponentManager()
    }

    AddChild(name, styleSheet, inlineStyle := {}) {
        child := this.componentManager.CreateComponent(name, styleSheet, inlineStyle, this.parentWindow, this, this.component.depth + 1)
        this.children.Push(child)
        return child
    }

    GetComponentManager() {
        return this.componentManager
    }
}