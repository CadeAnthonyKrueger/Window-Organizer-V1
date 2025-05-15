#Requires AutoHotkey v2.0

class FlexLayout {

    static styleOptions := Map(
        "flexDirection", ["row", "column"],
        "justify", ["start", "center", "end", "space-between", "space-evenly", "space-around"],
        "align", ["start", "center", "end"]
    )

    __New(flexDirection, justify, align) {
        this.flexDirection := flexDirection
        this.justify := justify
        this.align := align

        this.mainAxis := (flexDirection = "row") ? Map("axis", "x", "dim", "w" ) : Map("axis", "y", "dim", "h" )
        this.altAxis := (flexDirection = "column") ? Map("axis", "x", "dim", "w" ) : Map("axis", "y", "dim", "h" )
    }

    ResolveChildren(container) {
        ; First pass resolves children relative to their container and siblings along the main axis (justify == "start").
        ; Also resolves children relative to just their container on the alt axis (align).
        accumulatedChildSize := 0
        for index, node in container.children {
            dim := node.ResolveDimensions()
            dim.AddToValue(this.mainAxis["axis"], accumulatedChildSize)
            accumulatedChildSize += dim.Get(this.mainAxis["dim"])
            this.AlignComponent(dim, container.GetDimensions())
            node.SetPositionResolved()
        }
        if (this.justify = "start") {
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
        switch(this.justify) {
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

    AlignComponent(dim, parentDim) {
        axisKey := this.altAxis["axis"]
        dimKey := this.altAxis["dim"]
        switch(this.align) {
            case "center":
                dim.AddToValue(axisKey, (parentDim.Get(dimKey) - dim.Get(dimKey)) / 2)
            case "end":
                dim.AddToValue(axisKey, parentDim.Get(dimKey) - dim.Get(dimKey))
        }
    }
}