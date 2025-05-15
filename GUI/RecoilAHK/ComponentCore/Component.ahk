#Requires AutoHotkey v2.0

#Include ../Styling/Utils/StyleBuilder.ahk
#Include ../Utils/Validator.ahk
#Include ../Input/EventDispatcher.ahk
#Include ./Composition/ComponentRelationships.ahk
#Include ./Composition/TreeInfo.ahk

; The base building block object that represents what will be displayed within the GUI
class Component {
    ; Component starts out as mostly empty data object before initialized
    __New() {
        this.name := unset
        this.relationships := unset
        this.treeInfo := unset
        this.style := unset
        this.positioner := unset


        this.positionIsResolved := false
        this.control := unset
        this.eventHandlers := Map()
    }
    
    ; Initialize the component with instance specific paramaters, separate from __New so the factory can reuse components
    Initialize(params) {
        validParams := Map("name", "", "styleSheet", "", "inlineStyle", {}, "parentWindow", "", "parent", "", "depth", 0)
        validParams := Validator.ValidateParams(params, validParams, ["name"])

        this.name := validParams["name"]
        this.relationships := ComponentRelationships(this, validParams["parentWindow"], validParams["parent"])
        this.treeInfo := TreeInfo(this, validParams["depth"])
        this.style := StyleBuilder.Build(validParams["name"], validParams["styleSheet"], validParams["inlineStyle"])
    }

    ; Free up all memory used by component's instance specific data, remove component from relevant locations (component tree and parent's children)
    Deinitialize() {
        
    }

    ApplyStyle(style) {
        this.style.Merge(style)
        this.Render()
    }

    Render() {
        this.control := this.relationships.parentWindow.GetWindow().AddText(this.style.ToString())
    }

    ToString() {
        return Format("{}: {}", this.name, this.style.ToString()) 
    }
}