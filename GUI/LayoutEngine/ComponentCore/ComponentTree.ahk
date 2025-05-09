#Requires AutoHotkey v2.0 

class ComponentTree {
    __New() {
        this.nestedTree := []
        this.renderList := []
    }

    Add(component, depth) {
        ; Add to nested tree first
        if depth > this.nestedTree.Length {
            this.nestedTree.Push([])
        }
        this.nestedTree[depth].Push(component)
    }
}