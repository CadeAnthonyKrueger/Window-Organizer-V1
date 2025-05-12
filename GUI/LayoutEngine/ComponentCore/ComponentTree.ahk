#Requires AutoHotkey v2.0 

#Include ../Utils/ArrayHelper.ahk

; ComponentTree is responsible for keeping a structured ordering of all the active components for a given window.
; This is used to perform efficient operations on components as well as keep things in proper order for rendering.
class ComponentTree {
    __New() {
        this.nestedTree := []
        this.removedIndexes := []
    }

    ; O(k) worst case, where k is the length of a given parentChildList
    Add(component) {
        ; depth => distance from the root; parentGroupIndex => parent's index reference to it's children in the layer below
        component.GetRenderInfo(&depth, &parentGroupIndex)
        ; Create new layer if not already exists
        if !this.nestedTree.Has(depth) or this.nestedTree[depth] = "" {
            this.nestedTree[depth] := Map("parentChildLists", [])
        }
        currentDepth := this.nestedTree[depth]
        ; Create new list of children (corresponding to a single parent in the layer above) if not already exists for a given depth
        if parentGroupIndex = "" {
            parentGroupIndex := currentDepth["parentChildLists"].Length
            component.SetParentGroupIndex((prev) => parentGroupIndex)
            currentDepth["parentChildLists"].Push({ 
                parentGroup: parentGroupIndex, 
                parentIndex: component.parent.listIndex,
                list: []
            })
        }
        ; Insert into the proper child list based on zIndex and save its place in the child list (updating other list indexes as you go)
        listIndex := ArrayHelper.ReverseInsert(
            arr := currentDepth["parentChildLists"][parentGroupIndex].list, 
            el := component,
            func := (el) => IsObject(el) ? el.SetListIndex((prev) => prev - 1) : "",
            cond := (el1, el2) => el1.GetZIndex() < (IsObject(el2) ? el2.GetZIndex() : -(1.0 / 0))
        )
        component.SetListIndex((prev) => listIndex)
    }

    ; O(k) where k is the number of child components, added time if tree needs to compact afterwards
    Remove(component, initialCall := true) {
        ; listIndex => the index of this component within its respective child list
        component.GetRenderInfo(&depth, &parentGroupIndex, &listIndex)
        this.nestedTree[depth]["parentChildLists"][parentGroupIndex].list[listIndex] := ""
        this.removedIndexes.Push(
            Map("depth", depth, "parentGroupIndex", parentGroupIndex, "listIndex", listIndex)
        )
        ; Recursively remove all child components as well
        for childComponent in component.children {
            this.Remove(childComponent, false)
        }
        ; If the tree has too many empty values, we want to compact it
        if this.removedIndexes.Length >= 75 and initialCall {
            this.CompactTree()
            this.removedIndexes := []
        }
    }

    ; O(n) worst case, but usually better depending on how deep startingComponent is in the tree
    ForEach(callback, startingComponent := "") {
        ; callback => func for ops on components; startingComponent => indicates where we start from in the tree
        if !startingComponent {
            try startingComponent := this.nestedTree[1]["parentChildLists"][1][1]
            catch 
                return
        }        
        startingComponent.GetRenderInfo(&depth, &parentGroupIndex, &listIndex)
        ; Here we iterate every component on the same depth level as or below our component
        onFirstIteration := true
        currentDepthIndex := depth
        ; These lambdas are used for each loop to determine order of traversal (forward or reverse)
        condition := (index, length) => index <= length
        setIndex := (index, list) => onFirstIteration ? index : 1
        while condition(currentDepthIndex, this.nestedTree.Length) {
            ; Iterate every parent's child group including and after the group of starting component
            parentChildLists := this.nestedTree[currentDepthIndex]["parentChildLists"]
            currentGroupIndex := setIndex(parentGroupIndex, parentChildLists)
            while condition(currentGroupIndex, parentChildLists.Length) {
                ; Iterate every component in a given child group including and after the position of our starting component
                componentGroup := parentChildLists[currentGroupIndex]
                currentListIndex := setIndex(listIndex, componentGroup)
                while condition(currentListIndex, componentGroup.Length) {
                    ; Perform callback on every subsequent component in the tree
                    currentComponent := componentGroup.list[currentListIndex]
                    if currentComponent {
                        callback(currentComponent)
                    }
                    currentListIndex++
                }
                currentGroupIndex++
            }
            onFirstIteration := false
            currentDepthIndex++
        }
    }

    ; O(r x m) worst case, where r is # of removed components (75 max) and m is # of components in the tree
    CompactTree() {
        ; For every space in the tree that has been removed 
        for emptySpace in this.removedIndexes {
            if !this.nestedTree.Has(emptySpace["depth"]) {
                continue
            }
            parentChildLists := this.nestedTree[emptySpace["depth"]]["parentChildLists"]
            ; Represents the layer above. Used to adjust parent child group indexes accordingly
            parentLists := this.nestedTree[emptySpace["depth"] - 1]["parentChildLists"]
            componentGroup := parentChildLists[emptySpace["parentGroupIndex"]]
            componentGroup.list.RemoveAt(emptySpace["listIndex"])
            ; Shift all subsequent component's list index by -1
            for component in ArrayHelper.SliceArray(componentGroup.list, emptySpace["listIndex"]) {
                if component {
                    component.SetListIndex((prev) => prev - 1)
                }
            }
            ; Now that a component has been removed, check if a parent's child group needs to be removed
            if componentGroup.list.Length == 0 {
                parentChildLists.RemoveAt(emptySpace["parentGroupIndex"])
                ; Update parent index ref to it's child group in the depth below, shifting by -1
                for group in ArrayHelper.SliceArray(parentChildLists, emptySpace["parentGroupIndex"]) {
                    parentLists[group.parentGroup][group.parentIndex].SetChildGroupIndex((prev) => prev - 1)
                }
                
                ; If this results in an entire depth being empty, this is the lowest depth in the tree and can be removed
                if parentChildLists.Length == 0 {
                    this.nestedTree.Length := emptySpace["depth"] - 1
                }
            }
        }
    }
}

; EXAMPLE:
;
; removed = 
;
; current = c1.3.1
; depth = 3
; parentGroupIndex = 
; listIndex = 
;
; [
;     [[c1, c2]],
;     [[c1.3, c1.2, c1.1], [""]],
;     [["", c1.2.2], [c1.1.1], [c1.3.1]]
; ]
;
; c1 z=1 depth=1 group=1 index=1
;     c1.1 z=100 depth=2 group=2 index=3
;         c1.1.1 z=10 depth=3 group= index=1
;     c1.2 z=2 depth=2 group=1 index=2
;         c1.2.2 z=9 depth=3 group= index=2
;     c1.3 z=1 depth=2 group= index=1
;         c1.3.1 z=0 depth=3 group= index=1
; c2 z=1 depth=1 group=2 index=2
;
; c1.1.AddChild(c1.1.1, z=10)
; c2.2.1.1.AddChild(c2.2.1.1.1, z=0)
; c2.2.1.1.AddChild(c2.2.1.1.2, z=-1)
; c1.AddChild(c1.3, z=1)
; c2.2.1.AddChild(c2.2.1.2, z=4)
; Remove(c2.2)
; CompactTree()
; c1.3.AddChild(c1.3.1, z=0)
; Remove(c2.1)
; Remove(c1.2.1)
; c1.2.AddChild(c1.2.2, z=9)











; [
;     [[c1, c2]],
;     [[c1.2, c1.1], [c2.2, c2.1]],
;     [[c1.2.1], [c2.2.1, c2.2.2]],
;     [[c2.2.1.1]]
; ]
;
; c1 z=1 depth=1 group=1 index=1
;     c1.1 z=100 depth=2 group= index=2
;     c1.2 z=2 depth=2 group=1 index=1
;         c1.2.1 z=0 depth=3 group= index=1
; c2 z=1 depth=1 group=2 index=2
;     c2.1 z=10 depth=2 group= index=2
;     c2.2 z=0 depth=2 group=2 index=1
;         c2.2.1 z=0 depth=3 group=1 index=1
;             c2.2.1.1 z=0 depth=4 group= index=1
;         c2.2.2 z=0 depth=3 group= index=2
