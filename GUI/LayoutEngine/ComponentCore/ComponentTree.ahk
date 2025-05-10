#Requires AutoHotkey v2.0 

#Include ../Utils/ArrayHelper.ahk

class ComponentTree {
    __New() {
        this.nestedTree := []
    }

    Add(component) {
        ; depth => distance from the root; layer => zIndex within a parent; parentIndex => parent's index reference to it's children in the layer below
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
        ; Insert into the proper child list based on zIndex
        ArrayHelper.BinaryInsert(
            arr := currentDepth["parentChildLists"][parentGroupIndex], 
            el := component,
            func := (el) => el.GetZIndex(),
            cond := (z1, z2) => z1 < z2
        )
        currentDepth["flatLength"] += 1
    }
}

depth = 2
parentGroupIndex = 1
[
    { lists = [[c1, c2]], indices = [1], flatLength = 2 },
    { lists = [[c1.2, c1.1], []], indices = [1], flatLength = 2 },
    { lists = [[c1.2.1]], indices = [1], flatLength = 1 }
]

c1 z=1 index=1
    c1.1 z=100 index=
    c1.2 z=2 index=1
        c1.2.1 z=0 index=
c2 z=1 index=
    c2.1 z=10 index=
    c2.2 z=0 index=
        c2.2.1 z=0 index=
            c2.2.1.1 z=0 index=
        c2.2.2 z=0 index=
