#Requires AutoHotkey v2.0

class DepthList {
    __New() {
        this.depthList := []
    }

    Push(element, depth) {
        if depth > this.depthList.Length {
            this.depthList.Push([])
        }
        this.depthList[depth].Push(element)
    }

    ForEach(func) {
        for depth, elements in this.depthList {
            for element in elements {
                func(element)
            }
        }
    }

    Clear() {
        this.depthList := []
    }
}
