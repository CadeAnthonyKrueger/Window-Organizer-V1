#Requires AutoHotkey v2.0

class DepthList {
    __New() {
        this.depthList := []  ; Initialize depthList as an array of arrays.
    }

    Push(element, depth) {
        if depth > this.depthList.Length {  ; Check if the depth array exists.
            this.depthList.Push([])  ; Initialize it if it doesn't exist.
        }
        this.depthList[depth].Push(element)  ; Add the element to the appropriate depth.
    }

    ForEach(func) {
        for depth, elements in this.depthList {  ; Iterate over each depth array.
            for element in elements {  ; Iterate over elements in the array at the current depth.
                func(element)
            }
        }
    }

    Clear() {
        this.depthList := []
    }
}
