#Requires AutoHotkey v2.0

class Dimension {
    __New(x := 0, y := 0, w := 0, h := 0) {
        this.X := x
        this.Y := y
        this.W := w
        this.H := h
    }

    GetX() => this.X
    GetY() => this.Y
    GetW() => this.W
    GetH() => this.H
}
