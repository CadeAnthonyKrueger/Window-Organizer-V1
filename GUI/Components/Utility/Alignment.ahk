#Requires AutoHotkey v2.0

class Alignment {
    __New(display := "none", direction := "row", justify := "start", align := "start") {
        this.display := display
        this.flexDirection := direction
        this.justifyContent := justify
        this.alignItems := align
    }

    ResolveChildren(parent) {
        MsgBox(Format("Parent: {}", parent.style.ToString()))
        accumulatedOffset := 0
        for node in parent.children {
            node.style.dimension.Resolve(parent)
            dim := node.style.dimension
            switch(this.flexDirection) {
                case "row":
                    dim.y += accumulatedOffset
                    accumulatedOffset += dim.h
                case "column":
                    dim.x += accumulatedOffset
                    accumulatedOffset += dim.w
            }
        }
    }
}
