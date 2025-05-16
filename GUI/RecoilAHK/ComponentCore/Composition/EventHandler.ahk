#Requires AutoHotkey v2.0 

#Include ../../Input/EventDispatcher.ahk

class EventHandler {
    __New(component) {
        this.component := component
        this.eventHandlers := Map()
    }

    On(event, callback) {
        this.eventHandlers[event] := callback
        EventDispatcher.Register(this, event)
    }

    FireEvent(event) {
        if this.eventHandlers.Has(event) {
            handler := this.eventHandlers[event]
            if IsSet(handler)
                handler.Call(this)
        }
    }
}