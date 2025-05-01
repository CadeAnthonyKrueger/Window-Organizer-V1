#Requires AutoHotkey v2.0
#Include ../../MainGUI.ahk
#Include ../Utility/Style.ahk

; Alignment Styles:
; x, y, height, width, display, flex-direcion, justify-content, align-items, background-color, color

class Container {
    __New(parent := myGUI, style := Style()) {
        this.parent := parent
        this.style := style
        this.children := []

        parent.GetClientPos(&x, &y, &w, &h)
        style.ResolveDimension(x, y, w, h)

        this.control := myGui.AddText(this.style.ToString())
    }

    GetClientPos(&x, &y, &w, &h) {
        x := this.style.dimension.x
        y := this.style.dimension.y
        w := this.style.dimension.w
        h := this.style.dimension.h
    }
}