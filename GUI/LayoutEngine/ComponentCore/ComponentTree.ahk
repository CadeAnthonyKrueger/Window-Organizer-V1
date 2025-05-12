#Requires AutoHotkey v2.0 

#Include ../Utils/ArrayHelper.ahk

; ComponentTree is responsible for keeping a structured ordering of all the active components for a given window.
; This is used to perform efficeint operations on components as well as keep things in proper order for rendering.
class ComponentTree {
    __New() {
        this.nestedTree := []
        this.dirtyFlagCount := 0
    }

    ; O(log k) worst case, where k is the length of a given parentChildList
    Add(component) {
        ; depth => distance from the root; parentGroupIndex => parent's index reference to it's children in the layer below
        component.GetRenderInfo(&depth, &parentGroupIndex)
        ; Create new layer if not already exists
        if !this.nestedTree.Has(depth) or this.nestedTree[depth] = "" {
            this.nestedTree[depth] := Map("parentChildLists", [], "startIndices", [], "flatLength", 0)
        }
        currentDepth := this.nestedTree[depth]
        ; Create new list of children (corresponding to a single parent in the layer above) if not already exists for a given depth
        if parentGroupIndex = "" {
            currentDepth["startIndices"].Push(currentDepth["flatLength"] + 1)
            currentDepth["parentChildLists"].Push([])
            parentGroupIndex := currentDepth["parentChildLists"].Length
            component.SetParentGroupIndex(parentGroupIndex)
        }
        ; Insert into the proper child list based on zIndex and save its place in the child list
        listIndex := ArrayHelper.BinaryInsert(
            arr := currentDepth["parentChildLists"][parentGroupIndex], 
            el := component,
            func := (el) => el.GetZIndex(),
            cond := (z1, z2) => z1 < z2
        )
        component.SetListIndex(listIndex)
        currentDepth["flatLength"] += 1
    }

    ; O(k) where k is the number of child components, added time if tree needs to compact afterwards
    Remove(component, initialCall := true) {
        ; listIndex => the index of this component within its respective child list
        component.GetRenderInfo(&depth, &parentGroupIndex, &listIndex)
        this.nestedTree[depth]["parentChildLists"][parentGroupIndex][listIndex] := ""
        ; Recursively remove all child components as well
        for childComponent in component.children {
            this.Remove(childComponent, false)
        }
        ; If the tree has too many empty values, we want to compact it
        this.dirtyFlagCount++
        if this.dirtyFlagCount >= 75 and initialCall {
            this.CompactTree()
            this.dirtyFlagCount := 0
        }
    }

    ; O(n) worst case, but usually better depending on how deep startingComponent is in the tree
    ForEach(callback, startingComponent := "", reverse := false, checkExistence := true, callbackOnComponent := true) {
        ; callback => function for performing operations on a given component
        ; startingComponent => indicates where we start from in the tree
        ; reverse => determines the order in which we iterate the tree
        ; checkExistence => determines whether we are performing the callback on components or empty spaces
        if !startingComponent {
            try {
                if !reverse {
                    startingComponent := this.nestedTree[1]["parentChildLists"][1][1]
                } else {
                    ; Safely get lastChildListIndex
                    lastChildListIndex := this.nestedTree[this.nestedTree.Length]["parentChildLists"].Length
                    if (lastChildListIndex > 0) {
                        lastChildIndex := this.nestedTree[this.nestedTree.Length]["parentChildLists"][lastChildListIndex].Length
                        if (lastChildIndex > 0) {
                            startingComponent := this.nestedTree[this.nestedTree.Length]["parentChildLists"][lastChildListIndex][lastChildIndex]
                        }
                    }
                }
            } catch {
                return
            }
        }        
        startingComponent.GetRenderInfo(&depth, &parentGroupIndex, &listIndex)
        ; Here we iterate every component on the same depth level as or below our component
        onFirstIteration := true
        currentDepthIndex := depth
        ; These lambdas are used for each loop to determine order of traversal (forward or reverse)
        condition := (index, length) => !reverse ? index <= length : index >= 1
        setIndex := (index, list) => onFirstIteration ? index : (!reverse ? 1 : list.Length)
        step := (index) => !reverse ? index + 1 : index - 1
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
                    currentComponent := componentGroup[currentListIndex]
                    if (checkExistence == !!currentComponent) {
                        if callbackOnComponent {
                            callback(currentComponent)
                        } else {
                            callback(currentDepthIndex, currentGroupIndex, currentListIndex)
                        }
                    }
                    currentListIndex := step(currentListIndex)
                }
                currentGroupIndex := step(currentGroupIndex)
            }
            onFirstIteration := false
            currentDepthIndex := step(currentDepthIndex)
        }
    }

    CompactTree() {
        callback := (depthIndex, groupIndex, listIndex) => this.CompactCallback(depthIndex, groupIndex, listIndex)
        this.ForEach(callback, , reverse := true, checkExistence := false, callbackOnComponent := false)
    }

    CompactCallback(currentDepthIndex, currentGroupIndex, currentListIndex) {
        parentChildLists := this.nestedTree[currentDepthIndex]["parentChildLists"]
        componentGroup := parentChildLists[currentGroupIndex]
        componentGroup.RemoveAt(currentListIndex)
        if componentGroup.Length == 0 {
            parentChildLists.RemoveAt(currentGroupIndex)
            if parentChildLists.Length == 0 {
                this.nestedTree.RemoveAt(currentDepthIndex)
            }
        }
    }
}

; EXAMPLE:
;
; depth = 2
; parentGroupIndex = 1
; [
;     { lists = [[c1, c2]], indices = [1], flatLength = 2 },
;     { lists = [[c1.2, c1.1], []], indices = [1], flatLength = 2 },
;     { lists = [[c1.2.1]], indices = [1], flatLength = 1 }
; ]

; c1 z=1 index=1
;     c1.1 z=100 index=
;     c1.2 z=2 index=1
;         c1.2.1 z=0 index=
; c2 z=1 index=
;     c2.1 z=10 index=
;     c2.2 z=0 index=
;         c2.2.1 z=0 index=
;             c2.2.1.1 z=0 index=
;         c2.2.2 z=0 index=
