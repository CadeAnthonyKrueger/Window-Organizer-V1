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

    CreateComponent(name, styleSheet, inlineStyle, parent) {
        newComponent := this.componentFactory.GetElement({ name: name, styleSheet: styleSheet, inlineStyle: inlineStyle, parent: parent})
        this.componentTree.Add(newComponent)
        return newComponent
    }

    ; O(k) where k is the number of child components
    RemoveComponent(component) {
        stack := Stack()
        queue := Stack(component)

        ; Fill stack with full subtree
        while queue.Length > 0 {
            current := queue.Pop()
            stack.Push(current)

            for child in current.GetChildren() {
                queue.Push(child)
            }
        }

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
