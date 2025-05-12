#Requires AutoHotkey v2.0

#Include ../Factories/ComponentFactory.ahk
#Include ../ComponentCore/ComponentTree.ahk

class ComponentManager {
    __New() {
        this.componentFactory := ComponentFactory()
        this.componentTree := ComponentTree()
    }

    CreateComponent(name, styleSheet, inlineStyle, parent) {
        newComponent := this.componentFactory.GetElement({ name: name, styleSheet: styleSheet, inlineStyle: inlineStyle, parent: parent})
        this.componentTree.Add(newComponent)
        return newComponent
    }

    RenderAll() {
        this.componentTree.ForEach((component) => component.Render())
    }

    RenderFrom(component) {
        this.componentTree.ForEach((component) => component.Render(), component)
    }
}
