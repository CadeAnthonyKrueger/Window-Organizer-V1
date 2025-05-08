#Requires AutoHotkey v2.0

#Include ./StyleAspect.ahk

class Appearance extends StyleAspect {
    __New(backgroundColor:=0xffffff, color:=0x000000) {
        this.backgroundColor := backgroundColor
        this.color := color
    }

    static Defaults() {
        return Map(
            "backgroundColor", 0xffffff,
            "color", 0x000000
        )
    }

    static CallConstructor(map) {
        return Appearance(map["backgroundColor"], map["color"])
    }

    ToString() {
        return Format("Background{} c{}", this.backgroundColor, this.color)
    }
}