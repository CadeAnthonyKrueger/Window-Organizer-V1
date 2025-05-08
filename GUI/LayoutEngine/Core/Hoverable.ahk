#Requires AutoHotkey v2.0 

class Hoverable {
    __New(component) {
        this.component := component
        this.hovered := false
    }

    HandleMouseMove(x, y) {
        dim := this.component.GetDimensions()
        inBounds := (x >= dim.x && x <= dim.x + dim.w && y >= dim.y && y <= dim.y + dim.h)

        if inBounds && !this.hovered {
            this.hovered := true
            this.component.FireEvent("mouseEnter")
        } else if !inBounds && this.hovered {
            this.hovered := false
            this.component.FireEvent("mouseExit")
        }
    }
}
