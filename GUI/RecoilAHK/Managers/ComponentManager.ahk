#Requires AutoHotkey v2.0

#Include ../Factories/ComponentFactory.ahk
#Include ../ComponentCore/ComponentTree.ahk
#Include ../Rendering/ComponentRenderer.ahk

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
        ComponentRenderer.RenderAll(this.componentTree)
    }

    RenderFrom(component) {
        ComponentRenderer.RenderAll(this.componentTree, component)
    }
}
