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
        ; Position elements relative to one another
        for index, node in container.children {
            node.style.dimension.Resolve(container)
            dim := node.style.dimension
            switch(this.flexDirection) {
                case "row":
                    dim.x += accumulatedOffset
                    accumulatedOffset += dim.w
                case "column":
                    dim.y += accumulatedOffset
                    accumulatedOffset += dim.h
            }
            node.SetPositionResolved()
            ; MsgBox(Format("Child{}: {} `nAccumulated Offset: {}", index, node.ToString(), accumulatedOffset))
        }
        ; Position elements relative to justifyContent
        previousElementSize := 0
        for index, node in container.children {
            MsgBox(node.style.ToString())
            dim := node.style.dimension
            switch(this.justifyContent) {
                case "end":
                    switch(this.flexDirection) {
                        case "row":
                            dim.x += container.style.dimension.w - accumulatedOffset
                        case "column":
                            dim.y += container.style.dimension.h - accumulatedOffset
                    }
                case "center":
                    switch(this.flexDirection) {
                        case "row":
                            dim.x += (container.style.dimension.w / 2) - (accumulatedOffset / 2)
                        case "column":
                            dim.y += (container.style.dimension.h / 2) - (accumulatedOffset / 2)
                    }
                case "space-between":
                    if index != 1 {
                        spaceAvailable := container.style.dimension.w - accumulatedOffset
                        gapSize := spaceAvailable / (container.children.Length - 1)
                        switch(this.flexDirection) {
                            case "row":
                                dim.x += gapSize * (index - 1)
                            case "column":
                                dim.y += gapSize * (index - 1)
                        }    
                    }
                case "space-evenly":
                    spaceAvailable := container.style.dimension.w - accumulatedOffset
                    gapSize := spaceAvailable / (container.children.Length + 1)
                    switch(this.flexDirection) {
                        case "row":
                            dim.x += gapSize * (index)
                        case "column":
                            dim.y += gapSize * (index)
                    }
                case "space-around":
                    spaceAvailable := container.style.dimension.w - accumulatedOffset
                    gapSize := spaceAvailable / (container.children.Length)
                    if index = 1 {
                        switch(this.flexDirection) {
                            case "row":
                                dim.x += (gapSize / 2)
                            case "column":
                                dim.y += (gapSize / 2)
                        }
                    } else {
                        switch(this.flexDirection) {
                            case "row":
                                dim.x += (gapSize / 2) + gapSize * (index - 1)
                            case "column":
                                dim.y += (gapSize / 2) + gapSize * (index - 1)
                        }
                    }
            }
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
