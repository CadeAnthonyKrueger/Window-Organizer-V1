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

        this.dimMap := Map("x", this.x, "y", this.y, "w", this.w, "h", this.h)
    }

    Resolve(parent) {
        x := 0, y := 0, w := 0, h := 0
        if parent != 0 {
            parent.GetClientPos(&x, &y, &w, &h)
        }
        this.x := x + PixelCalc.ToPixels(this.relativeX, w)
        this.y := y + PixelCalc.ToPixels(this.relativeY, h)
        this.w := PixelCalc.ToPixels(this.relativeW, w)
        this.h := PixelCalc.ToPixels(this.relativeH, h)
        return this
    }

    Get(key) {
        return this.%key%
    }

    Set(key, num) {
        this.%key% := num
        this.dimMap[key] := num
    }

    AddToValue(key, num) {
        MsgBox(Format("Setting {} `n- Previous Value: {} `n- Current Value: {}", key, this.Get(key), this.Get(key) + num))
        this.Set(key, this.Get(key) + num)
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
