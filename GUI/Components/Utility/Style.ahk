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

    ResolveDimension(parentX, parentY, parentW, parentH) {
        this.dimension.Resolve(parentX, parentY, parentW, parentH)
    }

    ToString() {
        return Format("{} {}", this.dimension.ToString(), this.appearance.ToString())
    }

    ; List() {
    ;     return Map(
    ;         "display", this.display,
    ;         "flexDirection", this.flexDirection,
    ;         "justifyContent", this.justifyContent,
    ;         "alignItems", this.alignItems,
    ;         "Background", this.backgroundColor,
    ;         "c", this.color
    ;     )
    ; }
}