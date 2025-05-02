#Requires AutoHotkey v2.0
#Include ./Dimension.ahk
#Include ./Alignment.ahk
#Include ./Appearance.ahk

class Style {
    __New(dimension := Dimension(), alignment := Alignment(), appearance := Appearance()) {
        this.dimension := dimension
        this.alignment := alignment
        this.appearance := appearance
    }

    ResolvePosition(container, parent) {
        if Type(parent) != "Gui" {
            switch(parent.style.alignment.display) {
                case "flex":
                    if !parent.AreChildrenResolved() {
                        this.alignment.ResolveChildren(parent)
                        parent.SetChildrenResolved()
                    }
                default:
                    this.dimension.Resolve(parent)
            }
        } else {
            this.dimension.Resolve(parent)
        }
    }

    ToString() {
        return Format("{} {}", this.dimension.ToString(), this.appearance.ToString())
    }
}