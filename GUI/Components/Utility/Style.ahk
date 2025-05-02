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
        if !container.positionIsResolved {
            this.dimension.Resolve(parent)
        }
        switch(this.alignment.display) {
            case "flex":
                this.alignment.ResolveChildren(container)
        }
    }

    ToString() {
        return Format("{} {}", this.dimension.ToString(), this.appearance.ToString())
    }
}