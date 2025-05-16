#Requires AutoHotkey v2.0 

class Positioner {
    __New(component) {
        this.component := component
        this.positionIsResolved := false
    }

    ResolvePosition() {
        this.component.style.ResolvePosition(this, this.parent)
        this.SetPositionResolved()
        for child in this.component.relationships.children {
            child.ResolvePosition()
        }
        return this.component
    }

    ResolveDimensions() {
        return this.component.style.dimension.Resolve(this.parent)
    }

    SetPositionResolved() {
        this.positionIsResolved := true
    }
    
    GetClientPos(&x, &y, &w, &h) {
        x := this.component.style.dimension.x
        y := this.component.style.dimension.y
        w := this.component.style.dimension.w
        h := this.component.style.dimension.h
    }

    GetDimensions() {
        return this.component.style.dimension
    }
}