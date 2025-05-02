#Requires AutoHotkey v2.0
#Include ../Root.ahk
#Include ../LayoutEngine/Renderer.ahk
#Include ../LayoutEngine/Core/Style.ahk

; Alignment Styles:
; x, y, height, width, display, flex-direcion, justify-content, align-items, background-color, color

class Container {
    __New(name, parent := root, style := Style()) {
        this.name := name
        this.parent := parent
        this.style := style
        this.children := []
        this.positionIsResolved := false
        this.control := unset
    }

    Initialize(depth := 1) {
        if !this.positionIsResolved {
            this.style.ResolvePosition(this, this.parent)
            this.SetPositionResolved()
        }
        Renderer.Add(this, depth)
        for child in this.children {
            child.Initialize(depth + 1)
        }
    }

    SetPositionResolved() {
        this.positionIsResolved := true
    }

    AddChild(name, style) {
        child := Container(name, this, style)
        this.children.Push(child)
        return child
    }

    GetClientPos(&x, &y, &w, &h) {
        x := this.style.dimension.x
        y := this.style.dimension.y
        w := this.style.dimension.w
        h := this.style.dimension.h
    }

    Render() {
        this.control := root.AddText(this.style.ToString())
    }

    ToString() {
        return Format("{}: {}", this.name, this.style.ToString())
    }
}