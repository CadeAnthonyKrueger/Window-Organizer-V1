#Requires AutoHotkey v2.0

class FlexLayout {

    static styleOptions := Map(
        "flexDirection", ["row", "column"],
        "justifyContent", ["start", "center", "end", "space-between", "space-evenly", "space-around"],
        "alignItems", ["start", "center", "end"]
    )

    __New(flexDirection, justifyContent, alignItems) {
        this.flexDirection := flexDirection
        this.justifyContent := justifyContent
        this.alignItems := alignItems

        this.mainAxis := (flexDirection = "row") ? Map("axis", "x", "dim", "w" ) : Map("axis", "y", "dim", "h" )
        this.altAxis := (flexDirection = "column") ? Map("axis", "x", "dim", "w" ) : Map("axis", "y", "dim", "h" )
    }

    ResolveChildren(container) {
        ; First pass resolves children relative to their container and siblings along the main axis (justifyContent == "start").
        ; Also resolves children relative to just their container on the alt axis (alignItems).
        accumulatedChildSize := 0
        for index, node in container.children {
            dim := node.ResolveDimensions()
            dim.AddToValue(this.mainAxis["axis"], accumulatedChildSize)
            accumulatedChildSize += dim.Get(this.mainAxis["dim"])
            this.AlignComponent(dim)
            node.SetPositionResolved()
        }
        if (this.justifyContent = "start") {
            return
        }
        ; Second pass resolves children based on the justification of the parent
        spaceAvailable := container.GetDimensions().Get(this.mainAxis["dim"]) - accumulatedChildSize
        numChildren := container.children.Length
        for index, node in container.children {
            dim := node.GetDimensions()
            this.JustifyComponent(index, dim, spaceAvailable, numChildren)
        }
    }

    JustifyComponent(index, dim, spaceAvailable, numChildren) {
        switch(this.justifyContent) {
            case "center":
                dim.AddToValue(this.mainAxis["axis"], spaceAvailable / 2)
            case "end":
                dim.AddToValue(this.mainAxis["axis"], spaceAvailable)
            case "space-between":
                if index != 1 {
                    gap := spaceAvailable / (numChildren - 1)
                    dim.AddToValue(this.mainAxis["axis"], gap * (index - 1))
                }
            case "space-evenly":
                gap := spaceAvailable / (numChildren + 1)
                dim.AddToValue(this.mainAxis["axis"], gap * index)
            case "space-around":
                gap := spaceAvailable / numChildren
                if index = 1 {
                    dim.AddToValue(this.mainAxis["axis"], gap / 2)
                } else {
                    dim.AddToValue(this.mainAxis["axis"], (gap / 2) + gap * (index - 1))
                }
        }
    }

    AlignComponent(dim) {
        switch(this.alignItems) {
            case "center":
                dim.AddToValue(this.altAxis["axis"], (dim[this.altAxis["dim"]] - dim[this.altAxis["axis"]]) / 2)
            case "end":
                dim.AddToValue(this.altAxis["axis"], dim[this.altAxis["dim"]] - dim[this.altAxis["axis"]])
        }
    }
}