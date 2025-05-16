#Requires AutoHotkey v2.0 

#Include ../Utils/ArrayHelper.ahk

; ComponentTree is responsible for keeping a structured ordering of all the active components for a given window.
; This is used to perform efficient operations on components as well as keep things in proper order for rendering.
class ComponentTree {
    __New() {
        this.nestedTree := []
        this.removedIndexes := []
    }

    ; O(k + m) worst case, where k is the length of a given parentChildList and m is the length of a given depth's parentChildLists
    Add(component) {
        ; depth => distance from the root; parentGroupIndex => parent's index reference to it's children in the layer below
        component.GetTreeInfo(&depth, &parentGroupIndex)
        ; Create new layer if not already exists
        if !this.nestedTree.Has(depth) or this.nestedTree[depth] = "" {
            this.nestedTree[depth] := Map("parentChildLists", [])
        }
        currentDepth := this.nestedTree[depth]
        ; Create new list of children (corresponding to a single parent in the layer above) if not already exists for a given depth
        if parentGroupIndex = "" {
            ; Insert group in proper order based on parent ordering (updating other group indexes as you go)
            getParent := (el) => this.nestedTree[depth - 1][el.GetParentGroupIndex()][el.GetParentListIndex()]
            parentGroupIndex := ArrayHelper.ReverseInsert(
                arr := currentDepth["parentChildLists"],
                el := { 
                    parentGroup: parentGroupIndex, 
                    parentIndex: component.GetParentListIndex(),
                    list: []
                },
                func := (el) => getParent(el).SetChildGroupIndex((prev) => prev + 1),
                cond := (el1, el2) => getParent(el1).GetListIndex() < getParent(el2).GetListIndex()
            )
            component.SetParentGroupIndex((prev) => parentGroupIndex)
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

    ; O(1), added time if tree needs to compact afterwards
    Remove(component, initialCall := true) {
        component.GetTreeInfo(&depth, &parentGroupIndex, &listIndex)
        this.nestedTree[depth]["parentChildLists"][parentGroupIndex].list[listIndex] := ""
        this.removedIndexes.Push(
            Map("depth", depth, "parentGroupIndex", parentGroupIndex, "listIndex", listIndex)
        )
        ; If the tree has too many empty values, we want to compact it
        if this.removedIndexes.Length >= 75 and initialCall {
            this.CondenseTree()
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
        startingComponent.GetTreeInfo(&depth, &parentGroupIndex, &listIndex)
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
    CondenseTree() {
        ; For every space in the tree that has been removed 
        for emptySpace in this.removedIndexes {
            if !this.nestedTree.Has(emptySpace["depth"]) {
                continue
            }
            parentChildLists := this.nestedTree[emptySpace["depth"]]["parentChildLists"]
            ; Represents the layer above. Used to adjust parent child group indexes accordingly
            try parentLists := this.nestedTree[emptySpace["depth"] - 1]["parentChildLists"]
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
                try {
                    for group in ArrayHelper.SliceArray(parentChildLists, emptySpace["parentGroupIndex"]) {
                        parentLists[group.parentGroup][group.parentIndex].SetChildGroupIndex((prev) => prev - 1)
                    }
                }
                
                ; If this results in an entire depth being empty, this is the lowest depth in the tree and can be removed
                if parentChildLists.Length == 0 {
                    this.nestedTree.Length := emptySpace["depth"] - 1
                }
            }
        }
    }

    ; Print out the tree in a readable way for debugging and visualization
    PrintTree() {
        try
            rootList := this.nestedTree[1]["parentChildLists"][1]
        catch
            return
    
        treeString := ""
        addToTreeString := (t, n, z, d, g, i) => treeString .= Format("{}{} z={} depth={} group={} index={}`n", t, n, z, d, g, i)
    
        for root in rootList {
            if !IsObject(root)
                continue
            try {
                addToTreeString("", root.name, root.GetZIndex(), root.GetDepth(), root.GetChildGroupIndex(), root.GetListIndex())
                stack := Stack()
                stack.Push(Map("component", root, "indent", "`t"))
    
                while !stack.IsEmpty() {
                    item := stack.Pop()
                    comp := item["component"]
                    indent := item["indent"]
    
                    for child in comp.children {
                        if !IsObject(child)
                            continue
                        try {
                            addToTreeString(indent, child.name, child.GetZIndex(), child.GetDepth(), child.GetChildGroupIndex(), child.GetListIndex())
                            stack.Push(Map("component", child, "indent", indent . "`t"))
                        }
                    }
                }
            }
        }
    
        MsgBox treeString
        return treeString
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
