#Requires AutoHotkey v2.0

#Include ../Styling/Utils/StyleBuilder.ahk
#Include ../Utils/Validator.ahk

class Component {
    __New() {
        this.name := unset
        this.parent := unset
        this.style := unset
        this.children := []
        this.positionIsResolved := false
        this.control := unset
        this.eventHandlers := Map()
        this.depth := unset
        this.childGroupIndex := 1
        this.listIndex := unset
    }

    Initialize(params) {
        validParams := Map("name", "", "styleSheet", "", "inlineStyle", {}, "parent", "")
        validParams := Validator.ValidateParams(params, validParams, ["name"])

        this.name := validParams["name"]
        this.parent := validParams["parent"]
        this.style := StyleBuilder.Build(validParams["name"], validParams["styleSheet"], validParams["inlineStyle"])
    }

    Deinitialize() {
        
    }

    PrepareForRender(depth := 0) {
        this.depth := depth
        this.style.ResolvePosition(this, this.parent)
        this.SetPositionResolved()
        if !this.parent {
            Renderer.Add(this, depth)
        }
        for child in this.children {
            child.PrepareForRender(depth + 1)
        }
        return this
    }

    GetRenderInfo(&depth, &parentGroupIndex, &listIndex) {
        depth := this.depth
        if this.parent {
            parentGroupIndex := this.parent.childGroupIndex
        }
        listIndex := this.listIndex
    }

    SetPositionResolved() {
        this.positionIsResolved := true
    }

    AddChild(name, styleSheet, inlineStyle := {}) {
        ; this should be a call to the compnent manager to create a new element
        child := Component(name, styleSheet, inlineStyle, this)
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

    ApplyStyle(style) {
        this.style.Merge(style)
        this.Render()
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

    GetZIndex() {
        return this.style.alignment.zIndex
    }

    SetParentGroupIndex(index) {
        if this.parent {
            this.parent.childGroupIndex := index
        }
    }

    SetListIndex(index) {
        this.listIndex := index
    }

    Render() {
        ; this should be a call to component manager which calls the window managers method to add control to the gui
        this.control := root.GetWindow().AddText(this.style.ToString())
    }

    ToString() {
        return Format("{}: {}", this.name, this.style.ToString())
    }
}