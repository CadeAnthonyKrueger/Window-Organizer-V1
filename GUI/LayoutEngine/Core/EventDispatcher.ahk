#Requires AutoHotkey v2.0 

#Include ./Hoverable.ahk

class EventDispatcher {
    static hoverables := []

    static Register(component, event) {
        if event = "mouseEnter" || event = "mouseExit"
            EventDispatcher.hoverables.Push(Hoverable(component))
    }

    static HandleMouseMove(x, y) {
        for hoverable in EventDispatcher.hoverables
            hoverable.HandleMouseMove(x, y)
    }
}
