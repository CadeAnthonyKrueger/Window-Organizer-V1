#Requires AutoHotkey v2.0

#Include ../Styling/Utils/StyleBuilder.ahk
#Include ../Utils/Validator.ahk
#Include ../Input/EventDispatcher.ahk

class Component {
    __New() {
        this.parentWindow := unset
        this.name := unset
        this.parent := unset
        this.style := unset
        this.children := []
        this.positionIsResolved := false
        this.control := unset
        this.eventHandlers := Map()
        this.depth := unset
        this.childGroupIndex := unset
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

    ResolvePosition() {
        this.style.ResolvePosition(this, this.parent)
        this.SetPositionResolved()
        for child in this.children {
            child.ResolvePosition()
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
        if !this.parentWindow {
            this.parentWindow := this.parentWindow
        }
        componentManager := this.parentWindow.GetComponentManager()
        child := componentManager.CreateComponent(name, styleSheet, inlineStyle, this)
        this.children.Push(child)
        this.depth := this.parent.depth + 1
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

    SetParentGroupIndex(callback) {
        this.parent.childGroupIndex := this.parent ? callback(this.parent.childGroupIndex) : 1
    }

    SetChildGroupIndex(callback) {
        this.childGroupIndex := callback(this.childGroupIndex)
    }

    SetListIndex(callback) {
        this.listIndex := callback(this.listIndex)
    }

    Render() {
        this.control := this.parentWindow.GetWindow().AddText(this.style.ToString())
    }

    ToString() {
        return Format("{}: {}", this.name, this.style.ToString())
    }
}