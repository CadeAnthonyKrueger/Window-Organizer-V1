#Requires AutoHotkey v2.0 

class Positioning {
    __New(component) {
        this.component := component
    }

    ResolveDimensions() {
        return this.style.dimension.Resolve(this.parent)
    }

    SetPositionResolved() {
        this.component.positionIsResolved := true
    }
    
    GetClientPos(&x, &y, &w, &h) {
        x := this.style.dimension.x
        y := this.style.dimension.y
        w := this.style.dimension.w
        h := this.style.dimension.h
    }

    GetDimensions() {
        return this.style.dimension
    }
}