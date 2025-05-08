#Requires AutoHotkey v2.0
#Include ./Dimension.ahk
#Include ./Alignment.ahk
#Include ./Appearance.ahk
#Include ../Utils/StyleMapper.ahk

class Style {
    __New(dimension := Dimension(), alignment := Alignment(), appearance := Appearance()) {
        this.dimension := dimension
        this.alignment := alignment
        this.appearance := appearance
    }

    ResolvePosition(component, parent) {
        if !component.positionIsResolved {
            this.dimension.Resolve(parent)
        }
        switch(this.alignment.display) {
            case "flex":
                this.alignment.ResolveChildren(component)
        }
    }

    Merge(partialStyle) {
        for key, value in ObjOwnProps(partialStyle) {
            this.%StrLower(StyleMapper.GetClassName(key))%.SetProperty(key, value)
        }
    }

    ToString() {
        return Format("{} {}", this.dimension.ToString(), this.appearance.ToString())
    }
}