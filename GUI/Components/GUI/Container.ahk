#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../../MainGUI.ahk
#Include ../Utility/Dimension.ahk

class Container {
    __New(dim, parentContainer := 0, color := "0xffffff") {
        this.parentContainer := parentContainer
        this.dim := dim
        myGui.GetClientPos(&x, &y, &w, &h)
        this.parentDimension := parentContainer != 0 ? parentContainer.dim : Dimension(0, 0, w, h)
        this.x := this.parentDimension.GetX() + dim.GetX()
        this.y := this.parentDimension.GetY() + dim.GetY()    
        this.w := dim.GetW()
        this.h := dim.GetH()
        this.control := myGui.AddText(Format("x{} y{} w{} h{} Background{}", this.x, this.y, this.w, this.h, color))
    }
}