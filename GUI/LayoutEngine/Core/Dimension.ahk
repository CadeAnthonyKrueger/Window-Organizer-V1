#Requires AutoHotkey v2.0

class Dimension {
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
        parent.GetClientPos(&x, &y, &w, &h)
        this.x := x + this.ToPixels(this.relativeX, w)
        this.y := y + this.ToPixels(this.relativeY, h)
        this.w := this.ToPixels(this.relativeW, w)
        this.h := this.ToPixels(this.relativeH, h)
    }

    ToPixels(value, parentDim) {
        if Type(value) = "String" {
            value := Trim(value)
            if InStr(value, "%") && RegExMatch(value, "\d+", &match) {
                return Round(Number(match[0]) / 100 * parentDim)
            } else if RegExMatch(value, "i)^\s*(\d+)\s*px\s*$", &match) {
                return Number(match[1])
            } else if RegExMatch(value, "^\d+$", &match) {
                return Number(match[0])
            }
        } else if Type(value) = "Integer" {
            return value
        }
        return 0
    }

    ToString() {
        return Format("x{} y{} w{} h{}", this.x, this.y, this.w, this.h)
    }
}
