#Requires AutoHotkey v2.0 

class TreeInfo {
    __New(component, depth) {
        this.component := component 
        this.depth := depth
        this.childGroupIndex := unset
        this.listIndex := unset
    }

    GetTreeInfo(&depth, &parentGroupIndex, &listIndex) {
        depth := this.depth
        parentGroupIndex := this.GetParentGroupIndex()
        listIndex := this.listIndex
    }

    SetParentGroupIndex(callback) {
        this.component.relationships.parent.treeInfo.childGroupIndex := this.component.parent ? callback(this.component.parent.childGroupIndex) : 1
    }

    SetChildGroupIndex(callback) {
        this.childGroupIndex := callback(this.childGroupIndex)
    }

    SetListIndex(callback) {
        this.listIndex := callback(this.listIndex)
    }

    GetParentGroupIndex() {
        return this.component.relationships.parent.treeInfo.childGroupIndex
    }

    GetParentListIndex() {
        return this.component.relationships.parent.treeInfo.listIndex
    }

    GetChildGroupIndex() {
        return this.childGroupIndex
    }

    GetListIndex() {
        return this.listIndex
    }

    GetDepth() {
        return this.depth
    }
}










