#Requires AutoHotkey v2.0

class Alignment {
    __New(display := "flex", direction := "row", justify := "start", align := "start") {
        this.display := display
        this.flexDirection := direction
        this.justifyContent := justify
        this.alignItems := align
    }

    
}
