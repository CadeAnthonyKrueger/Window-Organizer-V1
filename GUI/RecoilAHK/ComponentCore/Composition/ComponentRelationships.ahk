#Requires AutoHotkey v2.0 

class ComponentRelationships {
    __New(component, parentWindow, parent) {
        this.component := component
        this.parentWindow := parentWindow
        this.parent := parent
        this.children := []
    }

    AddChild(name, styleSheet, inlineStyle := {}) {
        componentManager := this.parentWindow.GetComponentManager()
        child := componentManager.CreateComponent(name, styleSheet, inlineStyle, this.parentWindow, this, this.component.depth + 1)
        this.children.Push(child)
        return child
    }
}