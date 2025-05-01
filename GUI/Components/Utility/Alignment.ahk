#Requires AutoHotkey v2.0

class Alignment {
    __New(display := "flex", direction := "row", justify := "start", align := "start") {
        this.display := display
        this.flexDirection := direction
        this.justifyContent := justify
        this.alignItems := align
    }

    ; List() {
    ;     return Map(
    ;         "display", this.display,
    ;         "flexDirection", this.flexDirection,
    ;         "justifyContent", this.justifyContent,
    ;         "alignItems", this.alignItems
    ;     )
    ; }
}
