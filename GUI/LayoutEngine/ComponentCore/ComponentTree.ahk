#Requires AutoHotkey v2.0 

class ComponentTree {
    __New() {
        this.nestedTree := []
    }

    Add(component) {
        component.GetRenderInfo(&depth, &layer, &parentIndex)
        ; Create new layer if not already exists
        if !this.nestedTree.Has(depth) or this.nestedTree[depth] = "" {
            this.nestedTree[depth] := Map("parentChildLists", [], "startIndices", [], "flatLength", 0)
        }
        ; Create new list of children (corresponding to a single parent in the layer above) if not already exists for a given depth
        if !this.nestedTree[depth]["parentChildLists"].Has(parentIndex) or this.nestedTree[depth][parentIndex] = "" {
            this.nestedTree[depth]["startIndices"][parentIndex] := this.nestedTree[depth]["flatLength"] + 1
            this.nestedTree[depth]["parentChildLists"][parentIndex] := []
        }
        ; later we will incorporate sorting by zIndex instead of just pushing to the end
        this.nestedTree[depth]["parentChildLists"][parentIndex].Push(component)
        this.nestedTree[depth]["flatLength"] += 1
        component.SetTreeIndex(this.nestedTree[depth]["startIndices"][parentIndex] + this.nestedTree[depth]["parentChildLists"][parentIndex].Length - 1)
    }
}

depth = 3
parentIndex = 4
[
    { lists = [[c1, c2]], indices = [1], flatLength = 2 },
    { lists = [[c1.1, c1.2], [c2.1, c2.2]], indices = [1, 3], flatLength = 4 },
    { lists = [[c1.2.1]], indices = [1], flatLength = 1 }
]

c1 treeIndex = 1
    c1.1 treeIndex = 1
    c1.2 treeIndex = 2
        c1.2.1 treeIndex = 1
c2 treeIndex = 2
    c2.1 treeIndex = 3
    c2.2 treeIndex = 4
        c2.2.1
            c2.2.1.1
        c2.2.2
