#Requires AutoHotkey v2.0

#Include ../Utils/Validator.ahk
#Include ./Composition/Relationships.ahk
#Include ./Composition/TreeInfo.ahk
#Include ./Composition/Positioner.ahk
#Include ./Composition/EventHandler.ahk
#Include ../Styling/Utils/StyleBuilder.ahk

; The base building block object that represents what will be displayed within the GUI
class Component {
    ; Component starts out as mostly empty data object before initialized
    __New() {
        this.name := unset
        ; Compositional classes of a componenent (separates concerns and removes bloat in Component class)
        this.relationships := unset
        this.treeInfo := unset
        this.positioner := unset
        this.style := unset
        this.eventHandler := unset
        ; Graphical representation of what this component is (all of its styles and functionality)
        this.control := unset
    }
    
    ; Initialize the component with instance specific paramaters, separate from __New so the factory can reuse components
    Initialize(params) {
        MsgBox(params.name)
        MapHelper.PrintMap(params)
        validParams := Map("name", "", "styleSheet", "", "inlineStyle", {}, "parentWindow", this, "parent", "", "depth", 0)
        validParams := Validator.ValidateParams(params, validParams, ["name"])

        this.name := validParams["name"]
        this.relationships := Relationships(this, validParams["parentWindow"], validParams["parent"])
        this.treeInfo := TreeInfo(this, validParams["depth"])
        this.positioner := Positioner(this)
        this.style := StyleBuilder.Build(validParams["name"], validParams["styleSheet"], validParams["inlineStyle"])
        this.eventHandler := EventHandler(this)
    }

    ; Free up all memory used by component's instance specific data, remove component from relevant locations (component tree and parent's children)
    Deinitialize() {
        this.name := unset

        try this.relationships.component := unset
        this.relationships := unset

        try this.treeInfo.component := unset
        this.treeInfo := unset

        try this.positioner.component := unset
        this.positioner := unset
        
        this.style := unset

        try this.eventHandler.component := unset
        this.eventHandler := unset
        
        try this.control.Destroy()
        this.control := unset
    }

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Relationship Methods for handling the dynamic beween a component and its parent, children, parent window, and manager
    AddChild(name, styleSheet, inlineStyle := {}) {
        MsgBox(name)
        MsgBox(styleSheet)
        return this.relationships.AddChild(name, styleSheet, inlineStyle)
    }

    GetChildren() {
        return this.relationships.children
    }

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Tree Info methods for dealing with position and order within the component tree
    GetTreeInfo(&depth, &parentGroupIndex, &listIndex) {
        return this.treeInfo.GetTreeInfo(&depth, &parentGroupIndex, &listIndex)
    }

    SetParentGroupIndex(callback) {
        this.treeInfo.SetParentGroupIndex(callback)
    }

    SetChildGroupIndex(callback) {
        this.treeInfo.SetChildGroupIndex(callback)
    }

    SetListIndex(callback) {
        this.treeInfo.SetListIndex(callback)
    }

    GetParentGroupIndex() {
        return this.treeInfo.GetParentGroupIndex()
    }

    GetParentListIndex() {
        return this.treeInfo.GetParentListIndex()
    }

    GetChildGroupIndex() {
        return this.treeInfo.GetChildGroupIndex()
    }

    GetListIndex() {
        return this.treeInfo.GetListIndex()
    }

    GetDepth() {
        return this.treeInfo.GetDepth()
    }

    GetZIndex() {
        return this.style.alignment.zIndex
    }

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Positioner methods for handling dimensions and placement within the GUI
    ResolvePosition() {
        return this.positioner.ResolvePosition()
    }

    ResolveDimensions() {
        return this.positioner.ResolveDimensions()
    }

    SetPositionResolved() {
        this.positioner.SetPositionResolved()
    }
    
    GetClientPos(&x, &y, &w, &h) {
        this.positioner.GetClientPos(&x, &y, &w, &h)
    }

    GetDimensions() {
        return this.style.dimension
    }

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Event handling methods used for a given component and any events they subscribe to
    On(event, callback) {
        this.eventHandler.On(event, callback)
    }

    FireEvent(event) {
        this.eventHandler.FireEvent(event)
    }

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Methods related to styling and rendering based on those styles
    ApplyStyle(style) {
        this.style.Merge(style)
        ; Render all components on top of the current component visually
        this.relationships.GetComponentManager().RenderFrom(this)
    }

    ToString() {
        return Format("{}: {}", this.name, this.style.ToString()) 
    }

    ; Main rendering call for a single component (usually used in batch renders)
    Render() {
        this.control := this.relationships.parentWindow.GetWindow().AddText(this.style.ToString())
    }
}