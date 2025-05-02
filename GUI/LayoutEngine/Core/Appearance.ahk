#Requires AutoHotkey v2.0

class Appearance {
    __New(bg:=0xffffff, color:=0x000000) {
        this.backgroundColor := bg
        this.color := color
    }

    ToString() {
        return Format("Background{} c{}", this.backgroundColor, this.color)
    }
}