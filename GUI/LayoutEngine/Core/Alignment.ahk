#Requires AutoHotkey v2.0

#Include ./StyleAspect.ahk
#Include ./LayoutTypes/FlexLayout.ahk

class Alignment extends StyleAspect {
    __New(display := "none", flexDirection := "row", justify := "start", align := "start") {
        this.display := display
        this.flexDirection := flexDirection
        this.justifyContent := justify
        this.alignItems := align
        this.layout := unset
    }

    ResolveChildren(container) {
        switch(this.display) {
            case "flex":
                this.layout := FlexLayout(this.flexDirection, this.justifyContent, this.alignItems)
        }
        this.layout.ResolveChildren(container)
    }

    static Defaults() {
        return Map(
            "display", "none",
            "flexDirection", "row",
            "justify", "start",
            "align", "start"
        )
    }

    static CallConstructor(map) {
        return Alignment(map["display"], map["flexDirection"], map["justify"], map["align"])
    }
}
