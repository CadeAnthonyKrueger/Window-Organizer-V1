#Requires AutoHotkey v2.0 

class TreeInfo {
    __New(component, depth) {
        this.component := component 
        this.childGroupIndex := unset
        this.listIndex := unset
    }

    SetParentGroupIndex(callback) {
        component.relationships.parent.childGroupIndex := this.parent ? callback(this.parent.childGroupIndex) : 1
    }

    SetChildGroupIndex(callback) {
        this.childGroupIndex := callback(this.childGroupIndex)
    }

    SetListIndex(callback) {
        this.listIndex := callback(this.listIndex)
    }

    GetZIndex() {
        return component.style.alignment.zIndex
    }
}










