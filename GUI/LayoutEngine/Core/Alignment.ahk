#Requires AutoHotkey v2.0

#Include ./StyleAspect.ahk

class Alignment extends StyleAspect {
    __New(display := "none", flexDirection := "row", justify := "start", align := "start") {
        this.display := display
        this.flexDirection := flexDirection
        this.justifyContent := justify
        this.alignItems := align
    }

    ResolveChildren(container) {
        ; MsgBox(Format("Container: {}", container.ToString()))
        accumulatedOffset := 0
        for index, node in container.children {
            node.style.dimension.Resolve(container)
            dim := node.style.dimension
            switch(this.flexDirection) {
                case "column":
                    dim.y += accumulatedOffset
                    accumulatedOffset += dim.h
                case "row":
                    dim.x += accumulatedOffset
                    accumulatedOffset += dim.w
            }
            node.SetPositionResolved()
            ; MsgBox(Format("Child{}: {} Accumulated Offset: {}", index, node.ToString(), accumulatedOffset))
        }
    }

    static Defaults() {
        return Map(
            "display", "none",
            "flexDirection", "row",
            "justify", "start",
            "align", "start"
        )
    }

    static CallConstructor(map) {
        return Alignment(map["display"], map["flexDirection"], map["justify"], map["align"])
    }
}
