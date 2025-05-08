#Requires AutoHotkey v2.0
#Include ../../Root.ahk
#Include ../Renderer.ahk
#Include ./Style.ahk
#Include ./EventDispatcher.ahk
#Include ../Utils/StyleBuilder.ahk

; Alignment Styles:
; x, y, height, width, display, flex-direcion, justify-content, align-items, background-color, color

class Component {
    __New(name, styleSheet := 0, parent := 0) {
        this.name := name
        this.parent := parent
        this.style := StyleBuilder.Build(name, styleSheet)
        this.children := []
        this.positionIsResolved := false
        this.control := unset
        this.eventHandlers := Map()
    }

    Initialize(depth := 0) {
        this.style.ResolvePosition(this, this.parent)
        this.SetPositionResolved()
        if this.parent != 0 {
            Renderer.Add(this, depth)
        }
        for child in this.children {
            child.Initialize(depth + 1)
        }
        return this
    }

    SetPositionResolved() {
        this.positionIsResolved := true
    }

    AddChild(name, styleSheet) {
        child := Component(name, styleSheet, this)
        this.children.Push(child)
        return child
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

    ResolveDimensions() {
        return this.style.dimension.Resolve(this.parent)
    }

    On(event, callback) {
        this.eventHandlers[event] := callback
        EventDispatcher.Register(this, event)
    }

    FireEvent(event) {
        if this.eventHandlers.Has(event) {
            handler := this.eventHandlers[event]
            if IsSet(handler)
                handler.Call(this)
        }
    }

    Render() {
        this.control := root.GetWindow().AddText(this.style.ToString())
    }

    ToString() {
        return Format("{}: {}", this.name, this.style.ToString())
    }
}