#Requires AutoHotkey v2.0

#Include ./StyleAspect.ahk
#Include ./LayoutTypes/FlexLayout.ahk

class Alignment extends StyleAspect {
    __New(display := "none", flexDirection := "row", justify := "start", align := "start", zIndex := 0) {
        this.display := display
        this.flexDirection := flexDirection
        this.justify := justify
        this.align := align
        this.zIndex := zIndex
        this.layout := unset
    }

    ResolveChildren(container) {
        switch(this.display) {
            case "flex":
                this.layout := FlexLayout(this.flexDirection, this.justify, this.align)
                this.layout.ResolveChildren(container)
        }
    }

    static Defaults() {
        return Map(
            "display", "none",
            "flexDirection", "row",
            "justify", "start",
            "align", "start",
            "zIndex", 0
        )
    }

    static CallConstructor(map) {
        return Alignment(map["display"], map["flexDirection"], map["justify"], map["align"], map["zIndex"])
    }
}
