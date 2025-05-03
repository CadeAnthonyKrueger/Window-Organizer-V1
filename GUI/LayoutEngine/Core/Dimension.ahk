#Requires AutoHotkey v2.0
#Include ../Utils/PixelCalc.ahk
#Include ./StyleAspect.ahk

class Dimension extends StyleAspect {
    __New(x := 0, y := 0, w := 0, h := 0) {
        this.relativeX := x
        this.relativeY := y
        this.relativeW := w
        this.relativeH := h
        this.x := 0
        this.y := 0
        this.w := 0
        this.h := 0
    }

    Resolve(parent) {
        x := 0, y := 0, w := 0, h := 0
        if parent != 0 {
            parent.GetClientPos(&x, &y, &w, &h)
        }
        ; MsgBox(Format("Width: {} Height: {}", w, h))
        this.x := x + PixelCalc.ToPixels(this.relativeX, w)
        this.y := y + PixelCalc.ToPixels(this.relativeY, h)
        this.w := PixelCalc.ToPixels(this.relativeW, w)
        this.h := PixelCalc.ToPixels(this.relativeH, h)
    }

    static Defaults() {
        return Map("x", 0, "y", 0, "w", 0, "h", 0)
    }

    static CallConstructor(map) {
        return Dimension(map["x"], map["y"], map["w"], map["h"])
    }

    ToString() {
        return Format("x{} y{} w{} h{}", this.x, this.y, this.w, this.h)
    }
}
