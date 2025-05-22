#Requires AutoHotkey v2.0

#Include ../Factories/ComponentFactory.ahk
#Include ../ComponentCore/ComponentTree.ahk
#Include ../Rendering/ComponentRenderer.ahk
#Include ../Utils/Stack.ahk

class ComponentManager {
    __New() {
        this.componentFactory := ComponentFactory()
        this.componentTree := ComponentTree()
    }

    CreateComponent(name, styleSheet, inlineStyle, parentWindow, parent, depth) {
        newComponent := this.componentFactory.GetElement({ 
            name: name, styleSheet: styleSheet, inlineStyle: inlineStyle, parentWindow: parentWindow, parent: parent, depth: depth
        })
        this.componentTree.Add(newComponent)
        return newComponent
    }

    ; Need to remove all children of the removed component as well. Our tree will never have any orphaned nodes.
    RemoveComponent(component) {
        ; Create a stack so lowest level children will be processed before parents
        stack := Stack.CreateChildStack(component, (current) => current.GetChildren())
        ; Deinitialize from leaf to root
        while stack.Length > 0 {
            current := stack.Pop()
            this.componentTree.Remove(current)
            this.componentFactory.RecycleElement(current)
        }
    }

    RenderAll() {
        ComponentRenderer.RenderAll(this.componentTree)
    }

    RenderFrom(component) {
        ComponentRenderer.RenderAll(this.componentTree, component)
    }
}
