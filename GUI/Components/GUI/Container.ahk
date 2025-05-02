#Requires AutoHotkey v2.0
#Include ../../MainGUI.ahk
#Include ../Renderer.ahk
#Include ../Utility/Style.ahk

; Alignment Styles:
; x, y, height, width, display, flex-direcion, justify-content, align-items, background-color, color

class Container {
    __New(name, parent := myGUI, style := Style()) {
        this.name := name
        this.parent := parent
        this.style := style
        this.children := []
        this.childrenResolved := false
        this.control := unset
    }

    Initialize(depth := 1) {
        this.style.ResolvePosition(this, this.parent)
        Renderer.Add(this, depth)
        for child in this.children {
            child.Initialize(depth + 1)
        }
    }

    AddChild(name, style) {
        child := Container(name, this, style)
        this.children.Push(child)
        return child
    }

    AreChildrenResolved() {
        return this.childrenResolved
    }

    SetChildrenResolved() {
        this.childrenResolved := true
    }

    GetClientPos(&x, &y, &w, &h) {
        x := this.style.dimension.x
        y := this.style.dimension.y
        w := this.style.dimension.w
        h := this.style.dimension.h
    }

    Render() {
        this.control := myGui.AddText(this.style.ToString())
    }
}